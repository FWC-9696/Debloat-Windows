#This script will automatically install some Game Launchers as shown below.
#The Xbox app is installed in 01_Install_Software.

Write-Host "Installing Game Launchets"
$apps = @(

    "Amazon.Games"               #Amazon Games
    #"Battle.net"                 #Battle.net
    "EpicGames.EpicGamesLauncher"#Epic Games Launcher
    "ElectronicArts.EADesktop"   #EA Desktop
    "GOG.Galaxy"                 #GOG Galaxy
    "Parsec.Parsec"              #Parsec
    "Valve.Steam"                #Steam
    "Ubisoft.Connect"            #Ubisoft Connect
    "9N201KQXS5BM"               #Call of Duty

)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }

Write-Host "Installing Rockstar Games Launcher (No Winget Package)"
sleep 3
Start-Process https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe #Rockstar Games Launcher

Write-Host "Minecraft Launcher"
sleep 3
Start-Process https://www.microsoft.com/store/productId/9PGW18NPBZV5

Write-Host "Downloading Xenia Manager & Xenia Patches zip files"
Start-Process https://github.com/xenia-manager/xenia-manager/releases/latest/
Start-Process https://github.com/xenia-canary/game-patches/releases/latest/download/game-patches.zip
Start-Process https://github.com/xenia-manager/xenia-manager/wiki/Quickstart