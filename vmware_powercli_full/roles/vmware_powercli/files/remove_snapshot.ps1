param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [array]$vmlist
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
foreach ($vm in $vmlist) {
  Get-VM -Name $vm | Get-Snapshot | Remove-Snapshot -Confirm:$false
}
