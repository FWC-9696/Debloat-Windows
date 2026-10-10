# Define source URL and target path in Downloads
$url = "http://download.microsoft.com/download/f/2/2/f22d5fdb-59cd-4275-8c95-1be17bf70b21/wushowhide.diagcab"
$outputPath = "$env:USERPROFILE\Downloads\wushowhide.diagcab"

# Download the file
Invoke-WebRequest -Uri $url -OutFile $outputPath -UseBasicParsing

# Launch the tool
Start-Process -FilePath $outputPath