#Disable Recall if Enabled. Developed using https://github.com/antonflor/RecallManager/blob/main/RecallManager.ps1
$Recall = (dism /Online /Get-FeatureInfo /FeatureName:Recall)
    if ($Recall -like "*State : Enabled*") {
        Dism /Online /Disable-Feature /Featurename:Recall
        }
    if ($Recall -like "*State : Disabled*") {
        Write-Host 
        Write-Host "Recall is already disabled."
        }
#Disable Experimental AI Agentic Features
Write-Output `n `t "Disable AI Agent Features"
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\IsoEnvBroker" -Name Enabled -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\IsoEnvBroker" -Name "Enabled" -Value 0

#Disable Nearby Share
Write-Output `n `t "Disable Nearby Share"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name EnableCdp -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableCdp" -Value 0