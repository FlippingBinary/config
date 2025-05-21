Test-WSMan -ComputerName localhost -ErrorAction SilentlyContinue
$hasWinRM = $?

if (-not $hasWinRM) {
  Write-Warning "WinRM is not configured. Enabling it now..."
  try {
    winrm quickconfig -quiet
    winrm set winrm/config/service/auth '@{Basic="false"}'
    winrm set winrm/config/service/auth '@{Digest="true"}'
    Write-Host "WinRM has been successfully configured."
  } catch {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if ($isAdmin) {
      Write-Error "Failed to configure WinRM. DSC won't work without it."
    } else {
      Write-Error "Failed to configure WinRM. Try again in an elevated prompt."
    }
    exit 1
  }
}

