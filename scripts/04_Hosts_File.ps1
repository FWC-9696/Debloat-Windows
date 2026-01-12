#Soruce: Copied some code from https://github.com/simeononsecurity/System-Wide-Windows-Ad-Blocker/blob/main/sos-system-wide-windows-ad-block.ps1
#The intention is to block some telemetry, but nothing that will break Windows components, like the Insider Program

# Use only the latest .NET version
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework" -Name "OnlyUseLatestCLR" -PropertyType DWORD -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework" "OnlyUseLatestCLR" 1
New-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework" -Name "OnlyUseLatestCLR" -PropertyType DWORD -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework" "OnlyUseLatestCLR" 1

# Specify the hosts file location
$hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
$domains = @(
    ###Microsoft Telemetry Domains
    "0.0.0.0 vortex.data.microsoft.com"
    "0.0.0.0 vortex-win.data.microsoft.com"
    "0.0.0.0 watson.telemetry.microsoft.com"
    "0.0.0.0 choice.microsoft.com"
    "0.0.0.0 choice.microsoft.com.nsatc.net"
    "0.0.0.0 rad.msn.com"
    "0.0.0.0 ads.msn.com"
    "0.0.0.0 b.rad.msn.com"
    "0.0.0.0 a.ads1.msn.com"
    "0.0.0.0 a.ads2.msads.net"
    "0.0.0.0 ads1.msads.net"
    "0.0.0.0 ads1.msn.com"
    "0.0.0.0 adnxs.com"
    "0.0.0.0 aidps.atdmt.com"
    "0.0.0.0 db3aqu.atdmt.com"
    "0.0.0.0 c.msn.com"

    ###More to try
    "0.0.0.0 geo.settings-win.data.microsoft.com.akadns.net"
    "0.0.0.0 a-0001.a-msedge.net"
    "0.0.0.0 a-msedge.net"
    "0.0.0.0 array-*.do.dsp.mp.microsoft.com"    #(various numbers)
    "0.0.0.0 activity.windows.com"
    "0.0.0.0 bingads.microsoft.com"
)

Clear-Content -Path $hostsFilePath #Clears Host File
foreach ($domian in $domains){
       Add-Content -Path $hostsFilePath $domian
    }
    Write-Host "Write Successful.." -ForegroundColor Green -BackgroundColor Black

$hostsFilePath = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostsFileSize = (Get-Item $hostsFilePath).Length

if ($hostsFileSize -gt 135KB) {
    Write-Host "The hosts file size is greater than 135KB."

    Write-Host "Flushing DNS cache..."
    Stop-Service -Name Dnscache
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name MaxCacheTtl -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name MaxNegativeCacheTtl -ErrorAction SilentlyContinue
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name MaxCacheTtl -Value 1 -PropertyType DWORD
    Restart-Service -Name Dnscache
    Write-Host "DNS cache flushed and service restarted."
}
else {
    Write-Host "The hosts file size is within the acceptable range."
}