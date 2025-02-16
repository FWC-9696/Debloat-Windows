#Disable Recall
Dism /Online /Get-Featureinfo /Featurename:Recall
Dism /Online /Disable-Feature /Featurename:Recall

#NVCleanstall (Updates Graphics Drivers)
Write-Host `n"Checking for Nvidia Driver Updates (if NVCleanstall is installed)..."
try{Start $env:ProgramFiles\NVCleanstall\NVCleanstall.exe}
catch{Write-Output "NVCleanstall is not installed."}

#Updates Windows Store Apps
Write-Host `n"Checking for Windows Store Updates..."
Start ms-windows-store://downloadsandupdates -ErrorAction SilentlyContinue
Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod -ErrorAction SilentlyContinue

#Updates Windows
Write-Host `n"Checking for Windows Updates..."
Start-Process ms-settings:windowsupdate
USOClient StartInteractiveScan

#Update PowerToys
Write-Host `n"Checking for PowerToys Updates..."
try{Start-Process $env:LOCALAPPDATA\PowerToys\PowerToys.exe -Verb RunAs
Start-Process $env:LOCALAPPDATA\PowerToys\PowerToys.Update.exe -Verb RunAs}
catch{Write-Output "PowerToys is not installed."}

#Updates Other Programs
Write-Host `n"Checking for Software Updates..."
winget upgrade

Write-Host `n"To upgrade everything, run the following command:"
Write-Host "winget upgrade --all --accept-source-agreements --accept-package-agreements"
Write-Host `n"To upgrade an individual package, run:"
Write-Host "winget upgrade <ID>"