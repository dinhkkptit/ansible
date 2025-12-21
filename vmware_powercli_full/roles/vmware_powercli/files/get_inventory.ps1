param(
  [string]$vcenter,
  [string]$username,
  [string]$password
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
[PSCustomObject]@{
  Hosts = Get-VMHost
  Datastores = Get-Datastore
  VMs = Get-VM
} | ConvertTo-Json -Depth 5
