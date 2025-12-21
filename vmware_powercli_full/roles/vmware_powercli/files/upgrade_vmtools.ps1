param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [array]$vmlist
)

Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password

foreach ($vm in $vmlist) {
  Write-Host "Upgrading Tools on VM: $vm" -ForegroundColor Cyan
  Update-Tools -VM $vm -NoReboot:$true
}
