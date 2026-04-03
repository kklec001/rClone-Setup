# rClone-Setup
This is a tutorial for lab scientists that are unfamiliar with tools like rclone.
Please follow best practices for your institution and always check for the most up-to-date documentation.

Sources:
1: [rclone Installation](https://rclone.org/install/).
2: [rclone for Google Drive](https://rclone.org/drive/).
3: [Windows Automatic Syncing and bat File Creation](https://www.addictivetips.com/windows-tips/move-files-from-one-folder-to-another-after-x-days-windows-10/).

## Generate Directory for File Sync
### Linux
```py
mkdir ~/rClone/rClone_FrydmanLabGDrive       # Generate Dedicated Directory for Mounting Files
mkdir ~/rClone/Local_FrydmanLabGDrive        # Generate Directory for Syncing Local Files
```

### Windows
```bat
mkdir C:\rClone\rClone_FrydmanLabGDrive    &:: Generate Directory for Syncing Files
```

## Install rClone

### Linux
Change directory to Downloads
```py
cd ~/Downloads
```

Fetch and Unpack rClone
```py
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
```

Copy Binary
```py
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
```

Install
```py
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb
```

Update Packages
```py
sudo mandb
```
Restart PC - Open Terminal

### Windows

Open Windows Powershell as an administrator
```bat
winget install Rclone.Rclone
```

To uninstall, run the following.
```bat
winget uninstall Rclone.Rclone --force
```

### Mac

This installation method downloads from rClone directly and avoids issues with mounting.
Fetch and unpack the latest version of rClone
```py
cd && curl -O https://downloads.rclone.org/rclone-current-osx-amd64.zip
unzip -a rclone-current-osx-amd64.zip && cd rclone-*-osx-amd64
```

Move rClone to $PATH. This will ask for your password (needs admin privileges).
```py
sudo mkdir -p /usr/local/bin
sudo mv rclone /usr/local/bin/
```

Remove excess files.
```py
cd .. && rm -rf rclone-*-osx-amd64 rclone-current-osx-amd64.zip
```
Restart your PC and open terminal.

## Setup rClone (Frydman Lab GWE Google Drive Example, Assumes you are using a Linux Distro)
> [!NOTE]
> Although this is using a linux distro, the commands are basically the same. The main difference is that any local computer folder or file names will use a different syntax.
> (EG, "C:\Destination" vs "~/Destination")

All versions of rclone use the same command structure. Type or paste the following in your terminal.
```py
rclone config
```

You will see the following options pop up line by line. These are the reccomendations we received from Stanford, but you can always update or chnage this to suit your needs.
```py
    'e/n/d/r/c/s/q>'        n                   # Create New Remote
    'name>'                 FrydmanLabGDrive    # Name your drive
    'Storage>'              drive               # Google Drive
    'client_id>'                                # Leave Blank
    'client_secret>'                            # Leave Blank
    'scope>'                1                   # Access all files
    'root_folder_id>'                           # Leave Blank, auto-determined by rClone
    'service_account_file>'                     # Leave Blank
    `Edit advanced config?`
        'y/n>'              n                   # Default is no.
    `Use web browser to automatically authenticate rclone?`
        'y/n>'              y                   # Default is yes.
    # Browser will open - sign in to Google with <SUNet>@<PREFIX>.gwe.stanford.edu.
    # Login to Stanford and Authorize rClone.
    `Configure this as shared drive?`
        'y/n>'              n                   # Default is no.
    `Keep this "gwe" remote?`
        'y/e/d>'            y                   # Default is yes, saves your configuration.
    'e/n/d/r/c/s/q>'        q                   # Quit editor.
```

## Mount rClone at Sync Location

```py
rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --vfs-cache-mode >= minimal

# "--vfs-cache-mode >= minimal" is required if you want to be able to edit and read the files.
```
> [!NOTE] The ":" after your drive name is important, it tells rClone this is a remote drive.
> This does not create a local copy, instead it treats the data like it is local.
> If you want to create a local copy of your files, go to the next section.


### Quick Commands (bashrc, Linux Only)

Use this to make short versions of the above command to reduce type load
```py
sudo nano ~/.bashrc
```

Paste the following into the file that opens.
```py
# Mounts rClone Google Drives
alias fry-gdrive="rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --vfs-cache-mode >= minimal"
alias stanford-gdrive="rclone mount StanfordGDrive: ~/rClone/rClone_StanfordGDrive --vfs-cache-mode >= minimal"
```

## Syncing and Copying

Commands generally follow the below format:
rclone <command> source:path dest:path [flags]

Sync Test
```py
rclone sync --dry-run FrydmanLabGDrive: ~/rClone/Local_FrydmanLabGDrive --transfers 10 --tpslimit 10 -P
```
> [!NOTE]
> --transfers flag determines how many transfers occur per in prallel
> --tps flag limits API calls per second
> -p flag shows your progress

Manual Sync
```py
rclone sync ~/rClone/Local_FrydmanLabGDrive FrydmanLabGDrive: --transfers 10 --tpslimit 10 -P      # Sync to Drive
rclone sync FrydmanLabGDrive:  ~/rClone/Local_FrydmanLabGDrive --transfers 10 --tpslimit 10 -P     # Sync from Drive
```

Manual Copy without Deleting Files
```py
rclone copy ~/rClone/Local_FrydmanLabGDrive FrydmanLabGDrive: --transfers 10 --tpslimit 10 -P      # Saves to Drive
rclone copy FrydmanLabGDrive:  ~/rClone/Local_FrydmanLabGDrive --transfers 10 --tpslimit 10 -P     # Saves from Drive
```
> [!NOTE]
> You can specify specific folders to sync by adding the folder name after the cloud drive.

> [!WARNING]
> If you are saving from your Google Drive and it links to an external folder, rClone WILL download that external folder.
> Try to avoid syncing folders that you do not intend to keep locally by specifying the files you wish to sync.
> If you have a folder structure that looks like the below:
> > ```
> > MyFolder
> >     MyFile
> >     MyExternalFolder
> >         MyOtherFile
> >         Share link to MyFolder
> > ```
> rClone will recurse infinitely and you will have an infinitely large file. Ask me how I learned this!

### Bisync (Have a local copy synced to cloud and vice versa)

Set up 2-Way Sync (Must Run before Using Bisync)
```py
rclone bisync FrydmanLabGDrive: ~/rClone/Local_FrydmanLabGDrive --resync
```
> [!NOTE]
> The '--resnyc' flag is only needed for the first time you run this command for each drive.

#### (LINUX ONLY) Set up Cron Job to AUTOMATICALLY sync your files.

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

#### Mount your drive at boot

Create a chell script to run a program at boot.

I saved this in a folder under "rClone" called ".Scripts" to hide the folder.

To do this via commandline:
```py
mkdir ~/rClone/.Scripts/ && nano ~/rClone/.Scripts/rclone-automount.sh
```

And paste the following in the text editor:
```sh
#!/bin/bash
for i in {1..5}; do \
rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --vfs-cache-mode >= minimal && \
rclone mount StanfordGDrive: ~/rClone/rClone_StanfordGDrive --vfs-cache-mode >= minimal && \                    # Here, I am mounting ANOTHER drive! Two drives!
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
