# Bisync for Advanced Users

## Bisync (Have a local copy synced to cloud and vice versa)

Set up 2-Way Sync (Must Run before Using Bisync)
```py
rclone bisync FrydmanLabGDrive: ~/rClone/Local_FrydmanLabGDrive --resync
```
> [!NOTE]
> The '--resnyc' flag is only needed for the first time you run this command for each drive.



-------
> [!WARNING]
> The following is a work in progress. Follow these instructions at your own peril.
-------

### (LINUX ONLY) Set up Cron Job to AUTOMATICALLY sync your files.

Check to see if cron is running
```py
service cron status
```

If it isn't running, start it.
```py
service cron start
service cron status                   # If it's running, proceed.
systemctl enable cron                 # Enable cron to run at start.
sudo systemctl enable cron.service    # Run cron at boot.
```

Create a scheduled cron job

```py
$ crontab -e                            # A new cron tab will be opened.
```

### Mount your drive at boot

Create a shell script to run a program at boot.

I saved this in a folder under "rClone" called ".Scripts" to hide the folder.

To do this via commandline:
```py
mkdir ~/rClone/.Scripts/ && nano ~/rClone/.Scripts/rclone-automount.sh
```

And paste the following in the text editor:
```sh
#!/bin/bash
for i in {1..5}; do \
rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --vfs-cache-mode full --vfs-cache-max-size 25G && \
rclone mount StanfordGDrive: ~/rClone/rClone_StanfordGDrive --vfs-cache-mode full --vfs-cache-max-size 25G && \                    # Here, I am mounting ANOTHER drive! Two drives!
break || sleep 5; done
```
save and close

> [!NOTE]
> For readability, I add "&& \" at the end of the line before startign a new line. This let's the program know you are running ANOTHER command and that this command is in the next line.
> The commands surrounding the job you want to run ("rclone mount", here) are actually a fail safe to rerun the job if it fails initially.
>
> The period in front of "/.Scripts" hides the folder from your file explorer. This is just to prevent accidental interaction or saving other files in there. It keeps the folder tidy.

Add the following to your cron job config file.
```py
SHELL=/bin/sh                    # Not needed if already added.
@reboot sh /rClone/.Scripts/rclone-automount.sh
```

> [!WARNING]
> Do not add empty paragraph spaces between commands in the file, you will get an error. The cron file works line by line, so any empty space will be interpreted as a command and it will be flagged.

#### Continuously sync a local copy to google drive (Set up Bisync BEFORE using this)

Create a shell script to run bisync:
```py
mkdir ~/rClone/.Scripts/ && \                                 # Unnecessary if you already made the directory.
nano ~/rClone/.Scripts/rclone-bisync-FrydmanLabGDrive.sh
```

And paste the following in the text editor:
```sh
#!/bin/bash
rclone bisync FrydmanLabGDrive: ~/rClone/Local_FrydmanLabGDrive --checkers 32 --transfers 8 --fast-list --tpslimit 8
```

Add the following to your cron job config file. The below will sync every 5 minutes.
```py
SHELL=/bin/sh                    # Not needed if already added.
0,5,10,15,20,25,30,35,40,45,50,55 * * * * sh ~/rClone/.Scripts/rclone-bisync-FrydmanLabGDrive.sh
```

With cron jobs, those asterisks correspond to the specific timing. If you want to adjust, you can change the values according to your desired timing.
```py
Asterix        Corresponds To        Common Values
'*' * * * *    Minute                * (Every minute), 1-59. This correlates to the system clock, so a value of '1' will cause the job to run at H:01:00 every hour.
* '*' * * *    Hour                  * (Every Hour), 1-12
* * '*' * *    Day                   * (Every day), 1-31
* * * '*' *    Month                 * (Monthly), 1-12
* * * * '*'    Weekday               * (Daily), 0-6

@reboot        During boot
```

### (WINDOWS ONLY) Scheduling Automatic Backups of Lab Computers

Automatic backup can be scheduled using Task Scheduler.
Open Windows "Task Scheduler" via the Home menu. You will revisit this later.
Open a new text file and paste the following text, changing both your source folder and destination folder (specified by "set"):
```bat
@echo off

set "source=C:\<Source Folder>"                         &:: Change this
set "destination=FrydmanLabGDrive:<DESTINATION>"        &:: Change this

rclone copy "%source%" "%destination%"                  &:: DO NOT TOUCH THIS

exit /b
```

Save as a ".bat" file with an obvious name (like "rclonebackup.bat") and save in a unique folder that will not be touched. To avoid problems, hide the folder so most users won't delete it by accident. This will copy files to a backup without deleting anything.
Open taks scheduler and create a new task. Set how often you want this to run and link your .bat file to the command. Save and Windows will run the command on a schedule.
Files deleted from the source folder WILL not be deleted from the destination folder, so it is probably a good idea to avoid clogging up the destination folder with unwanted files by keeping them in a different folder.
