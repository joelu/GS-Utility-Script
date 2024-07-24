#Prompt for elevation
If (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $Arguments = "& '" + $MyInvocation.MyCommand.Definition + "'"
    Start-Process Powershell -Verb RunAs -ArgumentList $Arguments
    Break
};
# Check for available updates
$updates = Get-WindowsUpdate -NotCategory "Drivers","FeaturePacks"
#$updates = Get-WindowsUpdate -MicrosoftUpdate -Category "Security Updates" -AcceptAll
# If there are updates available, install them
if ($updates.Count -gt 0) {
    Install-WindowsUpdate -NotCategory "Drivers","FeaturePacks" -AcceptAll
	};
# Run DISM with /online /cleanup-image /restorehealth command
$dismandargs = "/online /cleanup-image /restorehealth /NoRestart"
Start-Process -FilePath "C:\Windows\System32\dism.exe" -ArgumentList $dismandargs -Verb RunAs -Wait | Out-Null;
# Run SFC /scannow command
Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Verb RunAs -Wait;
# Create a restore point
$DateStr = Get-Date -Format "MM-dd-yyyy"
Checkpoint-Computer -Description $DateStr -restorepointtype Modify_Settings;
$tempdir = [System.IO.Path]::GetTempPath();
 Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope LocalMachine -Force