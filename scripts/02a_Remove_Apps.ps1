# Description:
# This script removes unwanted Apps that come with Windows. If you  do not want
# to remove certain Apps comment out the corresponding lines below.

#https://github.com/PowerShell/PowerShell/issues/16652 <-- Had to fix this error on 2024-06-21

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\New-FolderForced.psm1

Write-Output "Elevating privileges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Output `n "Uninstalling:"
$session = New-PSSession -UseWindowsPowerShell
Invoke-Command -Session $session {
$apps = @(
    # default Windows 10 apps
    "Microsoft.3DBuilder"
    "Microsoft.Appconnector"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingTranslator"
    "Microsoft.BingWeather"
    "Microsoft.FreshPaint"
    #"Microsoft.GamingServices"            #Can be reinstalled via Xbox app
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftPowerBIForWindows"
    #"Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.MinecraftUWP"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.OneNote"           #Replaced with UWP App.
    "Microsoft.People"                   #Integrates with Mail and Calendar
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "Microsoft.Wallet"
    #"Microsoft.Windows.Photos"
    "Microsoft.WindowsAlarms"
    #"Microsoft.WindowsCalculator"
    "Microsoft.WindowsCamera"
    "Microsoft.Windowscommunicationsapps" #Mail and Calendar App (Old)
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    #"Microsoft.GamingApp"           #Xbox App
    "Microsoft.XboxApp"             #Xbox Console Companion. Need this on Win 11 to check Xbox Network Status.
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    # Threshold 2 apps
    "Microsoft.CommsPhone"
    "Microsoft.ConnectivityStore"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    #"Microsoft.WindowsFeedbackHub"

    # Creators Update apps
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MSPaint"

    #Redstone apps
    "Microsoft.BingFoodAndDrink"
    "Microsoft.BingHealthAndFitness"
    "Microsoft.BingTravel"
    "Microsoft.WindowsReadingList"

    # Redstone 5 apps
    "Microsoft.MixedReality.Portal"
    #"Microsoft.ScreenSketch"        #Snip and Sketch
    #"Microsoft.XboxGamingOverlay"
    "Microsoft.YourPhone"

    # non-Microsoft
    "2FE3CB00.PicsArt-PhotoStudio"
    "46928bounde.EclipseManager"
    "4DF9E0F8.Netflix"
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
    "6Wunderkinder.Wunderlist"
    "7EE7776C.LinkedInforWindows"
    "89006A2E.AutodeskSketchBook"
    "9E2F88E3.Twitter"
    "A278AB0D.DisneyMagicKingdoms"
    "A278AB0D.MarchofEmpires"
    "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
    "CAF9E577.Plex"  
    "ClearChannelRadioDigital.iHeartRadio"
    "D52A8D61.FarmVille2CountryEscape"
    "D5EA27B7.Duolingo-LearnLanguagesforFree"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "DolbyLaboratories.DolbyAccess"
    "DolbyLaboratories.DolbyAccess"
    "Drawboard.DrawboardPDF"
    "Facebook.Facebook"
    "Fitbit.FitbitCoach"
    "Flipboard.Flipboard"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "NORDCURRENT.COOKINGFEVER"
    "PandoraMediaInc.29680B314EFC2"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SlingTVLLC.SlingTV"
    "SpotifyAB.SpotifyMusic"
    "TheNewYorkTimes.NYTCrossword"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"
    "flaregamesGmbH.RoyalRevolt2"
    "king.com.*"
    "king.com.BubbleWitch3Saga"
    "king.com.CandyCrushSaga"
    "king.com.CandyCrushSodaSaga"
    "A025C540.Yandex.Music"

    #New Apps to Remove
    "Disney.37853FC22B2CE"                     #Disney+
    "BytedancePte.Ltd.TikTok"                  #TikTok

    ###Windows11_Apps

    #Non-Microsoft
    "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    #AdobeExpress
    "AmazonVideo.PrimeVideo"                   #Amazon Prime Video
    "Clipchamp.Clipchamp"                      #Clipchamp
    "FACEBOOK.317180B0BB486"                   #Facebook Messenger
    "Facebook.InstagramBeta"                   #Instagram
    "SpotifyAB.SpotifyMusic"                   #Spotify
    "5319275A.WhatsAppDesktop"                 #WhatsApp
    "5319275A.51895FA4EA97F"                   #WhatsApp Beta
    
    #Win11
    "Microsoft.Todos"                          #Microsoft To-Do
    "MicrosoftCorporationII.QuickAssist"       #Quick Assist
    "MicrosoftCorporationII.MicrosoftFamily"   #Microsoft Family Safety
    "Microsoft.Teams.Free"                           #Teams

    #More Win 11 Junk
    "Windows.DevHome"
    "Microsoft.Getstarted*"

    #RandomSaladGames
    "26720RandomSaladGamesLLC.*"
    "26720RandomSaladGamesLLC.HeartsDeluxe"
    "26720RandomSaladGamesLLC.SimpleSolitaire"
    "26720RandomSaladGamesLLC.SimpleSpiderSolitaire"
    "26720RandomSaladGamesLLC.Spades"

    #Manufacturer-Specific Junk
    "AcerIncorporated.AcerPurifiedVoiceConsole*"

   #MoreStuff
    "DTSInc.DTSXUltra*"

    # apps which cannot be removed using Remove-AppxPackage
    #"Microsoft.BioEnrollment"
    #"Microsoft.MicrosoftEdge"
    #"Microsoft.Windows.Cortana"
    #"Microsoft.WindowsFeedback"
    #"Microsoft.XboxGameCallableUI"
    #"Microsoft.XboxIdentityProvider"
    #"Windows.ContactSupport"

    # apps which other apps depend on
    #"Microsoft.Advertising.Xaml"

    #Copilot Removal
    "Microsoft.Copilot"
)

foreach ($app in $apps) {
    Write-Output "Trying to remove $app"

    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Continue

    Get-AppXProvisionedPackage -Online |
        Where-Object DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online
}
}

