param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$vmname,
  [string]$target_host,
  [string]$target_datastore
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
Move-VM -VM $vmname -Destination (Get-VMHost $target_host) -Datastore (Get-Datastore $target_datastore) -Confirm:$false
