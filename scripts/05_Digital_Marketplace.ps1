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

    # Enable Edge uninstall option (Doesn't work)
    Set-ItemProperty -Path $dmaUninstallPath -Name "EnableEdgeUninstall" -Value 1 -Type DWord

    # Enable WebView2 uninstall option (Doesn't Work)
    Set-ItemProperty -Path $dmaUninstallPath -Name "EnableWebView2Uninstall" -Value 1 -Type DWord
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""
###Edit the JSON file to enable other options
$geoKey = "HKCU:\Control Panel\International\Geo"
$geo = (Get-ItemProperty -Path $geoKey -Name "Name").Name
Write-Host "Detected Region: $geo"

$jsonPath = "$env:windir\System32\IntegratedServicesRegionPolicySet.json"

takeown /F $jsonPath /A
icacls $jsonPath /grant Administrators:F

Get-Content $jsonPath | ConvertFrom-Json | Select-Object -ExpandProperty policies | Format-Table -AutoSize

$jsonRaw = Get-Content $jsonPath -Raw -ErrorAction Stop
$json = $jsonRaw | ConvertFrom-Json -ErrorAction Stop

$edgePolicy = $json.policies | Where-Object {$_.guid -match {1bca278a-5d11-4acf-ad2f-f9ab6d7f93a6} }

#Write-Host "$edgePolicy"
#Write-Host "$edgePolicy.defaultState"

Write-Host "Enable Edge Uninstallation"

if ($edgePolicy) {
    Write-Host "Found policy" -ForegroundColor Green
    
    # Add current region to enabled list if missing
    $enabledRegions = $edgePolicy.conditions.region.enabled
    if ($geo -notin $enabledRegions) {
        $edgePolicy.conditions.region.enabled += $geo
        Write-Host "→ Added '$geo' to enabled regions" -ForegroundColor Green
    } else {
        Write-Host "→ Region '$geo' already enabled" -ForegroundColor DarkGreen
    }
    $edgePolicy.defaultState = "enabled"
} else {
    Write-Warning "Policy not found in JSON. The file format may have changed."
}

Write-Host ""
Write-Host "Enable Microsoft Store Uninstallation"

$storePolicy = $json.policies | Where-Object {$_.guid -match {9a453b66-5ea7-4322-9aba-b054e914cc67} }

if ($storePolicy) {
    Write-Host "Found policy" -ForegroundColor Green
    
    # Add current region to enabled list if missing
    $enabledRegions = $storePolicy.conditions.region.enabled
    if ($geo -notin $enabledRegions) {
        $storePolicy.conditions.region.enabled += $geo
        Write-Host "→ Added '$geo' to enabled regions" -ForegroundColor Green
    } else {
        Write-Host "→ Region '$geo' already enabled" -ForegroundColor DarkGreen
    }
    $storePolicy.defaultState = "enabled"
} else {
    Write-Warning "Policy not found in JSON. The file format may have changed."
}


$json | ConvertTo-Json -Depth 100 | Set-Content $jsonPath -Force -Encoding UTF8
Write-Host ""
Write-Host "JSON file updated successfully." -ForegroundColor Green
Write-Host ""
Write-Host "Reboot Required. NOTE: YOU MUST SET ANOTHER DEFAULT BROWSER TO UNINSTALL EDGE!" -ForegroundColor Yellow
Write-Host ""