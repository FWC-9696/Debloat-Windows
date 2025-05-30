#Disable Recall
Dism /Online /Get-Featureinfo /Featurename:Recall
Dism /Online /Disable-Feature /Featurename:Recall

#NVCleanstall (Updates Graphics Drivers)
Write-Host `n"Checking for Nvidia Driver Updates (if NVCleanstall is installed)..."
try{Start $env:ProgramFiles\NVCleanstall\NVCleanstall.exe}
catch{Write-Host "NVCleanstall is not installed."}

#Updates Windows Store Apps
Write-Host `n"Checking for Windows Store Updates..."
Start ms-windows-store://downloadsandupdates -ErrorAction SilentlyContinue

#Updates Windows
Write-Host `n"Checking for Windows Updates..."
Start-Process ms-settings:windowsupdate
USOClient StartInteractiveScan

#Update PowerToys
Write-Host `n"Checking for PowerToys Updates..."
try{Start-Process $env:LOCALAPPDATA\PowerToys\PowerToys.Update.exe -Verb RunAs}
catch{Write-Host "PowerToys is not installed."}

#Updates Other Programs
Write-Host `n"Checking for Software Updates..."
winget upgrade

Write-Host `n
Write-Host `n"To upgrade everything, run the following command:"
Write-Host "winget upgrade --all --accept-source-agreements --accept-package-agreements"
Write-Host `n"To upgrade an individual package, run:"
Write-Host "winget upgrade <ID>"

$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host `n 
Write-Host "Last Run: $date" `n `n