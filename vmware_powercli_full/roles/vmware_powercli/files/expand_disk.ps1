param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$vmname,
  [int]$NewSizeGB
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
Get-VM -Name $vmname | Get-HardDisk | Select -First 1 | Set-HardDisk -CapacityGB $NewSizeGB -Confirm:$false
