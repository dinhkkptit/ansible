param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [array]$vmlist
)

Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password

foreach ($vm in $vmlist) {
  Write-Host "Upgrading VM Hardware for $vm" -ForegroundColor Green
  Set-VM -VM $vm -Version Upgrade -Confirm:$false
}
