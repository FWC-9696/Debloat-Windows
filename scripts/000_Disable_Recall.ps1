#Disable Recall if Enabled. Developed using https://github.com/antonflor/RecallManager/blob/main/RecallManager.ps1
$Recall = (dism /Online /Get-FeatureInfo /FeatureName:Recall)
    if ($Recall -like "*State : Enabled*") {
        Dism /Online /Disable-Feature /Featurename:Recall
        }
    if ($Recall -like "*State : Disabled*") {
        Write-Host 
        Write-Host "Recall is already disabled."
        }