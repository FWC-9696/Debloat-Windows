#Stop WebView
Stop-Process -Name *WebView* -Force

#Run Disable_Recall Script
$Path = $MyInvocation.MyCommand.Path
$Directory = Split-Path -Path $Path -Parent
& pwsh.exe -File $Directory\000_Disable_Recall.ps1

#NVCleanstall (Updates Graphics Drivers)
Write-Host 
Write-Host "Checking for Nvidia Driver Updates (if NVCleanstall is installed)..."
try{Start-Process $env:ProgramFiles\NVCleanstall\NVCleanstall.exe -NoNewWindow}
catch{Write-Host "NVCleanstall is not installed."}

#Gigabyte Command Center
Write-Host 
Write-Host "Checking for Gigabyte Driver Updates (if GCC is installed)..."
try{Start-Process "$env:ProgramFiles\GIGABYTE\Control Center\LaunchGCC.exe" -NoNewWindow}
catch{Write-Host "NVCleanstall is not installed."}

#Updates Windows Store Apps
Write-Host 
Write-Host "Checking for Windows Store Updates... (Manual -- Must click the button in Microsoft Store!)"
Start-Process ms-windows-store://downloadsandupdates

#Updates Windows
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AllowOptionalContent -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AllowOptionalContent -Value 1

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name SetAllowOptionalContent -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name SetAllowOptionalContent -Value 1

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name IsContinuousInnovationOptedIn -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "IsContinuousInnovationOptedIn" "1"

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name AllowMUUpdateService -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "AllowMUUpdateService" "1"

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name RestartNotificationsAllowed2 -Type DWORD -Value 1 -Force -ErrorAction SilentlyContinue
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "RestartNotificationsAllowed2" "1"

Write-Host 
Write-Host "Checking for Windows Updates..."
Start-Process ms-settings:windowsupdate
USOClient StartInteractiveScan

#Update PowerToys
Write-Host 
Write-Host "Checking for PowerToys Updates..."
try{Start-Process $env:LOCALAPPDATA\PowerToys\PowerToys.Update.exe -Verb RunAs}
catch{Write-Host "PowerToys is not installed."}
Write-Host

Write-Host "Checking for Edge Updates in the background..."
Start-Process ${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe
Write-Host
Write-Host "Checking for Firefox Updates in the background..."
try {Start-Process $env:ProgramFiles\Firefox*\updater.exe}
catch{Write-Host "Firefox is not installed."}

#This script will set the date/time based on location. Helpful for laptops.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output `n
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Output `n
Write-Host "Enabling Location and Setting Clock to Automatic"

###Location: Win10 Only
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableLocation" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableLocationScripting" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableSensors" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableWindowsLocationProvider" "0" -ErrorAction SilentlyContinue

###Location: Win11 Only
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Allow
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location\NonPackaged" -Name Value -Value Allow

$services = @(
    "tzautoupdate" #Automatically sets the system time zone.
    "lfsvc"        #This service monitors the current location of the system and manages geofences (a geographical location with associated events).  If you turn off this service, applications will be unable to use or receive notifications for geolocation or geofences.
    "W32Time"      #Maintains date and time synchronization on all clients and servers in the network. If this service is stopped, date and time synchronization will be unavailable. If this service is disabled, any services that explicitly depend on it will fail to start.
)

foreach ($service in $services) {
    Write-Output "Setting $service to Automatic"
    Get-Service -Name $service | Set-Service -StartupType Automatic
}

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

Write-Host `n
Write-Host "Clock & Timezone Synced."

Start-Service -Name W32Time -PassThru
Write-Host `n
W32tm /resync /force
Write-Host `n
Write-Host "Done"

#Updates Other Programs
Write-Host 
Write-Host "Checking for Software Updates..."
winget upgrade

Write-Host 
Write-Host "To upgrade everything, run the following command:"
Write-Host "winget upgrade --all --accept-source-agreements --accept-package-agreements"
Write-Host 
Write-Host "To upgrade an individual package, run:"
Write-Host "winget upgrade <ID>"
Write-Host
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "Last Run: $date" `n

#Open Resource Monitor
Invoke-Expression "$env:windir\system32\perfmon.exe /res"

#Uninstall WebView2
Stop-Process -Name *WebView* -Force
if (Test-Path ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView) {
   Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView
}
else {
    Write-Host "WebView Folder Not Found"
}
Write-Host "WebView Removed"
Write-Host ""