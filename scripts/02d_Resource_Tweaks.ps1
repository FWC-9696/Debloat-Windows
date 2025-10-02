#Set Service Host Split Threshold (Reduces System Processes)
$SvcHostSplit = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1kb
Write-Host `n "This computer has $SvcHostSplit KB of physical RAM"
Write-Host `n "Reducing Idle Processes Count" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" -Value $SvcHostSplit

#Wait to kill services
Write-Host `n "Changing Kill Service Wait Time" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" -Value 2000

#Turn off Power Throttling
Write-Host  `n "Turning off Power Throttling" 
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name PowerThrottlingOff -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "PowerThrottlingOff" -Value 1

#Turn off CPU Core Parking
Write-Host `n "Turn off CPU Core Parking" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" "Attributes" -Value 0

#Turn off network throttling
Write-Host `n "Turn off Network Throttling" 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" -Value 4294967295

#Increase system responsiveness
Write-Host `n "Increase System Responsiveness" 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" -Value 16

#Reduce Pre-Rendered Frames
Write-Host `n "Reduce Pre-Rendered Frames" 
New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Direct3D" -Name MaxPreRenderedFrames -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Direct3D" "MaxPreRenderedFrames" -Value 1

#Prioritize Games
Write-Host `n "Prioritizing Games"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Affinity" -Value 15 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Background Only" False

New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Background Priority" -Value 1 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Background Priority" -Value 1 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" -Value 8 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" -Value 6 -Type DWord

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" High

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Pirority" High

New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "SFIO Rate" -Value 4 -Type DWord -ErrorAction SilentlyContinue
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Rate" -Value 4 -Type DWord

Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" -Value 38

#Prioritize Gaming Network Traffic
Write-Host `n "Prioritizing Gaming Network Traffic"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name "NonBestEffortLimit" -Value 0 -Type DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" "NonBestEffortLimit" -Value 0 -Type DWord

#Reduce Memory Paging
Write-Host `n "Reducing Paging File Use"
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Value 1 -Type DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" -Value 1 -Type DWord

Write-Host `n "Clear Paging File on Shutdown"
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 1 -Type DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" -Value 1 -Type DWord