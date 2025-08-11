#This script will reformat the date/time to international format and set the date/time based on location. Helpful for laptops.

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Host "Enabling Location and Setting Clock to Automatic"

###Location: Win10 Only
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableLocation" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableLocationScripting" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableSensors" "0" -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors\" "DisableWindowsLocationProvider" "0" -ErrorAction SilentlyContinue

###Location: Win11 Only
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Allow

###Time Format
Set-ItemProperty -Path "HKCU:\Control Panel\International" "itime" "1"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sShortTime" "HH:mm"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sTimeFormat" "HH:mm:ss"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sShortDate" "yyyy-MM-dd"

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
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" "Start" -Value 4
##Toggle On
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" "Type" "NTP"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" "Start" -Value 3

Write-Host `n
Write-Host "Clock & Timezone Synced."

Start-Service -Name W32Time -PassThru
Write-Host `n
W32tm /resync /force
Write-Host `n
Write-Host "Done"