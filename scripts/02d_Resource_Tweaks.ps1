# Reset all power schemes to system defaults
powercfg /restoredefaultschemes
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Ensure the script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges to modify power registry keys."
    exit
}

# Registry path for Windows 11 Power Overlays
$powerRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes"

# Modern Power Mode Overlay GUIDs
$bestEfficiency  = "961cc777-2547-4f9d-81f5-17dc36c04f90"
$bestPerformance = "ded574b5-45a0-4f42-8737-46345c09c238"

try {
    # Set 'Plugged In' (AC) to Best Performance
    Set-ItemProperty -Path $powerRegPath -Name "ActiveOverlayAcPowerScheme" -Value $bestPerformance -Type String -ErrorAction Stop

    # Set 'On Battery' (DC) to Best Efficiency
    Set-ItemProperty -Path $powerRegPath -Name "ActiveOverlayDcPowerScheme" -Value $bestEfficiency -Type String -ErrorAction Stop

    Write-Host "Registry overlays updated successfully." -ForegroundColor Cyan

    # Retrieve the current base power plan to trigger a refresh
    $currentSchemeOutput = powercfg /getactivescheme
    if ($currentSchemeOutput -match "([a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12})") {
        $activeGuid = $matches[1]
        
        # Re-applying the active base scheme forces Windows to re-read the overlay registry keys instantly
        powercfg /setactive $activeGuid
        Write-Host "Power subsystem refreshed. New overlays are active." -ForegroundColor Green
    } else {
        Write-Warning "Could not parse current power scheme. You may need to restart the 'Power' service or reboot to apply changes."
    }
}
catch {
    Write-Error "Failed to update power settings: $_"
}

#Turn off Power Throttling
#Write-Host  `n "Turning off Power Throttling" 
#New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -ErrorAction SilentlyContinue
#New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name PowerThrottlingOff -Type DWORD -Value 1 -ErrorAction SilentlyContinue
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "PowerThrottlingOff" -Value 1

#While this stops Windows from forcing background apps into a low-power state, it can sometimes cause a strange glitch in older power plans if they aren't fully refreshed
#locking the minimum state of the active profile to an arbitrary threshold because the OS loses fine-grained stepping control.

#Turn on Power Saver Always on Battery
Write-Host `n "Turn on Battery Saver"
powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 99
powercfg /setacvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 5

#Set CPU to 100% on AC and Power Saver on Battery
# --- AC POWER SETTINGS (Plugged In) ---
# Set Minimum and Maximum Processor State to 100%
powercfg /setacvalueindex SCHEME_CURRENT sub_processor PROCTHROTTLEMIN 100
powercfg /setacvalueindex SCHEME_CURRENT sub_processor PROCTHROTTLEMAX 100

# --- DC POWER SETTINGS (On Battery) ---
powercfg /setdcvalueindex SCHEME_CURRENT sub_processor PROCTHROTTLEMIN 5
powercfg /setdcvalueindex SCHEME_CURRENT sub_processor PROCTHROTTLEMAX 100

# --- UNHIDE PERFORMANCE BOOST MODE IN REGISTRY ---
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" "Attributes" -Value 2

# --- FORCE MAXIMUM FREQUENCY ENGAGEMENT ---
# AC Power: Force "Aggressive" frequency scaling (Locks at max base/turbo clock)
powercfg /setacvalueindex SCHEME_CURRENT sub_processor PERFBOOSTMODE 5

# DC Power (Battery): Set to "Efficient Aggressive" (Allows scaling down on battery)
powercfg /setdcvalueindex SCHEME_CURRENT sub_processor PERFBOOSTMODE 6

# --- CONFIGURE CPPC EPP FOR MAXIMUM EFFICIENCY ---
# AC Power: Absolute raw performance (0)
powercfg /setacvalueindex SCHEME_CURRENT sub_processor PERFEPP 0

# DC Power (Battery): Absolute maximum power savings (100)
powercfg /setdcvalueindex SCHEME_CURRENT sub_processor PERFEPP 100

#Turn ON CPU Core Parking (Battery)
Write-Host `n "Turn on CPU Core Parking for battery power" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" "Attributes" -Value 1

# --- AC POWER: DISABLE CORE PARKING ---
# Force 100% of your CPU cores to remain active/unparked at all times
powercfg /setacvalueindex SCHEME_CURRENT sub_processor CPMINCORES 100

# --- DC POWER (BATTERY): ENABLE CORE PARKING ---
# Allow the OS to park up to 95% of the cores if the system is idling
powercfg /setdcvalueindex SCHEME_CURRENT sub_processor CPMINCORES 0

Write-Host "Core parking explicitly configured: Disabled on AC, Optimized on Battery." -ForegroundColor Green

# --- APPLY CHANGES ---
# Refresh the power subsystem to make the changes take effect immediately
powercfg /setactive SCHEME_CURRENT

#Turn off network throttling
Write-Host `n "Turn off Network Throttling" 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" -Value 4294967295

#Increase system responsiveness
Write-Host `n "Increase System Responsiveness" 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" -Value 16

#Reduce Pre-Rendered Frames
Write-Host `n "Reduce Pre-Rendered Frames" 
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Direct3D" -Name MaxPreRenderedFrames -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Direct3D" "MaxPreRenderedFrames" -Value 1

#Prioritize Games
Write-Host `n "Prioritizing Games..."

Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" "AutoGameModeEnabled" -Value 1 -Type DWORD

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Affinity" -Value 15 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Background Only" False

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Background Priority" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Background Priority" -Value 1 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" -Value 8 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" -Value 6 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" High

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Pirority" High

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "SFIO Rate" -Value 4 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Rate" -Value 4 -Type DWord

Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" -Value 38

#Prioritize Gaming Network Traffic
Write-Host `n "Prioritizing Gaming Network Traffic"
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name "NonBestEffortLimit" -Value 0 -Type DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" "NonBestEffortLimit" -Value 0 -Type DWord

#Reduce Memory Paging
Write-Host `n "Reducing Paging File Use"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -Type DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" -Value 1 -Type DWord

Write-Host `n "Clear Paging File on Shutdown"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 1 -Type DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" -Value 1 -Type DWord

#Enable Connected Standby -- !!!!!This confilcts with CPU Core Parking. Do not un-comment for max performance on AC power.!!!!!
#Write-Host `n "Enable Modern Standby Network Connectivity (AC Power)"
#New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" -ErrorAction SilentlyContinue -Force
#New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" -Name "ACSettingIndex" -Value 1 -Type DWord -ErrorAction SilentlyContinue -Force
#Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" "ACSettingIndex" -Value 1 -Type DWord

#Write-Host `n "Enable Modern Standby Network Connectivity (Battery Power)"
#New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" -Name "DCSettingIndex" -Value 1 -Type DWord -ErrorAction SilentlyContinue -Force
#Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" "DCSettingIndex" -Value 1 -Type DWord

#Set Service Host Split Threshold (Reduces System Processes)
$SvcHostSplit = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1kb
Write-Host `n "This computer has $SvcHostSplit KB of physical RAM"
Write-Host `n "Reducing Idle Processes Count" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" -Value $SvcHostSplit

#Wait to kill services
Write-Host `n "Changing Kill Service Wait Time" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" -Value 2000
Write-Host