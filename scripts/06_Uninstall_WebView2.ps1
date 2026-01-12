Stop-Process -Name *WebView*
Start-Sleep 5
Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\EdgeWebView\Application\*