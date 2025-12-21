param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$host
)

Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password

$esx = Get-VMHost $host

Write-Host "Installing staged patch..." -ForegroundColor Cyan
Install-VMHostPatch -VMHost $esx -HostPassword $password -Confirm:$false

Write-Host "Rebooting host..."
Restart-VMHost -VMHost $esx -Confirm:$false
