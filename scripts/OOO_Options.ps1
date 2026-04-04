Write-Host ""
do {
    $continue = Read-Host "Use international time & date formats? (Y/N) (Default:[N])"
    $continue = $continue.Trim().ToUpper()  # Normalize input
} until ($continue -in @('Y','N',''))

if ($continue -eq 'Y') {
    Write-Host "Setting date & time format..." -ForegroundColor Green
    Set-ItemProperty -Path "HKCU:\Control Panel\International" "sTimeFormat" "HH:mm:ss"
    Set-ItemProperty -Path "HKCU:\Control Panel\International" "sShortDate" "yyyy-MM-dd"
} else {
    Write-Host "Skipping..." -ForegroundColor Green
}
#####
do {
    $continue = Read-Host "Enable Nearby Sharing? (Y/N) (Default: [N])"
    $continue = $continue.Trim().ToUpper()  # Normalize input
} until ($continue -in @('Y','N',''))
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name EnableCdp -Type DWORD -Value 0 -ErrorAction SilentlyContinue 
if ($continue -eq 'Y') {
    Write-Host "Enable Nearby Share" -ForegroundColor DarkCyan
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -Value 1
} else {
    Write-Host "Disable Nearby Share" -ForegroundColor DarkCyan
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -Value 0
}
######
do {
    $continue = Read-Host "Set desktop and apps back to light mode? (Y/N) (Default: [N])"
    $continue = $continue.Trim().ToUpper()  # Normalize input
} until ($continue -in @('Y','N',''))

if ($continue -eq 'Y') {
    Write-Host "Setting light mode..." -ForegroundColor Green
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 1
    } else {
    Write-Host "Setting dark mode..." -ForegroundColor Green
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0
}
    Write-Host "Done, Restarting Explorer..." -ForegroundColor Yellow
    taskkill /f /im explorer.exe
    Start-Sleep 1
    Start-Process explorer

