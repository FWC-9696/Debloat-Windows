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
Write-Host "Copilot Removed"
Write-Host ""