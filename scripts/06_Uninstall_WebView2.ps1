Stop-Process -Name *WebView* -Force
if (Test-Path ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView) {
   try {
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView
    Write-Host "WebView Removed" -ForegroundColor Green
   }
   catch {
    Stop-Process -Name *WebView* -Force
    Wait-Process -Name *WebView*
    Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView -ErrorAction  Continue
    Write-Host "WebView Removed" -ForegroundColor Green
   }
   }
else {
    Write-Host "WebView Folder Not Found. It may already be removed." -ForegroundColor Yellow
}
Write-Host ""