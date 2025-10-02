# This is a fork of the original Debloat Windows 10. It is constantly updated and should work on Windows 10 or 11.

Note that the original Debloat-Windows-10 is generally unmaintained and is not very useful for Windows 11.

This fork is designed for a lighter debloat (that doesn't break important windows features) for gaming and general use.

This fork includes additonal utilities in the `scripts` and `utils` folders.

Also, note that gaming-related apps and services will remain intact or will be reinstalled by default.

**There is no undo**. Be sure to edit the scripts to your preference before running them. Also, there is no guarantee that everything will
work after future updates since I cannot predict what Microsoft will do next.

## Dependencies & Setup
1. Install/Upgrade WinGet: https://apps.microsoft.com/detail/9nblggh4nns1
2. Use the "PowerShell v1.0 (Administrator)" shortcut (in the main folder) to run setup commands and install the newest PowerShell version:

    `winget install Microsoft.Powershell --accept-source-agreements --accept-package-agreements`

3. Once the new PowerShell is installed, Use the PowerShell v7.x (Administrator)" shortcut to run the following:

    `Set-ExecutionPolicy Unrestricted`

    `ls -Recurse *.ps* | Unblock-File`

Setup is now complete.

## Usage

Scripts are located in the "scripts" folder. Scripts can be run individually; pick what you need.

1. Install all available updates for your system.
2. The scripts are designed to run without any user interaction. Edit the scripts to fit your need. Check the comments within each script.
3. Use the "Windows PowerShell 7.x (Administrator)" shortcut (in scripts folder) to easily run the scripts.

**Alternatively, Just run the `!~~~EXPRESS_DEBLOAT` shortcut from the main folder and it will run all the important debloat scripts with default settings!**

## Download Latest Version

Code located in the `master` branch is always considered under development, but
you'll probably want the most recent version anyway.

## License

    "THE BEER-WARE LICENSE" (Revision 42):

    As long as you retain this notice you can do whatever you want with this
    stuff. If we meet someday, and you think this stuff is worth it, you can
    buy us a beer in return.

    This project is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.
