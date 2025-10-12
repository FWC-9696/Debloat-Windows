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
    "Microsoft.GamingServices"            #Can be reinstalled via Xbox app
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
    #"Microsoft.XboxGamingOverlay"   #Xbox Game Bar
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
    "MicrosoftTeams"                           #Teams

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

#Uninstall more stuff using WinGet
winget uninstall 9NRX63209R7B #Outlook
winget uninstall 9NFTCH6J7FHV #Power Automate
winget uninstall 9NZBF4GT040C #Web Search from Microsoft Bing
winget uninstall 9NTXGKQ8P7N0 #Cross Device Experience Host
winget uninstall 9WZDNCRFJBD8 #Xbox Console Companion
#winget uninstall 9N3RK8ZV2ZR8 #Widgets Platform Runtime
winget uninstall 9NHT9RB2F4HD #COPILOT APP
#winget uninstall 9MSSGKG348SP #Windows Web Experience Pack ***Will Disable widgets. Gets reinstalled below.***
winget uninstall XPFFZHVGQWWLHB #OneNote
winget uninstall 9N95Q1ZZPMH4 #MPEG-2 Video Extension (Has issues updating; can be reinstalled)


#3rd party stuff using WinGet
winget uninstall 9WZDNCRFJ0PK #Dropbox Lite
winget uninstall 9NBLGGH537BP #Apps Explorer
winget uninstall 9N12Z3CCTCNZ #Alexa
winget uninstall 9WZDNCRFJ3MB #Evernote
winget uninstall 9WZDNCRFJ3WL #Hearts Deluxe
winget uninstall 9WZDNCRDKRDS #Simple Mahjong
winget uninstall 9WZDNCRFJ3TT #Simple Solitaire
winget uninstall 9WZDNCRDKRDT #Simple Spider Solitaire
winget uninstall 9WZDNCRFJ3GM #Spades
winget uninstall 9NKSQGP7F2NH #WhatsApp
winget uninstall 9NCBCSZSJRSB #Spotify
winget uninstall 9P1J8S7CCWWT #ClipChamp
winget uninstall 9WZDNCRFJ4Q7 #Linkedin
winget uninstall 9N8MHTPHNGVV #Dev Home
winget uninstall 9NZCC27PR6N6 #Dev Home Github Extension
winget uninstall 9P7JQGL6GC8P #Luminar Neo AI Photo Editor
winget uninstall 9PL59F1G4XSZ #Linkedin
winget uninstall 9PGM3QB3PDRD #Camo Studio
winget uninstall XPDDXX9QW8N9D7 #Grammarly
winget uninstall ExpressVPN #ExpressVPN
winget uninstall 9N2F0P0166HF #PDF Editor & Converter
winget uninstall 9N0H1M8J1308 #DTS Ultra

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

Write-Host "Uninstall Desktop Teams, if Present"
winget uninstall Microsoft.Teams.Free
Write-Host `n
Write-Host "Remove Cortana"
winget uninstall 9NFFX4SZZ23L
Write-Host `n
Write-Host "Remove Cross-Device Experience Host"
winget uninstall 9NTXGKQ8P7N0
Write-Host `n

winget install 9NKNC0LD5NN6 --accept-source-agreements --accept-package-agreements #reinstall Xbox TCUI
winget install 9MWPM2CQNLHN --accept-source-agreements --accept-package-agreements #reinstall Xbox Gaming Services
winget install 9MSSGKG348SP --accept-source-agreements --accept-package-agreements #reinstall Windows Web Experience Pack

Write-Output `n
Write-Output "Note: Windows 11 will pin apps to the start menu without installing them." `n "You may need to manually unpin these apps!"
Write-Output `n