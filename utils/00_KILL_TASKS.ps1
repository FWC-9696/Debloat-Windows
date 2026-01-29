Stop-Process -Name perfmon -Force
perfmon.exe /res
Write-Host "DO NOT RUN THIS PROGRAM AS ADMINISTRATOR."
Read-Host "THIS WILL KILL *ALL* PROGRAMS. SAVE YOUR WORK. Any key to continue."
Stop-Process -Name * -Force -ErrorAction SilentlyContinue