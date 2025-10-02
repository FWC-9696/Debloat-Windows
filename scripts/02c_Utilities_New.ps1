### The following script will perform various tweaks to Windows to improve overall performance ###


Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output `n "Elevating priviledges for this process" `n
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

######################################################################################################
### Optimizes Windows updates by disabling seeding updates to other computers. ###

Write-Output "############Optimize Windows updates############" `n

#Set Auto Update Options
New-FolderForced -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "ScheduledInstallDay" 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "ScheduledInstallTime" 3

#Disable seeding of updates to other computers via Registry
New-FolderForced -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0

#Enabling automatic driver update
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" "SearchOrderConfig" 2

$objSID = New-Object System.Security.Principal.SecurityIdentifier "S-1-1-0"
$EveryOne = $objSID.Translate( [System.Security.Principal.NTAccount]).Value

Write-Output `n "############Done############" `n

######################################################################################################
### Disable "Get More Out of Windows" reminder in the settings app in Windows 10. ###

Write-Output "############Disable Get More Out of Windows Popup############" `n

New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Type DWORD -Value 0 -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" "ScoobeSystemSettingEnabled" -Value 0 -Force

Write-Output `n "############Done############" `n

######################################################################################################
### Disable Windows Recall to the maximum extent practicable ###

Write-Output `n "############Disable Recall############" `n

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI" -Name DisableAIDataAnalysis -Type DWORD -Value 1  -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI" "DisableAIDataAnalysis" 1

New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsAI" -Name DisableAIDataAnalysis -Type DWORD -Value 1  -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsAI" "DisableAIDataAnalysis" 1

New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name TurnOffWindowsCopilot -Type DWORD -Value 1  -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" 1

New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name TurnOffWindowsCopilot -Type DWORD -Value 1  -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" 1

Write-Output `n "############Done############" `n

######################################################################################################
### Disable Edge Prelaunch ###

Write-Output `n "############Disable Edge Prefetch/Prelaunch############" `n

New-Item -Path "HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main" -Name AllowPreLaunch -Type DWORD -Value 0  -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main" "AllowPreLaunch" 0

New-Item -Path "HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main" -Name AllowTabPreLoading -Type DWORD -Value 0  -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\MicrosoftEdge\Main" "AllowTabPreLoading" 0

Write-Output `n "############Done############" `n

######################################################################################################
### SSD life improvement ###

Write-Output `n "#############SSD Tweaks############" `n

fsutil behavior set DisableLastAccess 1
fsutil behavior set EncryptPagingFile 0

Write-Output `n "############Done############" `n

######################################################################################################
### Disable Memory Compression (requires SysMain (service)) ###

Write-Output `n "############Disable Memory Compression############" `n

Disable-MMAgent -mc

Write-Output `n "############Done############" `n