$session | Remove-PSSession

#Uninstall GameAssist
Get-AppxPackage -AllUsers Microsoft.Edge.GameAssist | Remove-AppxPackage -AllUsers

#Uninstall more stuff using WinGet

#winget uninstall 9WZDNCRD1HKW --accept-source-agreements #XboxIdentityProvider
#winget uninstall 9WZDNCRFJBD8 --accept-source-agreements #Xbox Console Companion
#winget uninstall 9NBLGGH537C2 --accept-source-agreements #Xbox Game Bar Plugin
#winget uninstall 9NZKPSTSNW4P --accept-source-agreements #Xbox Game Bar

winget uninstall 9NZBF4GT040C --accept-source-agreements #Web Search from Microsoft Bing
winget uninstall 9NTXGKQ8P7N0 --accept-source-agreements #Cross Device Experience Host
winget uninstall 9N3RK8ZV2ZR8 --accept-source-agreements #Widgets Platform Runtime
winget uninstall 9PCSD6N03BKV --accept-source-agreements #Windows Application Compatiblility Enhancements (WACE)
winget uninstall 9NHT9RB2F4HD --accept-source-agreements #Microsoft Copilot App
winget uninstall 9WZDNCRD29V9 --accept-source-agreements #Microsoft Copilot 365 App
winget uninstall 9MSSGKG348SP --accept-source-agreements #Windows Web Experience Pack ***Will Disable widgets.***
winget uninstall 9PLJQ12FQ3CV --accept-source-agreements #WinAppRuntime.Main.1.8
winget uninstall 9P5Z076K079H --accept-source-agreements #WinAppRuntime.Singleton
winget uninstall 9NRZT3Q9R3DL --accept-source-agreements #WindowsAppRuntime.2

