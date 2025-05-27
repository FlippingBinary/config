# This PowerShell script downloads the PlatformIO installer, runs it, then adds
# the scripts directory to the PATH.
#
# PlatformIO is used for embedded systems development

$scriptUrl = "https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py"
$installerPath = Join-Path -Path $env:TEMP -ChildPath "get-platformio.py"

Write-Host "Downloading installer to $installerPath"
Invoke-WebRequest -Uri $scriptUrl -OutFile $installerPath

$pythonPath = (Get-Command python).Path
$command = "$pythonPath `"$installerPath`""
Write-Host "Running installer with: $command"
# Start process with powershell to avoid creating a new window that quickly vanishes
# along with any error messages that might have appeared.
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -Command $command" -NoNewWindow -Wait

$penvPath = Join-Path -Path $env:USERPROFILE -ChildPath ".platformio\penv\Scripts"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $currentPath.Contains($penvPath)) {
  $newPath = "$currentPath;$penvPath"
  Write-Host "The PATH didn't have `"$penvPath`", so the user PATH is being modified to this: $newPath"
  [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
} else {
  Write-Host "The user's PATH already contains the scripts directory"
}
