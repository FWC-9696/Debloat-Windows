#Disable Recall if Enabled. Developed using https://github.com/antonflor/RecallManager/blob/main/RecallManager.ps1
$Recall = (dism /Online /Get-FeatureInfo /FeatureName:Recall)
    if ($Recall -like "*State : Enabled*") {
        Dism /Online /Disable-Feature /Featurename:Recall
        }
    if ($Recall -like "*State : Disabled*") {
        Write-Host 
        Write-Host "Recall is already disabled."
        }

#NVCleanstall (Updates Graphics Drivers)
Write-Host 
Write-Host "Checking for Nvidia Driver Updates (if NVCleanstall is installed)..."
try{Start $env:ProgramFiles\NVCleanstall\NVCleanstall.exe}
catch{Write-Host "NVCleanstall is not installed."}

#Updates Windows Store Apps
Write-Host 
Write-Host "Checking for Windows Store Updates... (Manual -- Must click the button in Microsoft Store!)"
Start ms-windows-store://downloadsandupdates -ErrorAction SilentlyContinue

#Updates Windows
Write-Host 
Write-Host "Checking for Windows Updates..."
Start-Process ms-settings:windowsupdate
USOClient StartInteractiveScan

#Update PowerToys
Write-Host 
Write-Host "Checking for PowerToys Updates..."
try{Start-Process $env:LOCALAPPDATA\PowerToys\PowerToys.Update.exe -Verb RunAs}
catch{Write-Host "PowerToys is not installed."}
Write-Host

Write-Host "Checking for Edge Updates in the background..."
Start-Process ${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe
Write-Host

Write-Host "Checking for Firefox Updates in the background..."
try {Start-Process $env:ProgramFiles\Firefox*\updater.exe}
catch{Write-Host "Firefox is not installed."}

#Updates Other Programs
Write-Host 
Write-Host "Checking for Software Updates..."
winget upgrade

Write-Host 
Write-Host "To upgrade everything, run the following command:"
Write-Host "winget upgrade --all --accept-source-agreements --accept-package-agreements"
Write-Host 
Write-Host "To upgrade an individual package, run:"
Write-Host "winget upgrade <ID>"
Write-Host
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "Last Run: $date" `n