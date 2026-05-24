# Description:
# This script disables unwanted Windows services by preventing them from running on startup
# It should not cause issues, but services can always be re-enabled using services.msc

Get-Service | Where-Object { 
    $_.Status -ne 'Running'
} | ForEach-Object { 
    $service = $_.Name
    try {
        Set-Service -Name $service -StartupType Manual -ErrorAction Stop
        Write-Host "Set $service to Manual." -ForegroundColor Yellow
    }
    catch {
        Write-Host "Could not set $service to Manual."
    }
}

$services = @(
    #Critical Windows Components
    "BFE"                                       # Base Filtering Engine. The Base Filtering Engine (BFE) is a service that manages firewall and Internet Protocol security (IPsec) policies and implements user mode filtering. Stopping or disabling the BFE service will significantly reduce the security of the system. It will also result in unpredictable behavior in IPsec management and firewall applications.
    "BrokerInfrastructure"                      # Background Tasks Infrastructure. Controls which background processes can run on the system.
    "DcomLaunch"                                # DCOM Server Process Launcher. The DCOMLAUNCH service launches COM and DCOM servers in response to object activation requests. If this service is stopped or disabled, programs using COM or DCOM will not function properly. It is strongly recommended that you have the DCOMLAUNCH service running.
    "RpcSs"                                     # Remote Procedure Call (RPC). The RPCSS service is the Service Control Manager for COM and DCOM servers. It performs object activations requests, object exporter resolutions and distributed garbage collection for COM and DCOM servers. If this service is stopped or disabled, programs using COM or DCOM will not function properly. It is strongly recommended that you have the RPCSS service running.
    "KeyIso"                                    # Cryptographic Key Isolation
    "EventSystem"                               # Supports System Event Notification Service (SENS), which provides automatic distribution of events to subscribing Component Object Model (COM) components. If the service is stopped, SENS will close and will not be able to provide logon and logoff notifications. If this service is disabled, any services that explicitly depend on it will fail to start.
    "COMSysApp"                                 # Manages the configuration and tracking of Component Object Model (COM)+-based components. If the service is stopped, most COM+-based components will not function properly. If this service is disabled, any services that explicitly depend on it will fail to start.
    "CoreMessagingRegistrar"                    # Core Messaging. Manages communication between system components.
    "SENS"                                      # System Event Notificaton Service
    "SystemEventsBroker"                        # System Event Broker
    "Schedule"                                  # Task Schedluer
    "Spooler"                                   # Print Spooler

    #Other Services for Time & Package Installers
    "tzautoupdate"                              # Time Zone Auto Update
    "W32Time"                                   # Windows Time
    "lfsvc"                                     # Geolocation Service
    "WbioSrvc"                                  # Windows Biometric Service (required for Fingerprint reader / facial detection)
    "WlanSvc"                                   # WLAN AutoConfig (WILL DISABLE WIFI)
    "wuauserv"                                  # Windows Update Service
    "InstallService"                            # Windows Store Installer Service
    "AppXSvc"                                   # Package Install Service
    "Appinfo"                                   # Application Information. acilitates the running of interactive applications with additional administrative privileges.  If this service is stopped, users will be unable to launch applications with the additional administrative privileges they may require to perform desired user tasks.
    "ClipSVC"                                   # Client License Service (ClipSVC). Provides infrastructure support for the Microsoft Store. This service is started on demand and if disabled applications bought using the Microsoft Store will not behave correctly.
    )
foreach ($service in $services) {
    try {
        Get-Service -Name $service -ErrorAction Stop | Set-Service -StartupType Automatic -ErrorAction Stop
        Write-Host "Set $service to Automatic." -ForegroundColor Green
    }
    catch {
        Write-Host "Could not set $service to Automatic."
    }
}

