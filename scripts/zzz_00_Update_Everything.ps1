Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Host ""
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

#Stop WebView
Stop-Process -Name *WebView* -Force

$services = @(
    "tzautoupdate" #Automatically sets the system time zone.
    "lfsvc"        #This service monitors the current location of the system and manages geofences (a geographical location with associated events).  If you turn off this service, applications will be unable to use or receive notifications for geolocation or geofences.
    "W32Time"      #Maintains date and time synchronization on all clients and servers in the network. If this service is stopped, date and time synchronization will be unavailable. If this service is disabled, any services that explicitly depend on it will fail to start.
    "wuauserv"     #Windows Update Service
    "InstallService" #Windows Store Installer Service
    "AppXSvc"      #Package Install Service
    "AppReadiness"               #Gets apps ready for use the first time a user signs in to this PC and when adding new apps. Needed for Windows Updates
    "BITS"                       #Background Intelligent Transfer Service
    "CryptSvc"                   #Cryptographic Service
    "wuauserv"                   #Remote Registry
)

foreach ($service in $services) {
    try {
        Start-Service -Name $service
        Write-Host "Started $service" -ForegroundColor Green
    }
    catch {
        Write-Host "Could not start $service" -ForegroundColor Gray
    }
}


$Path = $MyInvocation.MyCommand.Path
$Directory = Split-Path -Path $Path -Parent

#Run Disable_Recall Script
& pwsh.exe -File $Directory\000_Disable_Recall.ps1

#Dell Display & Peripheral Manager
Write-Host
Write-Host "Launching Dell Display & Peripheral Manager..." -ForegroundColor DarkCyan
try {
    Start-Process "$env:ProgramFiles\Dell\Dell Display and Peripheral Manager\DDPM.exe"
}
catch {
    Write-Host "Dell Display & Peripheral Manager is not installed."
}

#NVCleanstall (Updates Graphics Drivers)
Write-Host 
Write-Host "Checking for Nvidia Driver Updates (if NVCleanstall is installed)..." -ForegroundColor DarkCyan
Stop-Process -Name NVCleanstall -ErrorAction SilentlyContinue -Force
try{Start-Process $env:ProgramFiles\NVCleanstall\NVCleanstall.exe -NoNewWindow}
catch{Write-Host "NVCleanstall is not installed."}

#Gigabyte Command Center
Write-Host 
Write-Host "Checking for Gigabyte Driver Updates (if GCC is installed)..." -ForegroundColor DarkCyan
try{Start-Process "$env:ProgramFiles\GIGABYTE\Control Center\LaunchGCC.exe" -NoNewWindow}
catch{Write-Host "NVCleanstall is not installed."}

#Updates Windows Store Apps
Write-Host 
Write-Host "Checking for Windows Store Updates... (Manual -- Must click the button in Microsoft Store!)" -ForegroundColor DarkCyan
try {
    Start-Process ms-windows-store://downloadsandupdates -WindowStyle Minimized
}
catch {
    Write-Host "Windows Store is not installed, or an error has occured."
}

Write-Host 
Write-Host "Checking for Windows Updates..." -ForegroundColor DarkCyan
Start-Process ms-settings:windowsupdate -WindowStyle Minimized
USOClient StartInteractiveScan

#Update PowerToys
Write-Host 
Write-Host "Checking for PowerToys Updates..." -ForegroundColor DarkCyan
try{Start-Process $env:LOCALAPPDATA\PowerToys\PowerToys.Update.exe -Verb RunAs -WindowStyle Minimized}
catch{Write-Host "PowerToys is not installed."}

#Write-Host "Checking for Edge Updates in the background..."
#Start-Process ${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe
#Write-Host

#Write-Host "Checking for Firefox Updates in the background..."
#try {Start-Process $env:ProgramFiles\Firefox*\updater.exe}
#catch{Write-Host "Firefox is not installed."}

#This script will set the date/time based on location. Helpful for laptops.

Write-Host ""
Write-Host "Enabling Location and Setting Clock to Automatic" -ForegroundColor DarkCyan

###Location: Win10 Only
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableLocation" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableLocationScripting" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableSensors" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableWindowsLocationProvider" "0" -ErrorAction SilentlyContinue

###Location: Win11 Only
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Allow
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged" -Name Value -Value Allow

#Set Time and Time Zone Automatically
##Toggle OFF
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" "Type" "NoSync"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate\" "Start" "4"

#Delete Time Zone Information. Bad.
#Remove-Item "HKLM:\\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

##Toggle On
#New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name Type -ItemType DWORD -Value "NTP" -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" "Type" "NTP"
#New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate\" -Name Start -ItemType DWORD -Value 3 -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate\" "Start" "3"

Write-Host ""
Write-Host "Clock & Timezone Synced." -ForegroundColor Green

Start-Service -Name W32Time -PassThru
Write-Host ""
W32tm /resync /force
Write-Host ""
Write-Host "Done"
Write-Host ""

#Open Resource Monitor
Stop-Process -Name perfmon -ErrorAction SilentlyContinue -Force
Invoke-Expression "$env:windir\system32\perfmon.exe /res"

$Path = $MyInvocation.MyCommand.Path
$Directory = Split-Path -Path $Path -Parent

#Uninstall WebView2
& pwsh.exe -File $Directory\06_Uninstall_WebView2.ps1

#Uninstall Copilot
& pwsh.exe -File $Directory\07_Uninstall_Copilot.ps1

#Updates Other Programs
Write-Host 
Write-Host "Checking for Software Updates..." -ForegroundColor DarkCyan
winget upgrade

Write-Host 
Write-Host "To upgrade everything, run the following command:" -ForegroundColor Yellow
Write-Host "winget upgrade --all --accept-source-agreements --accept-package-agreements"
Write-Host 
Write-Host "To upgrade an individual package, run:" -ForegroundColor Yellow
Write-Host "winget upgrade <ID>"
Write-Host
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "Last Run: $date" `n -ForegroundColor Green

#Update Windows Update Policies in the background
$command={
Start-Sleep 30

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AllowOptionalContent -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AllowOptionalContent -Value "-"

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name SetAllowOptionalContent -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name SetAllowOptionalContent -Value "-" 

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name IsContinuousInnovationOptedIn -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "IsContinuousInnovationOptedIn" "1"

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name AllowMUUpdateService -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "AllowMUUpdateService" "1"

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name RestartNotificationsAllowed2 -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "RestartNotificationsAllowed2" "1"

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name AutoRebootLimitInDays -Type DWORD -Value 7 -Force -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "AutoRebootLimitInDays" "7" 

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name FlightSettingsMaxPauseDays -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "FlightSettingsMaxPauseDays" "3652"
}
Start-Process pwsh -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command $command" -WindowStyle Hidden