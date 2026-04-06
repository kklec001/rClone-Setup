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

This operation will require a tool called Winget - this is not installed on some Windows PCs, but it should be available on most.
If you run into an issue with winget, skip to "Install Winget".

Open Windows Powershell as an administrator
```bat
winget install Rclone.Rclone
```

To uninstall, run the following.
```bat
winget uninstall Rclone.Rclone --force
```

#### Install Winget

Download the (Winget Dependencies)[https://github.com/microsoft/winget-cli/releases/download/v1.12.350/DesktopAppInstaller_Dependencies.zip] and unzip the folder into your downloads.

Open Windows Powershell as an administrator.
```bash
cd C:\Users\<USERNAME>\Downloads\DesktopAppInstaller_Dependencies
```

Install Appx Packages
```bash
Add-AppxPackage .\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x64.appx
Add-AppxPackage .\Microsoft.VCLibs.140.00_14.0.33519.0_x64.appx
Add-AppxPackage .\Microsoft.WindowsAppRuntime.1.8_8000.616.304.0_x64.appx
```

Via browser, install the (Winget Installer)[https://github.com/microsoft/winget-cli/releases/download/v1.12.350/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle] and (Winget License File)[https://github.com/microsoft/winget-cli/releases/download/v1.12.350/e53e159d00e04f729cc2180cffd1c02e_License1.xml]; save both to your downloads folder.

Open Windows powershell as an administrator and change your directory to where you downloaded the files.
```bash
cd C:\Users\<USERNAME>\Downloads
```

Install via commandline using Appx
```bash
Add-AppxProvisionedPackage -Online `
  -PackagePath .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle `
  -LicensePath .\e53e159d00e04f729cc2180cffd1c02e_License1.xml
```

Verify the install.
```bash
winget --version
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
