#####Remove Copilot Completely
Stop-Process -Name *Copilot* -Force

winget uninstall 9NHT9RB2F4HD #Microsoft Copilot App
if (Test-Path ${env:ProgramFiles(x86)}\Microsoft\Copilot) {
   try {
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\Copilot -ErrorAction  Break
   }
   catch {
    Stop-Process -Name *WebView* -Force
    Sleep 20
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\Copilot -ErrorAction  Continue
   }
   }
else {
    Write-Host "Copilot Not Found"
}
Write-Host ""
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

# 1. Identify the target folder using a wildcard (handles version numbers)
$folderPattern = "C:\Windows\SystemApps\MicrosoftWindows.Client.CoreAI_*"
$targetPath = Get-Item -Path $folderPattern -ErrorAction SilentlyContinue

if ($targetPath) {
    $fullPath = $targetPath.FullName
    Write-Host "Target identified: $fullPath" -ForegroundColor Cyan

    # 2. Take Ownership from TrustedInstaller
    Write-Host "Taking ownership..." -ForegroundColor Yellow
    takeown /f $fullPath /r /d y
    
    # 3. Grant Full Control to Administrators
    Write-Host "Granting Full Control..." -ForegroundColor Yellow
    icacls $fullPath /grant administrators:F /t /c /l /q

    # 4. Move to Recycle Bin via Shell COM Object
    Move-Item -Path $folderPattern -Destination "C:\Windows\Temp\" -Force
    Write-Host "Core AI Folder moved to Temp directory." -ForegroundColor Green

} else {
    Write-Host "CoreAI folder not found. It may already be removed or named differently." -ForegroundColor Red
}
Write-Host "Copilot Removed"
Write-Host ""