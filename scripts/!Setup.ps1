winget install --id Microsoft.PowerShell --source winget --installer-type wix --scope machine --accept-source-agreements --accept-package-agreements

$apps = @(
    "Microsoft.VisualStudioCode.Insiders" #VSCode
    "9N8G5RFZ9XK3" #Terminal Preview
)

foreach ($app in $apps) {
    Write-Output "Trying to install $app"

    winget install $app --accept-source-agreements --accept-package-agreements

    }