$services = @(
    "ADPSvc"                                    # Aggregated Data Platform Service
    "AMD Crash Defender Service"                # AMD Crash Defender Service
    "AMD External Events Utility"               # AMD External Events Utility
    "AppIDSvc"                                  # Application Identity Service
    "ALG"                                       # Application Layer Gateway. Provides support for 3rd party protocol plug-ins for Internet Connection Sharing.
    "BITS"                                      # Background Intelligent Transfer Service
    "BDESVC"                                    # BitLocker Encryption Service
    "BthAvctpSvc"                               # Audio Background Service
    "diagnosticshub.standardcollector.service"  # Microsoft (R) Diagnostics Hub Standard Collector Service
    "dmwappushservice"                          # WAP Push Message Routing Service (see known issues)
    "MapsBroker"                                # Downloaded Maps Manager
    "NetTcpPortSharing"                         # Net.Tcp Port Sharing Service
    "RemoteAccess"                              # Routing and Remote Access
    "SharedAccess"                              # Internet Connection Sharing (ICS)
    "TrkWks"                                    # Distributed Link Tracking Client
    "SysMain"                                   # Superfetch. Can use a lot of disk.
    "WMPNetworkSvc"                             # Windows Media Player Network Sharing Service
    "WSearch"                                   # Windows Search
    "ndu"                                       # Windows Network Data Usage Monitor
    "RasMan"                                    # Remote Access Connection Manager
    "SDRSVC"                                    # Windows Backup

    #######Edge Update Servcies
    "MicrosoftEdgeElevationService"
    "edgeupdate"
    "edgeupdatem"

    #######Telemetry & Diagnostics
    "CDPSvc"
    "CDPUserSvc_*"
    "DiagTrack"
    "diagsvc"                                 #Diagnostic Execution Service
    "WdiServiceHost"                          #Diagnostic Service Host
    "WdiSystemHost"                           #Diagnostic System host
    "PcaSvc"                                  #Program Caompatibility Assistant

    #######Windows Defender & Antivirus
    "wscsvc"                                  #Windows Security Center Service
    "WinDefend"                               #Microsoft Defender
    "MDCoreSvc"                               #Microcoft Defender Core
    "WdNisSvc"                                #Microsoft Defender Network Inspection

    ########Windows Gaming Services
    "Gaming Services"                          #Gaming Services
    "GamingServicesNet"                        #Gaming Services Net
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service
    "XboxGipSvc"                               #Xbox Accessory Management Sevice

    #######3RD Party Services. May or may not be present.
    "Apple Mobile Device Service"             #Apple Mobile Device, comes with iTunes
    "FoxitReaderUpdateService"                #Foxit PDF Updater
    "LGHUBUpdaterService"                     #Logi G Hub Updater
    "Parsec"                                  #Parsec
    "RvControlSvc"                            #Radmin VPN
    "EasyAntiCheat_EOS"                       #Easy Anti-Cheat Epic Games
    "EasyAntiCheat"                           #Easy Anti-Cheat
    "EpicOnlineServices"                      #Epic Games
    "AntiCheatExpert Service"                 #Anti-Cheat Service
    "BEService"                               #BattlEye
    "EAAntiCheatService"                      #EA Anti-Cheat
    "EABackgroundService"                     #EA Background Service

    #Print & Scan
    "stisvc"                                  #Provides image acquisition services for scanners and cameras

    #Special Services for Touch, Bluetooth, & Screen rotation
    "bthserv"                                   #Bluetooth Support Service
    "TabletInputService"                        #Touch Keyboard and Handwriting Panel Service
    "SensorService"                             #Sensor Service
    "Sensorsrv"                                 #Sensor Data Service
)
foreach ($service in $services) {
    try {
        Get-Service -Name $service -ErrorAction Stop | Set-Service -StartupType Manual -ErrorAction Stop
        Write-Host "Set $service to Manual." -ForegroundColor Yellow
    }
    catch {
        Write-Host "Could not set $service to Manual."
    }
}

$services=@(
    "DPS"                                       #Diagnostic Policy Service
    "WSAIFabricSvc"                             #Provides support to communicate with AIFabric in Local service context over COM.
    "HPPrintScanDoctorService"                  #HP Print Service
    "RemoteRegistry"                            #Remote Registry
)
foreach ($service in $services) {
    try {
        Get-Service -Name $service -ErrorAction Stop | Set-Service -StartupType Disabled -ErrorAction Stop
        Write-Host "Set $service to Disabled." -ForegroundColor Red
    }
    catch {
        Write-Host "Could not set $service to Disabled."
    }
}

#Below Services Needed for Windows Updates
$services=@(
    "AppReadiness"               #Gets apps ready for use the first time a user signs in to this PC and when adding new apps. Needed for Windows Updates
    "BITS"                       #Background Intelligent Transfer Service
    "CryptSvc"                   #Cryptographic Service
    "wuauserv"                   #Remote Registry
    "Spooler"                                 #Print Spooler
)
foreach ($service in $services) {
    try {
        Get-Service -Name $service -ErrorAction Stop| Set-Service -StartupType Automatic -ErrorAction Stop
        Write-Host "Set $service to Automatic." -ForegroundColor Green
    }
    catch {
        Write-Host "Could not set $service to Automatic."
    }
}

taskmgr /0 /startup

Write-Host `n
Write-Host "Disabling auto-restart of apps on sign in"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "RestartApps" 0

Write-Host `n
Write-Host "Please Disable Unwanted Programs"
Write-Host `n