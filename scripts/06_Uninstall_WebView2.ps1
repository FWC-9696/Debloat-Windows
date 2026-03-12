Stop-Process -Name *WebView* -Force
if (Test-Path ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView) {
   try {
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView -ErrorAction  Break
   }
   catch {
    Stop-Process -Name *WebView* -Force
    Sleep 20
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView -ErrorAction  Continue
   }
   }
else {
    Write-Host "WebView Folder Not Found"
}
Write-Host "WebView Removed"
Write-Host ""