#winget uninstall 9WZDNCRFHVN5 --accept-source-agreements #Calculator
#winget uninstall XPFFZHVGQWWLHB --accept-source-agreements #OneNote. Can hang or take a while.
winget uninstall 9NRX63209R7B --accept-source-agreements #Outlook
winget uninstall 9NFTCH6J7FHV --accept-source-agreements #Power Automate
winget uninstall 9PC1H9VN18CM --accept-source-agreements #Start Experiences App, which keeps messing with the Start Menu Layout
winget uninstall 9NC184TX90WZ --accept-source-agreements #AI Handwriting Tool Ink.Handwriting
winget uninstall 9MSMLRH6LZF3 --accept-source-agreements #Notepad
winget uninstall 9PCFS5B6T72H --accept-source-agreements #Paint
#winget uninstall 9WZDNCRFJBH4 --accept-source-agreements #Photos
#winget uninstall 9MZ95KL8MR0L --accept-source-agreements #Snipping Tool
winget uninstall 9WZDNCRFHWD2 --accept-source-agreements #Solitaire
winget uninstall 9PF3QC8DVGVD --accept-source-agreements #English Speech Pack


#Uninstall Image & Video Extensions
winget uninstall 9NCTDW2W1BH8 --accept-source-agreements #Raw Image Extension
winget uninstall 9PG2DK419DRG --accept-source-agreements #Webp Image Extension
winget uninstall 9PMMSR1CGPWG --accept-source-agreements #HEIF Image Extension
winget uninstall 9N5TDP8VCMHS --accept-source-agreements #Web Media Extension
winget uninstall 9N4D0MSMP0PT --accept-source-agreements #VP9 Video Extension
winget uninstall 9PB0TRCNRHFX --accept-source-agreements #AVC Video Extension
winget uninstall 9N4WGH0Z6VHQ --accept-source-agreements #HVEC Video Extension
winget uninstall 9N95Q1ZZPMH4 --accept-source-agreements #MPEG-2 Video Extension (Has issues updating; can be reinstalled)
winget uninstall 9MVZQVXJBQ9V --accept-source-agreements #AV1 Video Extension

#3rd party stuff using WinGet
winget uninstall 9WZDNCRFJ0PK --accept-source-agreements #Dropbox Lite
winget uninstall 9NBLGGH537BP --accept-source-agreements #Apps Explorer
winget uninstall 9N12Z3CCTCNZ --accept-source-agreements #Alexa
winget uninstall 9WZDNCRFJ3MB --accept-source-agreements #Evernote
winget uninstall 9WZDNCRFJ3WL --accept-source-agreements #Hearts Deluxe
winget uninstall 9WZDNCRDKRDS --accept-source-agreements #Simple Mahjong
winget uninstall 9WZDNCRFJ3TT --accept-source-agreements #Simple Solitaire
winget uninstall 9WZDNCRDKRDT --accept-source-agreements #Simple Spider Solitaire
winget uninstall 9WZDNCRFJ3GM --accept-source-agreements #Spades
winget uninstall 9NKSQGP7F2NH --accept-source-agreements #WhatsApp
winget uninstall 9NCBCSZSJRSB --accept-source-agreements #Spotify
winget uninstall 9P1J8S7CCWWT --accept-source-agreements #ClipChamp
winget uninstall 9WZDNCRFJ4Q7 --accept-source-agreements #Linkedin
winget uninstall 9N8MHTPHNGVV --accept-source-agreements #Dev Home
winget uninstall 9NZCC27PR6N6 --accept-source-agreements #Dev Home Github Extension
winget uninstall 9P7JQGL6GC8P --accept-source-agreements #Luminar Neo AI Photo Editor
winget uninstall 9PL59F1G4XSZ --accept-source-agreements #Linkedin
winget uninstall 9PGM3QB3PDRD --accept-source-agreements #Camo Studio
winget uninstall XPDDXX9QW8N9D7 --accept-source-agreements #Grammarly
winget uninstall ExpressVPN --accept-source-agreements #ExpressVPN
winget uninstall 9N2F0P0166HF --accept-source-agreements #PDF Editor & Converter
winget uninstall 9N0H1M8J1308 --accept-source-agreements #DTS Ultra

#Remove shortcuts
$shortcuts = @(
"Amazon.url"
"Booking.com.url"
"Forge of Empires.url"
)
foreach ($shortcut in $shortcuts) {
Remove-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcut" -ErrorAction SilentlyContinue
}

