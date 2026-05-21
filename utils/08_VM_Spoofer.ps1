# Requires Run as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator."
    break
}

Write-Host "Writing VM Registry Keys..." -ForegroundColor Cyan

# ==========================================
# 1. VirtualBox Spoofing
# ==========================================
$vboxPath = "HKLM:\SOFTWARE\Oracle\VirtualBox Guest Additions"
New-Item -Path $vboxPath -Force -ErrorAction SilentlyContinue

$sysDescPath = "HKLM:\HARDWARE\DESCRIPTION\System"

New-Item -Path sysDescPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $sysDescPath -Name "SystemBiosVersion" -Value "VBOX - 1" -Type MultiString -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $sysDescPath -Name "SystemBiosVersion" -Value "VBOX - 1" -Type MultiString -Force -ErrorAction SilentlyContinue
New-ItemProperty  -Path $sysDescPath -Name "VideoBiosVersion" -Value "VirtualBox" -Type MultiString -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $sysDescPath -Name "VideoBiosVersion" -Value "VirtualBox" -Type MultiString -Force -ErrorAction SilentlyContinue

# ==========================================
# 2. VMware Spoofing
# ==========================================
$vmwarePath = "HKLM:\SOFTWARE\VMware, Inc.\VMware Tools"
New-Item -Path $vmwarePath -Force -ErrorAction SilentlyContinue

$biosPath = "HKLM:\HARDWARE\DESCRIPTION\System\BIOS"
New-Item -Path $biosPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $biosPath -Name "SystemManufacturer" -Value "VMware, Inc." -Type String -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $biosPath -Name "SystemManufacturer" -Value "VMware, Inc." -Type String -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $biosPath -Name "SystemProductName" -Value "VMware Virtual Platform" -Type String -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $biosPath -Name "SystemProductName" -Value "VMware Virtual Platform" -Type String -Force -ErrorAction SilentlyContinue

# ==========================================
# 3. QEMU / KVM Spoofing
# ==========================================
$cpuPath = "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0"
New-Item -Path $cpuPath -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path $cpuPath -Name "ProcessorNameString" -Value "QEMU Virtual CPU version 2.5+" -Type String -Force -ErrorAction SilentlyContinue

Write-Host "Registry spoofing complete." -ForegroundColor Green
Write-Host "You will notice some Windows features will not work." -ForegroundColor Green
Write-Host "These registry keys will reset on reboot and features will be restored." -ForegroundColor Green
Write-Host ""

# ==========================================
# 4. MAC Address Spoofing (VMware OUI)
# ==========================================
Write-Host "Attempting to spoof virtual machine MAC address..." -ForegroundColor Cyan

# Grab the first active network adapter (Ethernet or Wi-Fi)
$adapter = Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object -First 1
Write-Host $adapter
# Generate a random MAC using VMware's OUI (00:05:69)
$hexChars = "0123456789ABCDEF"
$randomMacEnd = -join ((1..6) | ForEach-Object { $hexChars[(Get-Random -Maximum 16)] })
$spoofedMac = "000569" + $randomMacEnd
try {
    # Modify the registry property for the adapter
    #Get-NetAdapterAdvancedProperty -Name $adapter.Name
    Set-NetAdapterAdvancedProperty -Name $adapter.Name -RegistryKeyword "NetworkAddress" -RegistryValue $spoofedMac -ErrorAction Stop
    # Bounce the adapter to apply changes
    Restart-NetAdapter -Name $adapter.Name
    Write-Host "Adapter MAC Changed to $spoofedMac" -ForegroundColor Green
    }
catch {
   Write-Host "Failed to change MAC address. The network driver may block this modification." -ForegroundColor Yellow
   }