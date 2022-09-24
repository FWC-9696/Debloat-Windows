Write-Host "Installing Software"
$apps = @(
    "9MV0B5HZVK9Z"             #Xbox
    "9NZKPSTSNW4P"             #Xbox Game Bar
    "9PLDPG46G47Z"             #Xbox Insider Hub
    "9N8WTRRSQ8F7"             #Diagnostic Data Viewer
    "9WZDNCRFJBH4"             #Microsoft Photos
    #"9WZDNCRFHVQM"             #Mail and Calendar
    "9WZDNCRFJ3P2"             #Windows Movies & TV
    "9N95Q1ZZPMH4"             #MPEG-2 Video Extension
    #"9NBLGGH10PG8"             #Microsoft People
    "9MZ95KL8MR0L"             #Snip and Sketch (New Snipping Tool)
    #"9WZDNCRFJ3PT"             #Groove Music

    #Non-Windows UWP Apps
    "9NBHCS1LX4R0"             #Paint.net
    "9NBLGGH40881"             #Tree Size, for determining sizes of folders
    "XPFCG5NRKXQPKT"           #Foxit PDF Reader

    #Printer UWP Apps
    #"9WZDNCRFJ14K"             #Cannon Inkjet Print Utility
    "9WZDNCRFHWLH"             #HP Smart

)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }