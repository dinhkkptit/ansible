param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$host,
  [string]$mode
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
if ($mode -eq "enter") { Set-VMHost -VMHost $host -State Maintenance }
else { Set-VMHost -VMHost $host -State Connected }
