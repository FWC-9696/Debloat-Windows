# Description:
# This script disables unwanted Windows services by preventing them from running on startup
# It should not cause issues, but services can always be re-enabled using services.msc

$services = @(
    "BITS"                                      # Background Intelligent Transfer Service
    #"diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
    "dmwappushservice"                          # WAP Push Message Routing Service (see known issues)
    #"lfsvc"                                    # Geolocation Service
    "MapsBroker"                                # Downloaded Maps Manager
    "NetTcpPortSharing"                         # Net.Tcp Port Sharing Service
    "RemoteAccess"                              # Routing and Remote Access
    "RemoteRegistry"                            # Remote Registry
    "SharedAccess"                              # Internet Connection Sharing (ICS)
    "TrkWks"                                    # Distributed Link Tracking Client
    "SysMain"                                   # Superfetch. Can use a lot of disk.
    #"WbioSrvc"                                 # Windows Biometric Service (required for Fingerprint reader / facial detection)
    #"WlanSvc"                                  # WLAN AutoConfig (WILL DISABLE WIFI)
    "WMPNetworkSvc"                             # Windows Media Player Network Sharing Service
  
    "WSearch"                                   # Windows Search
    #"XblAuthManager"                           # Xbox Live Auth Manager
    #"XblGameSave"                              # Xbox Live Game Save Service
    #"XboxNetApiSvc"                            # Xbox Live Networking Service
    "ndu"                                       # Windows Network Data Usage Monitor
    "RasMan"                                    # Remote Access Connection Manager

    #######Edge Update Servcies
    "MicrosoftEdgeElevationService"
    "edgeupdate"
    "edgeupdatem"

    #######Telemetry & Diagnostics
    "CDPSvc"
    "CDPUserSvc_7902f"
    "DiagTrack"
    "DPS"                                     #Diagnostic Poilcy Service
    "diagsvc"

    #######Windows Defender & Antivirus
    "wscsvc"                                  #Windows Security Center Service
    "WinDefend"                               #Microsoft Defender
    "MDCoreSvc"                               #Microcoft Defender Core
    "WdNisSvc"                                #Microsoft Defender Network Inspection

    #######3RD Party Services. May or may not be present.
    "Apple Mobile Device Service"             #Apple Mobile Device, comes with iTunes
    "FoxitReaderUpdateService"                #Foxit PDF Updater
    "LGHUBUpdaterService"                     #Logi G Hub Updater
    "Parsec"                                  #Parsec
    "RvControlSvc"                            #Radmin VPN
    "EasyAntiCheat_EOS"                       #Easy Anti-Cheat Epic Games
    "EasyAntiCheat"                           #Easy Anti-Cheat
    "EpicOnlineServices"                      #Epic Games

)

foreach ($service in $services) {
    Write-Output "Trying to disable $service"
    Get-Service -Name $service | Set-Service -StartupType Manual
}

Set-Service HPPrintScanDoctorService -StartupType Disabled -ErrorAction SilentlyContinue

Set-Service XblAuthManager -StartupType Automatic -ErrorAction SilentlyContinue #Set Xbox Live to start with computer

taskmgr /0 /startup

Write-Host `n
Write-Host "Disabling auto-restart of apps on sign in"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "RestartApps" 0

Write-Host `n
Write-Host "Please Disable Unwanted Programs"
Write-Host `n