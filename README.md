# This is a complete overhaul & update of the original Debloat Windows 10. It is constantly updated and should work on Windows 10 or 11.

Note that the original Debloat-Windows-10 is generally unmaintained and is not very useful for Windows 11.

This fork is designed for a complete debloat that also removes as many WebView2, Recall, and Copilot AI features as possible. It is unlikely to break any core Windows features, but still use with caution!

This fork includes additonal utilities in the `scripts` and `utils` folders.

Also, note that gaming-related apps and services will remain intact or will be reinstalled by default.

**There is no undo, but I recommend just running the express and tweaking any settings that you don't like aftwerwards.**

## Dependencies & Setup
0. I *highly* recommend using the !~~~Update_Everything script to update, and running this at startup to keep your system updated.
1. Install/Upgrade WinGet: https://apps.microsoft.com/detail/9nblggh4nns1
2. Use the "PowerShell v1.0 (Administrator)" shortcut (in the main folder) to run setup commands and install the newest PowerShell version:

    `winget install --id Microsoft.PowerShell --source winget --installer-type wix --accept-source-agreements --accept-package-agreements`
   
   NOTE: Microsoft is trying to deprecate the MSI installation (`--installer-type wix`) of PowerShell Core from winget. The MSI version is a system installation, and the "modern" MSIX version is not. If the MSIX version is installed, the shortcuts will not work. However, the scripts can still be run just fine from within PowerShell Core MSIX version.

4. Once the new PowerShell is installed, Use the PowerShell v7.x (Administrator)" shortcut to run the following:

    `Set-ExecutionPolicy Unrestricted`

    `ls -Recurse *.ps* | Unblock-File`

Setup is now complete.

## Usage

1. If not done, install all available updates for your system. Recommend using the !~~~Update_Everything script to do so.

**RECOMMENDED: Just run the `!~~~EXPRESS_DEBLOAT` shortcut from the main folder and it will run all the important debloat scripts with default settings!**

**Alternatively:**
Scripts are located in the "scripts" folder. Scripts can be run individually; pick what you need.
2. The scripts are designed to run without any user interaction. If necessary, edit the scripts to fit your need. Check the comments within each script.
3. Use the "Windows PowerShell 7.x (Administrator)" shortcut (in scripts folder) to easily run the scripts.

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
