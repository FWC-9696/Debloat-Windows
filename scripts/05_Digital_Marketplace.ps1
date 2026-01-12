<# I got CoPilot to Vibecode this and then edited it a little bit.
Let's see how it works.
This apparently works for parts 1-4, but not for unistalling Edge.
#>
Write-Host "=== Enabling Digital Markets Act (DMA) Features ===" -ForegroundColor Cyan

try {
    # 1. Enable DMA core setting
    $dmaPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    if (-not (Test-Path $dmaPath)) {
        New-Item -Path $dmaPath -Force | Out-Null
    }
    Set-ItemProperty -Path $dmaPath -Name "DigitalMarketsActEnabled" -Value 1 -Type DWord

    # 2. Allow changing default apps more freely
    $defaultAppsPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations"
    if (-not (Test-Path $defaultAppsPath)) {
        New-Item -Path $defaultAppsPath -Force | Out-Null
    }
    Set-ItemProperty -Path $defaultAppsPath -Name "EnableDefaultAppChoice" -Value 1 -Type DWord

    # 3. Disable Bing in Windows Search (optional DMA-related tweak)
    $searchPath = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
    if (-not (Test-Path $searchPath)) {
        New-Item -Path $searchPath -Force | Out-Null
    }
    Set-ItemProperty -Path $searchPath -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord

    # 4. Enable browser choice screen
    $browserChoicePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
    if (-not (Test-Path $browserChoicePath)) {
        New-Item -Path $browserChoicePath -Force | Out-Null
    }
    Set-ItemProperty -Path $browserChoicePath -Name "ShowBrowserChoice" -Value 1 -Type DWord

    #5. Enable Uninstallation of Edge & Webview
    $dmaUninstallPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

    if (-not (Test-Path $dmaUninstallPath)) {
        New-Item -Path $dmaUninstallPath -Force | Out-Null
    }

    # Enable Edge uninstall option
    Set-ItemProperty -Path $dmaUninstallPath -Name "EnableEdgeUninstall" -Value 1 -Type DWord

    # Enable WebView2 uninstall option
    Set-ItemProperty -Path $dmaUninstallPath -Name "EnableWebView2Uninstall" -Value 1 -Type DWord

    Write-Host "`nEdge and WebView2 uninstall options enabled. Go to Settings → Apps to uninstall them." -ForegroundColor Green

    Write-Host "` All DMA-related features have been enabled. Please restart your PC for changes to take effect." -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}