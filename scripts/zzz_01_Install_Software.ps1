#This script will automatically install some Windows Store apps
#To add apps to the list, use "winget search <appname>" to find the app ID

Write-Host "Installing Software"
$apps = @(
    #Microsoft Tools & Apps
    "Microsoft.PowerShell"     #Latest Version of PowerShell
    "Microsoft.VisualStudioCode.Insiders" #VSCode
    "9NBLGGH4NNS1"             #Update Winget itself
    "9N8MHTPHNGVV"             #Advanced Settings
    #"Microsoft.PowerToys"      #PowerToys
    "9P7KNL5RWT25"             #Microsoft Sysinternals Suite (Includes Process explorer & Other Tools)
    #"9MV0B5HZVK9Z"             #Xbox
    "9NZKPSTSNW4P"             #Xbox Game Bar
    "9PLDPG46G47Z"             #Xbox Insider Hub
    "9MZ95KL8MR0L"             #Snip and Sketch (New Snipping Tool)
    "9N8WTRRSQ8F7"             #Diagnostic Data Viewer
    "9WZDNCRFJBH4"             #Microsoft Photos
    "9N8G5RFZ9XK3"             #Windows Terminal Preview
    #"9WZDNCRFJ3P2"             #Windows Movies & TV
    #"9N95Q1ZZPMH4"             #MPEG-2 Video Extension
    #"9NBLGGH10PG8"             #Microsoft People
    #"9WZDNCRFJ3PT"             #Groove Music
    #"9WZDNCRFJ1P3"	            #One Drive
    #"9PGW18NPBZV5"             #Minecraft Launcher, Doesn't work; Needs to be installed through Store/Xbox App
    
    #Caffiene
    "ZhornSoftware.Caffeine"     #Keep Screen Awake
    ###Doesn't create start menu entry. See shortcuts.

    #HWInfo
    REALiX.HWinfo

    #Prime95 (Usefull for Stress Tests)
    mersenne.prime95

    #Rufus
    "Rufus.Rufus"                #Mounts ISOs

    #Graphics Editors
    "9NBHCS1LX4R0"             #Paint.net Windows Store Version (Paid)
    #"dotPDN.PaintDotNet"       #Paint.Net Classic Version (Free)
    "Inkscape.Inkscape"        #Inkscape, used for making/editing .svg files
    
    #Non-Windows UWP Apps
    "XP9M26RSCLNT88"           #Tree Size, for determining sizes of folders
    #"XPFCG5NRKXQPKT"           #Foxit PDF Reader

    #Email Clients
    #"Mozilla.Thunderbird"      #Mozilla Thunderbird Email Client
    #Mozilla Thunderbird Beta   #See Below
    #"9WZDNCRFHVQM"             #Mail and Calendar (Old)
    #"9NRX63209R7B"             #Outlook for Windows (Replacement for Mail & Calendar)

    #Logitech
    #"Logitech.UnifyingSoftware" #Logitech Unifying Software ### DEPRECATED DO NOT USE
    "Logitech.OptionsPlus"      #Logitech Software for consumer-series
    "Logitech.GHub"             #Logitech Software for G-series

    #Fan Control
    "Rem0o.FanControl"          #Can controll graphics card fan speeds

     #Graphics Drivers
    
    #"TechPowerUp.NVCleanstall"     #NVCleanstall, See Bottom of script
    #######"9NZ1BJQN6BHL"                 #AMD Radeon Software -- DON'T USE THIS Version. See bottom for correct version.
    #"DisplayLink.GraphicsDriver"  #DisplayLink Graphics Driver
    #"9N09F8V8FS02"                 #DisplayLink Manager
          
    #Other Software
    #"Oracle.JavaRuntimeEnvironment"     #Java
    #"VideoLAN.VLC"                      #VLC Media Player
    #"TheDocumentFoundation.LibreOffice"  #LibreOffice
    #"Audacity.Audacity"                  #Audacity
    
    #Printer Apps
    #"9WZDNCRFJ14K"             #Cannon Inkjet Print Utility
    #"9WZDNCRFHWLH"             #HP Smart

    #Acer App
    #"9MZPX5WCBMWT"               #Control Center, gives Serial Number for Acer PCs
)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }

Write-Host `n"Graphics Drivers:"
$graphics = Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name
if ($graphics -like "*AMD*") {
    Write-Host $graphics
    Write-Host `n
    Start-Process https://www.amd.com/en/support #AMD Software
}
if ($graphics -like "*NVidia*") {
    Write-Host $graphics
    Write-Host `n
    Winget install TechPowerUp.NVCleanstall
}