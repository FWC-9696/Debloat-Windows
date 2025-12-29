$winget="$env:LOCALAPPDATA\Microsoft\WinGet\Packages\"
$caffeine=Get-ChildItem -Path $winget\*Caffeine* -Name
$caffeine64=$winget+$caffeine+"\caffeine64.exe"
Write-Host $caffeine64
Invoke-Expression "$caffeine64 -Replace -Notwhenlocked"