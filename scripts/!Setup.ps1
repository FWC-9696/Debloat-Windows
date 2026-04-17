$apps = @(
    "Microsoft.PowerShell"     #Latest Version of PowerShell
    "Microsoft.VisualStudioCode.Insiders" #VSCode
    "9N8G5RFZ9XK3" #Terminal Preview
)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }