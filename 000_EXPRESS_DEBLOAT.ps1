#&".\scripts\00_Update_Windows.ps1
#sleep 10
$Path = $MyInvocation.MyCommand.Path
$Directory = Split-Path -Path $Path -Parent
& pwsh.exe -File $Directory\scripts\000_Disable_Recall.ps1
& pwsh.exe -File $Directory\scripts\01a_Optimize_UI_New.ps1
& pwsh.exe -File $Directory\scripts\01ab_ShowAllNotifs_Win11.ps1
& pwsh.exe -File $Directory\scripts\01b_Time_Location_Fix.ps1
& pwsh.exe -File $Directory\scripts\02a_Remove_Apps.ps1
& pwsh.exe -File $Directory\scripts\02b_Disable_Services_New.ps1
& pwsh.exe -File $Directory\scripts\02c_Utilities_New.ps1
& pwsh.exe -File $Directory\scripts\02d_Resource_Tweaks.ps1
& pwsh.exe -File $Directory\scripts\02e_GCC_Norton_Fix.ps1
& pwsh.exe -File $Directory\scripts\04_Hosts_File.ps1
& pwsh.exe -File $Directory\scripts\05_Digital_Marketplace.ps1
& pwsh.exe -File $Directory\scripts\06_Uninstall_WebView2
& pwsh.exe -File $Directory\scripts\01a_Optimize_UI_New.ps1

Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "You may now close this window or press enter to clean up hard drive."
Write-Host `n "Attend to the popup windows to change mouse settings and startup programs."
Write-Host `n "REBOOT IS REQUIRED"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Write-Host `n "###################################################################################"
Read-Host `n "Press any key to clean up hard drive, or exit this window."
& pwsh.exe -File $Directory\scripts\03_Clean_Up_Temp+Fix_Updates.ps1