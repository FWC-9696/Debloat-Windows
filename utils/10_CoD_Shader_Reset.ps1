<#
.SYNOPSIS
    Clears GPU shader caches, Battle.net data, and Call of Duty local caches.
.DESCRIPTION
    Stops background application processes and purges temporary cache files
    to resolve hanging loading screens and shader compilation issues.
#>

# Stop active game and launcher processes to release file locks
$processes = @("cod", "cod22", "Battle.net", "steam")
foreach ($proc in $processes) {
    if (Get-Process -Name $proc -ErrorAction SilentlyContinue) {
        Write-Host "Stopping process: $proc" -ForegroundColor Yellow
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
    }
}

# Define cache and shader directories
$cachePaths = @(
    "$env:LOCALAPPDATA\NVIDIA\DXCache",
    "$env:LOCALAPPDATA\NVIDIA\GLCache",
    "$env:LOCALAPPDATA\AMD\DxCache",
    "$env:PROGRAMDATA\Blizzard Entertainment",
    "$env:PROGRAMDATA\Battle.net",
    "$env:LOCALAPPDATA\Activision"
)

# Purge contents of existing directories
foreach ($path in $cachePaths) {
    if (Test-Path $path) {
        Write-Host "Clearing cache directory: $path" -ForegroundColor Cyan
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Skipping (Path not found): $path" -ForegroundColor DarkGray
    }
}

Write-Host "Cache clearance complete. You can now relaunch your game." -ForegroundColor Green