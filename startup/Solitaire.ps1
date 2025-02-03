#explorer shell:appsFolder\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe!App                 #Game Bar
Stop-Process -Name Solitaire -ErrorAction SilentlyContinue                              #Kill any other solitaire process
sleep 30
explorer shell:appsFolder\Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe!App	    #Microsoft Solitaire Colletion NOTE: Use Get:StartApps for list of UWP Apps