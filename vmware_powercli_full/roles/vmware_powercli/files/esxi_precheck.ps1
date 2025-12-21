param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$host
)

Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password

$h = Get-VMHost $host

[PSCustomObject]@{
  Host = $h.Name
  Build = $h.Version
  PowerState = $h.PowerState
  ConnectionState = $h.ConnectionState
  RunningVMs = (Get-VM -VMHost $h | where PowerState -eq "PoweredOn").Count
  Datastores = ($h | Get-Datastore).Count
  HBAs = Get-VMHostHba -VMHost $h | Select Model,Driver
} | ConvertTo-Json -Depth 5
