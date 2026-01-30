#This will delete common temporary directories and might help fix Windows updates.
Write-Host ""
Write-Host "Pausing Windows Updates..." `n

$pause = (Get-Date).AddDays(1)
$pause = $pause.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$pause_start = (Get-Date)
$pause_start = $pause_start.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value $pause
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesStartTime' -Value $pause_start

Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' | Select-Object PauseUpdatesExpiryTime | Format-Table -AutoSize | Out-Host

Start-Sleep 1

Write-Host ""
Write-Host "Stopping Windows Update Services..." `n

Stop-Service -Name "wuauserv","BITS" -Force

Get-Service -Name "wuauserv","BITS" | Format-Table -AutoSize | Out-Host

Write-Host "Removing System Files..." `n

$directory = @(
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache" #Doesn't usually cause any issues with Windows Update.
    "$env:windir\SoftwareDistribution"
    )

    foreach ($directory in $directory) {
    Remove-Item $directory -Recurse -Force -ErrorAction Continue
    }
Write-Host ""
Write-Host "If you encountered errors deleting files, remove $env:windir\SoftwareDistribution manually." `n
Start-Sleep 5

Write-Host "Launching Disk Cleanup..." `n

Start-Process "$env:windir\system32\cleanmgr.exe" -Verb RunAs

Write-Host "Done. Unpause updates in settings." `n
Start-Process ms-settings:windowsupdate