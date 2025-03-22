#This will delete common temporary directories and might help fix Windows updates.

Write-Host `n
Write-Host "Stopping Windows Update Service..." `n

Stop-Service -Name wuauserv -Force
Stop-Service -Name bits -Force
sleep 5
get-service bits, wuauserv

Write-Host `n
Write-Host "Removing System Files..." `n
#sleep 30

Remove-Item -Recurse -Force "$env:windir\temp\*" -ErrorAction SilentlyContinue

Remove-Item -Recurse -Force "$env:SystemDrive\Windows.Old" -ErrorAction SilentlyContinue

Remove-Item -Recurse -Force "$env:TEMP" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\AppData\Local\Microsoft\Windows\INetCache\*" -ErrorAction SilentlyContinue

Remove-Item -Recurse -Force "$env:SystemDrive\TEMP" -ErrorAction SilentlyContinue

Remove-Item -Recurse -Force "$env:windir\CarbonBlack" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\CbsTemp" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\ccmcache" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\CCM\Temp" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\CCM\Inventory\Temp" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\CCM\Logs\*" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\CCM\SystemTemp" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:windir\CCM\Staging\*" -ErrorAction SilentlyContinue

Remove-Item -Recurse -Force "$env:windir\SoftwareDistribution" -ErrorAction Continue

Write-Host "Launching Disk Cleanup..." `n

Start-Process "$env:windir\system32\cleanmgr.exe" -Verb RunAs -Wait

#Write-Host "Checking for Windows Updates..." `n

#Start-Process ms-settings:windowsupdate
#USOClient StartInteractiveScan

Write-Host "Done"