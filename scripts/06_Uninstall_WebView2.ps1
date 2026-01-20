Stop-Process -Name *WebView*
Start-Sleep 10
Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView
Start-Sleep 5
Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView
Write-Output "WebView2 Removed"