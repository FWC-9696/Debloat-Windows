#This will delete common temporary directories and might help fix Windows updates.

Write-Host `n
Write-Host "Stopping Windows Update Service..." `n

Stop-Service -Name wuauserv -Force
Stop-Service -Name bits -Force
sleep 5
get-service bits, wuauserv

Write-Host `n
Write-Host "Removing System Files..." `n


$directory = @(
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*"
    "$env:windir\SoftwareDistribution\*"
    )

    foreach ($directory in $directory) {
    Get-ChildItem -Path $directory | Remove-Item -Force -Recurse
    }

    $top_directory = @(
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
    "$env:windir\SoftwareDistribution"
    )

    foreach ($top_directory in $top_directory) {
    Remove-Item $top_directory -Recurse -Force
    }
Write-Host `n "If you encountered errors deleting files, remove $env:windir\SoftwareDistribution manually."
sleep 5

Write-Host `n "Launching Disk Cleanup..." `n

Start-Process "$env:windir\system32\cleanmgr.exe" -Verb RunAs -Wait

Write-Host "Done"