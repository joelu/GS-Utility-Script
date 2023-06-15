# Check for available updates
$updates = Get-WindowsUpdate -NotCategory "Drivers","FeaturePacks"
# If there are updates available, install them
if ($updates.Count -gt 0) {
    Install-WindowsUpdate -NotCategory "Drivers","FeaturePacks"};
# Run DISM with /online /cleanup-image /restorehealth command
$dismandargs = "/online /cleanup-image /restorehealth /NoRestart"
Start-Process -FilePath "C:\Windows\System32\dism.exe" -ArgumentList $dismandargs -Verb RunAs -Wait | Out-Null;
# Run SFC /scannow command
Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Verb RunAs -Wait;
# Create a restore point
Checkpoint-Computer -Description "My Restore Point" -restorepointtype Modify_Settings;
$tempdir = [System.IO.Path]::GetTempPath()