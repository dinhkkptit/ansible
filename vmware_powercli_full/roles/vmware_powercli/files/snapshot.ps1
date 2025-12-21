param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [array]$vmlist
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
foreach ($vm in $vmlist) {
  New-Snapshot -VM $vm -Name "snap-$(Get-Date -Format yyyyMMdd-HHmmss)" -Memory:$true
}
