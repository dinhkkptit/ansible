param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$host,
  [string]$bundlePath
)

Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password

$esx = Get-VMHost $host

Write-Host "Staging patch on $host" -ForegroundColor Cyan
Stage-VMHostPatch -VMHost $esx -LocalPath $bundlePath -HostPassword $password
