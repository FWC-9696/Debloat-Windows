$apps = @(
    "Microsoft.PowerShell"     #Latest Version of PowerShell
    "Microsoft.VisualStudioCode.Insiders" #VSCode
)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }