# Setup And Basic Use

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
rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --vfs-cache-mode full --vfs-cache-max-size 25G
```

> [!NOTE]
> "--vfs-cache-mode minimal" is required if you want to be able to edit and read the files.
> "--vfs-cache-mode full" uses more disc space but better performance.
> "--vfs-cache-max-size 25G" limits the cache to 25 gigabytes of cache.
> The ":" after your drive name is important, it tells rClone this is a remote drive.
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
alias fry-gdrive="rclone mount FrydmanLabGDrive: ~/rClone/rClone_FrydmanLabGDrive --vfs-cache-mode full --vfs-cache-max-size 25G"
alias stanford-gdrive="rclone mount StanfordGDrive: ~/rClone/rClone_StanfordGDrive --vfs-cache-mode full --vfs-cache-max-size 25G"
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
