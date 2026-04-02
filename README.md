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
mkdir ~/rClone/rClone_FrydmanLabGDrive    # Generate Directory for Syncing Files
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

> Move rClone to $PATH. This wil lask for your password (needs admin privileges).
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
Note: Although this is using a linux distro, the commands are basically the same. The main difference is that any local computer folder or file names will use a different syntax. (EG, "C:\Destination" vs "~/Destination")
```py
$ rclone config                             # Start rClone
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
rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive
```
Note: the ":" after your drive name is important, it tells rClone this is a remote drive.
This does not create a local copy, instead it treats the data like it is local.
If you want to create a local copy of your files, go to the next section.


### Quick Commands (bashrc, Linux Only)

Use this to make short versions of the above command to reduce type load
```py
sudo nano ~/.bashrc
```

Paste the following into the file that opens.
```py
# Mounts rClone Google Drives
alias fry-gdrive="rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive"
alias stanford-gdrive="rclone mount StanfordGDrive: ~/rClone/rClone_StanfordGDrive"
```

## Syncing and Copying

ommands generally follow the below format:
rclone <command> source:path dest:path [flags]

Sync Test
```py
rclone sync --dry-run FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive
```

Manual Sync
```py
rclone sync --interactive ~/rClone/rClone_FrydmanLabGDrive FrydmanLabGDrive:      # Sync to Drive
rclone sync --interactive FrydmanLabGDrive:  ~/rClone/rClone_FrydmanLabGDrive     # Sync from Drive
```

Manual Copy without Deleting Files
```py
rclone copy --interactive ~/rClone/rClone_FrydmanLabGDrive FrydmanLabGDrive:      # Saves to Drive
rclone copy --interactive FrydmanLabGDrive:  ~/rClone/rClone_FrydmanLabGDrive     # Saves from Drive
```
Note, you can specify specific folders to sync by adding the folder name after the cloud drive.

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
rclone bisync FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --resync    #The '--resnyc' flag is only needed for the first time you run this command for each drive.
```

#### (LINUX ONLY) Set up Cron Job to AUTOMATICALLY sync your files.

Check to see if cron is running
```py
$ service cron status
```

If it isn't running, start it.
```py
$ service cron start
$ service cron status                   # If it's running, proceed.
$ systemctl enable cron                 # Enable cron to run at start.
```

Create a scheduled cron job
```py
$ crontab -e                            # A new cron tab will be opened.
```

#### Mount your drive at boot
Add the following to your cron job config file.
```py
@reboot /usr/bin/rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive \ 
--log-file /var/log/rclone-photos.log --log-level INFO
```

#### Continuously sync a local copy to google drive (Set up Bisync BEFORE using this)
Add the following to your cron job config file.
```py
0 * * * * /usr/bin/rclone bisync ~/rClone/rClone_FrydmanLabGDrive FrydmanLabGDrive: \ 
--checkers 32 --transfers 8 --fast-list --tpslimit 8 \ 
--log-file /var/log/rclone-photos.log --log-level INFO
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
Files deleted from the source folder WILL not be deleted from the destination folder, so it is probably a good idea to avoid clogging up the destination folder with unwanted files by keepign them in a different folder.
