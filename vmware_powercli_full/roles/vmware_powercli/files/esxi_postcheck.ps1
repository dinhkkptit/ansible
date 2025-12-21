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
  BuildVersion = (Get-VMHostFirmware -VMHost $h).Version
  DatastoreCheck = (($h | Get-Datastore).Count -gt 0)
  NetworkAdapters = Get-VMHostNetworkAdapter -VMHost $h | Select Name,MAC,Driver
  Services = Get-VMHostService -VMHost $h | Select Key,Running
} | ConvertTo-Json -Depth 5
