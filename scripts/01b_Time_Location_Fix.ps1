###Sets date/time to international format
Set-ItemProperty -Path "HKCU:\Control Panel\International" "itime" "1"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sShortTime" "HH:mm"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sTimeFormat" "HH:mm:ss"
Set-ItemProperty -Path "HKCU:\Control Panel\International" "sShortDate" "yyyy-MM-dd"