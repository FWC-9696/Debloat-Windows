#winget uninstall "Norton 360" ###Not needed if not installed
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Norton 360" -ErrorAction SilentlyContinue -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Norton 360" -Name "DisplayVersion" -Value 999 -Type String
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Norton 360" "DisplayVersion" -Value 999
Write-Output `n "Norton registry added. Reboot may be required."