# This will disable the Windows 11 Upgrade checking via registry options

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Output "Removing Windows 11 Hardware Checks"

New-ItemProperty -Path "HKLM:\SYSTEM\Setup\MoSetup" -Name AllowUpgradesWithUnsupportedTPMOrCPU -PropertyType DWORD -Value 1 -ErrorAction Continue
Set-ItemProperty -Path "HKLM:\SYSTEM\Setup\MoSetup" "AllowUpgradesWithUnsupportedTPMOrCPU" 1

New-Item -Path "HKLM:\SYSTEM\Setup\LabConfig"

New-ItemProperty -Path "HKLM:\SYSTEM\Setup\Labconfig" -Name BypassTPMCheck -PropertyType DWORD -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\Setup\Labconfig" "BypassTPMCheck" 1

New-ItemProperty -Path "HKLM:\SYSTEM\Setup\Labconfig" -Name BypassSecureBoot -PropertyType DWORD -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\Setup\Labconfig" "BypassSecureBoot" 1

New-ItemProperty -Path "HKLM:\SYSTEM\Setup\Labconfig" -Name BypassRAMCheck -PropertyType DWORD -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\Setup\Labconfig" "BypassRAMCheck" 1