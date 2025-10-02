#&".\scripts\00_Update_Windows.ps1"
#sleep 10
& pwsh.exe ".\scripts\000_Disable_Recall.ps1"
& pwsh.exe ".\scripts\01a_Optimize_UI_New.ps1"
& pwsh.exe ".\scripts\01ab_ShowAllNotifs_Win11.ps1"
& pwsh.exe ".\scripts\01b_Time_Location_Fix.ps1"
& pwsh.exe ".\scripts\02a_Remove_Apps.ps1"
& pwsh.exe ".\scripts\02b_Disable_Services_New.ps1"
& pwsh.exe ".\scripts\02c_Utilities_New.ps1"
& pwsh.exe ".\scripts\02d_Resource_Tweaks.ps1"
& pwsh.exe ".\scripts\01a_Optimize_UI_New.ps1"

& Read-Host `n "Done. Press any key to clean up."
&".\scripts\03_Clean_Up_Temp+Fix_Updates.ps1"
#&".\scripts\zzz_00_Update_Everything.ps1"

& Write-Host `n "You may now close this window" `n "Some changes will require a reboot."