# This will disable a lot of the visual effects in Windows

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output `n "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Output `n "Adjust Appearance and Performance of Windows"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 2
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 3

Write-Output `n "Fixing Touchpad Options"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name ScrollDirection -Type DWORD -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" "ScrollDirection" 0
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name TapsEnabled -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" "TapsEnabled" 1
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name ThreeFingerTapEnabled -Type DWORD -Value 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" -Name ThreeFingerTapEnabled -Value 4

Write-Output `n "Apply MarkC's mouse acceleration fix"
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "MouseSensitivity" "10"
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "MouseSpeed" "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "MouseThreshold1" "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "MouseThreshold2" "0"
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "SmoothMouseXCurve" ([byte[]](0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xCC, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00,
0x80, 0x99, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x66, 0x26, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x33, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00))
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "SmoothMouseYCurve" ([byte[]](0x00, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA8, 0x00, 0x00,
0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00))
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" "ActiveWindowTracking" "1"

Write-Output `n "Disable easy access keyboard stuff"
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122"
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"

Write-Output `n "Disable Edge desktop shortcut on new profiles"
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name DisableEdgeDesktopShortcutCreation -Type DWORD -Value 1 -ErrorAction SilentlyContinue

Write-Output `n "Setting folder view options"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSuperHidden" 1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "IconsOnly" 0

Write-Output `n "Disable Aero-Shake Minimize feature"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisallowShaking" 1

Write-Output `n "Setting default explorer view to This PC"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

Write-Output `n "Disable Hybrid Shutdown"
powercfg -h off

Write-Output `n "Hide The Search Bar"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name IsDynamicSearchBoxEnabled -Type DWORD -Value 0  -ErrorAction SilentlyContinue  -Force #Hide Search (Win 11)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" "IsDynamicSearchBoxEnabled" 0
New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Search" -Name DisableSearch -Type DWORD -Value 1 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Search" "DisableSearch" 1

Write-Output `n "Showing Scroll Bars"
New-Item -Path "HKCU:\Control Panel\Accessibility" -Name DynamicScrollbars -Type DWORD -Value 0 -ErrorAction SilentlyContinue  -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility" "DynamicScrollbars" 0

Write-Output `n "Setting Windows 10/11 Display Options"

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name IsBatteryPercentageEnabled -ItemType DWORD -Value 1 -ErrorAction SilentlyContinue  #Show Battery % in Taskbar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "IsBatteryPercentageEnabled" 1

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name SystemUsesLightTheme -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name EnableTransparency -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 0

New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarAL -PropertyType DWORD -Value 0                #Set Taskbar to Left (0) or Center (1) (Win 11)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAL" 0

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_ShowClassicMode -Type DWORD -Value 1 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_ShowClassicMode" 1

New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" 0

Write-Output `n "Disabling Copilot"
New-FolderForced "HKCU:Software\Policies\Microsoft\Windows\WindowsCopilot"
New-Item -Path "HKCU:Software\Policies\Microsoft\Windows\WindowsCopilot" -Name TurnOffWindowsCopilot -Type DWORD -Value 1 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:Software\Policies\Microsoft\Windows\WindowsCopilot" "TurnOffWindowsCopilot" 1

Write-Output `n "Stopping Newsfeed from Opening on Hover"
New-Item -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Feeds" -Name ShellFeedsTaskbarOpenOnHover -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Feeds" "ShellFeedsTaskbarOpenOnHover" 0
New-Item -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Feeds" -Name OpenOnHover -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Feeds" "OpenOnHover" 0
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -ItemType Path -Force -ErrorAction SilentlyContinue
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "OpenOnHover" -Value 0 -ItemType DWord -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" "OpenOnHover" 0

Write-Output `n "Windows 11: Remove Taskbar Animations"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarAnimations -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" 0

Write-Output `n "Remove Recommended From Start"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideRecommendedSection -Type DWORD -Value 1 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideRecommendedSection" 1

Write-Output `n "Set Start Layout"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_Layout -Type DWORD -Value 1 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_Layout" 1

Write-Output `n "Fix Context (Right-Click) Menu"
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -ErrorAction SilentlyContinue -Force
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value ""

Write-Output `n "Adjusting Appearance & Performance of Windows"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name MinANimate -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Currentversion\Explorer\Advanced" -Name TaskbarAnimations -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name EnableAeroPeek -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name AlwaysHibernateThumbnails -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name IconsOnly -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ListViewAlphaSelect -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name DragFullWindows -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name FontSmoothing -Value 2
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ListviewShadow -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Type BINARY -Name UserPreferencesMask -Value ([byte[]](0x90,
0x12, 0x02, 0x80, 0x10, 0x00, 0x00, 0x00))
#Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name '(Default)' -Value "Windows Default (large) (system scheme)" -Force #XL Mouse Cursor

Write-Output `n "Adding 'End Task' Option To Right Click Menu"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" -Name TaskbarEndTask -Type DWORD -Value 1 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" -Name "TaskbarEndTask" -Value 1

Write-Output `n "Changing Date/Time Format"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSecondsInSystemClock" 1 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSecondsInSystemClock" 1
#New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowShortenedDateTime -Type Dword -Value 0 -ErrorAction SilentlyContinue   #Option to use long date format (Win 11)
#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowShortenedDateTime" 0

Write-Output "Fixing Start Menu Options Post-November-2025 Update"

Write-Output `n `t "Set start menu to list view"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" -Name AllAppsViewMode -Type DWORD -Value 2 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" -Name "AllAppsViewMode" -Value 2

Write-Output `n `t "Hide recent apps"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" -Name ShowRecentList -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" -Name "ShowRecentList" -Value 0

Write-Output `n `t "Hide frequent apps"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" -Name ShowFrequentList -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Start" -Name "ShowFrequentList" -Value 0

Write-Output `n `t "Hide frequent files"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_TrackDocs -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0

Write-Output `n `t "Hide recommendations for tips, shortcuts, new apps, and more"
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_IrisRecommendations -Type DWORD -Value 0 -ErrorAction SilentlyContinue -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_IrisRecommendations" -Value 0

Write-Output `n "Done, Restarting Explorer..."
taskkill /f /im explorer.exe
Start-Sleep 1
Start-Process explorer.exe
Start-Sleep 3

Write-Output `n "Trying to Show Mouse Options in Control Panel & Settings"
control /name Microsoft.Mouse
Start-Process ms-settings:easeofaccess-mousepointer
Write-Output `n "REBOOT IS REQUIRED FOR SOME ITEMS!"
Write-Output `n