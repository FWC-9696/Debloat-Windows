Write-Output `n "Showing all notification icons..." `n
New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name EnableAutoTray -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "EnableAutoTray" 0

#Remove-Item "$env:LOCALAPPDATA\Debloat-Windows\Notificaton_Icons.txt" -ErrorAction SilentlyContinue      #For Debugging
#New-Item "$env:LOCALAPPDATA\Debloat-Windows" -ItemType Directory -ErrorAction SilentlyContinue           #For Debugging

$iconPath = "HKCU:\Control Panel\NotifyIconSettings"
$keys = Get-ChildItem -Path $iconPath -Name
foreach ($key in $keys) {
    
    $key = -join($iconPath,'\',$key)
    
    Set-ItemProperty $key -Name IsPromoted -Value 1
    
    $Error.Clear()
        try{
        $iconName = Get-ItemPropertyValue $key -Name InitialTooltip
        }
        catch{
        "`t Promoting Icon: (Unknown Name)"
        }

    Write-Host "`t Promoting Icon: $iconName"

    #Add-Content -Value $key -Path "$env:LOCALAPPDATA\Debloat-Windows\Notification_Icons.txt"             #For Debugging
        }