Write-Output "Removing Cortana for the Current User"
Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage #Cortana


# Prevents Apps from re-installing
$cdm = @(
    "ContentDeliveryAllowed"
    "FeatureManagementEnabled"
    "FeatureManagementAllowed"
    "OemPreInstalledAppsEnabled"
    "PreInstalledAppsEnabled"
    "PreInstalledAppsEverEnabled"
    "SilentInstalledAppsEnabled"
    "SubscribedContent-314559Enabled"
    "SubscribedContent-338387Enabled"
    "SubscribedContent-338388Enabled"
    "SubscribedContent-338389Enabled"
    "SubscribedContent-338393Enabled"
    "SubscribedContentEnabled"
    "SystemPaneSuggestionsEnabled"
)

New-FolderForced -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
foreach ($key in $cdm) {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" $key 0
}

New-FolderForced -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" "AutoDownload" 2

# Prevents "Suggested Applications" returning
New-FolderForced -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1

#Use Legacy Windows PhotoViewer after Photos App Uninstalled
$names = @(
    ".bmp"
    ".dib"
    ".jpg"
    ".jpeg"
    ".jpe"
    ".png"
    ".gif"
    ".tif"
    ".tiff"
)
foreach($name in $names){
    New-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name $name -PropertyType String -Value "PhotoViewer.FileAssoc.Tiff" -ErrorAction SilentlyContinue
}
Write-Host "Uninstall Desktop Teams, if Present"
winget uninstall Microsoft.Teams.Free --accept-source-agreements
Write-Host `n
Write-Host "Remove Cortana"
winget uninstall 9NFFX4SZZ23L --accept-source-agreements
Write-Host `n
Write-Host "Remove Cross-Device Experience Host"
winget uninstall 9NTXGKQ8P7N0 --accept-source-agreements
Write-Host `n

###Reinstall some apps
winget install 9WZDNCRFHVN5 --accept-source-agreements --accept-package-agreements #Calculator
winget install 9WZDNCRFJBH4 --accept-source-agreements --accept-package-agreements #Photos. Has AI, but still unfortunately best way to trim video
#winget install 9MSSGKG348SP --accept-source-agreements --accept-package-agreements #reinstall Windows Web Experience Pack
#winget install 9MV0B5HZVK9Z --accept-source-agreements --accept-package-agreements #Xbox, will get reinstalled automatically
winget install 9WZDNCRD1HKW --accept-source-agreements --accept-package-agreements #reinstall XboxIdentityProvider
#winget install 9NKNC0LD5NN6 --accept-source-agreements --accept-package-agreements #reinstall Xbox TCUI
#winget install 9MWPM2CQNLHN --accept-source-agreements --accept-package-agreements #reinstall Xbox Gaming Services
winget install 9NZKPSTSNW4P --accept-source-agreements --accept-package-agreements #reinstall Xbox Game Bar

###Remove Remote Desktop Connection
Write-Host "Remove Remote Desktop Connection"
try {
    mstsc.exe /Uninstall
}
catch {
    Write-Host "Remote Desktop is Not Installed"
}

#####Remove Copilot More Completely
Write-Host "Remove Copilot More Completely"
Remove-Item -Recurse -Force ${env:ProgramFiles(x86)}\Microsoft\Copilot -ErrorAction SilentlyContinue

###Turn off "Let Windows Manage My Default Printer"
Write-Host "Turn Off 'Let Windows Manage My Default Printer'"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -Value 1

###Remove 'Get Help'
Write-Host "Remove 'Get Help' App"
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Support" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Support" -Name DisableGetHelp -Type DWORD -Value 1 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Support" -Name DisableGetHelp -Value 1 -ErrorAction SilentlyContinue

###Turn off Welcome Experience
Write-Host "Turn off 'Windows Welcome Experience'"
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-310093Enabled -Type DWORD -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-310093Enabled -Value 0

###Turn off Windows Backup
dism /online /disable-feature /featurename:WindowsBackup

Write-Output `n
Write-Output "Note: Windows 11 will pin apps to the start menu without installing them." `n "You may need to manually unpin these apps!"
Write-Output `n