Set-ItemProperty -Path "HKCU:\Control Panel\International" "itime" "1"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sShortTime" "HH:mm"

# Define the registry path for Windows Location Services
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"

if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set Value to allow/turn on location services
Set-ItemProperty -Path $RegistryPath -Name "Value" -Value "Allow"

# Ensure the policy restriction path exists and set DisableLocation to 0
$PolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors"
if (-not (Test-Path $PolicyPath)) {
    New-Item -Path $PolicyPath -Force | Out-Null
}
Set-ItemProperty -Path $PolicyPath -Name "DisableLocation" -Value 0

# Ensure the Geolocation Service (lfsvc) is set to Automatic and started
Set-Service -Name "lfsvc" -StartupType Automatic -ErrorAction SilentlyContinue
Start-Service -Name "lfsvc" -ErrorAction SilentlyContinue

Write-Host "Location services have been enabled successfully." -ForegroundColor Green

# Check if the registry path exists, create it if missing
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set Value to deny/turn off location override
# Note: Depending on specific builds, the override configuration can also map to policies. 
# Here we target the primary capability policy key:
Set-ItemProperty -Path $RegistryPath -Name "Value" -Value "Deny"

# Define the registry path for the Allow Location Override setting
$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\UserLocationOverridePrivacySetting"

# Check if the registry path exists, create it if missing
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set the Value to 0 to turn "Allow location override" OFF
Set-ItemProperty -Path $RegistryPath -Name "Value" -Value 0 -Type DWORD

Write-Host "Allow location override has been turned off successfully." -ForegroundColor Green