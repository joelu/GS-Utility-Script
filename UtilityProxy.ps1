#Works as a proxy to down load github script and run that script in elevated mode.
#Places script in systems temp folder.
Invoke-WebRequest -URI https://raw.githubusercontent.com/joelu/GS-Utility-Script/main/Utilities.ps1 -OutFile $env:TEMP\Utilities.ps1 ; 
& powershell.exe -ExecutionPolicy Bypass -NoLogo -Command $env:TEMP\Utilities.ps1