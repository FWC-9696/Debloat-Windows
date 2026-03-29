#####Remove Copilot Completely
Stop-Process -Name *Copilot* -Force -ErrorAction Continue
Wait-Process -Name *Copilot*

winget uninstall 9NHT9RB2F4HD #Microsoft Copilot App
if (Test-Path ${env:ProgramFiles(x86)}\Microsoft\Copilot) {
   try {
    Write-Host "Attempting Copilot folder removal..." -ForegroundColor Cyan
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\Copilot -ErrorAction Continue
   }
   catch {
    Write-Host "Attempting Copilot folder removal..." -ForegroundColor Yellow
    Stop-Process -Name *Copilot* -Force -ErrorAction Continue
    Wait-Process -Name *Copilot*
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\Copilot -ErrorAction Continue
   }
   }
else {
    Write-Host ""
    Write-Host "Copilot not found. It may already be removed." -ForegroundColor Yellow
}
Write-Host ""

# 1. Identify the target folder using a wildcard (handles version numbers)
$folderPattern = "$env:windir\SystemApps\MicrosoftWindows.Client.CoreAI_*"
$targetPath = Get-Item -Path $folderPattern -ErrorAction SilentlyContinue
$random = Get-random
if ($targetPath) {

    Write-Host "Remove Core AI Features"
    $procs = @(
        "Copilot"    
        "ShellExperienceHost"
        "TextInputHost"
        "AIXHost"
        "Explorer"
    )
    foreach($proc in $procs){
        Write-Host "Stopping $proc..." -ForegroundColor Yellow
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
    
        # 2. Wait for the process to release handles
        Write-Host "Waiting for process to exit..." -ForegroundColor Cyan
        Wait-Process -Name $proc -ErrorAction SilentlyContinue
        Write-Host "$proc process terminated"
    }
    
    $fullPath = $targetPath.FullName
    Write-Host "Target identified: $fullPath" -ForegroundColor Cyan

    # 2. Take Ownership from TrustedInstaller
    Write-Host "Taking ownership..." -ForegroundColor Yellow
    takeown /f $fullPath /r /d y
    
    # 3. Grant Full Control to Administrators
    Write-Host "Granting Full Control..." -ForegroundColor Yellow
    icacls $fullPath /grant administrators:F /t /c /l /q

    # 4. Move to Recycle Bin via Shell COM Object
    New-Item -ItemType Directory -Path $env:systemdrive\Windows.old\$random -ErrorAction SilentlyContinue
    Move-Item -Path $folderPattern -Destination "$env:systemdrive\Windows.old\$random" -Force
    #Remove-Item "$env:windir\Temp\*" -Recurse -Force
    Write-Host "Core AI Folder removed." -ForegroundColor Green

} else {
    Write-Host "CoreAI folder not found. It may already be removed." -ForegroundColor Yellow
}
Write-Host ""
Write-Host "Copilot & AI features removed" -ForegroundColor Green