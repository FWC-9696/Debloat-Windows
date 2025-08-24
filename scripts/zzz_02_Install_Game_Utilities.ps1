#This script will automatically install some Windows Store apps
#To add apps to the list, find the app at https://apps.microsoft.com/store/apps
#In the address bar, copy the last piece of the link into the list
#i.e. https://apps.microsoft.com/store/detail/prime-video-for-windows/9P6RC76MSMMJ
#is for the prime video app, so you could add "9P6RC76MSMMJ" to the list to install it
#for programs not from the windows store, use the winget command in powershell to import/export

#Write-Host "Opening DS4Windows Download Page (No Winget Package)"
#sleep 3
#Start-Process https://github.com/Ryochan7/DS4Windows/releases

Write-Host "Installing Game Utilities"
$apps = @(

    #"Codeusa.BorderlessGaming"       #GREAT, Neccesary Utility for games that don't window properly
    "Guru3D.RTSS"                    #RivaTuner Statistics Server
    "LOOT.LOOT"                      #Load Order Optimization Tool (Modloader Used for Some Games)
    ###"PlayStation.DualSenseFWUpdater" #DualShock (PS5 Controller) Firmware Updater -- No longer works
    "Radmin.VPN"                     #Radmin VPN (Replaces LogMeIn Hamachi or LAN)
    "Logitech.GHUB"                  #Logitech G Hub
    #"ViGEm.ViGEmBus"                 #Nefarius Gamepad Emulator, Subcomponent of DS4Windows
    "MHNexus.HxD"                      #Hex editor
)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }

    Start-Process https://www.radmin-vpn.com/

    Start-Process https://controller.dl.playstation.net/controller/lang/en/2100004.html #PlayStation Accessories, replaces "DualSense Firmware Updater"