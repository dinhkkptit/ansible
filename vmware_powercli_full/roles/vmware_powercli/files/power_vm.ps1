param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [array]$vmlist,
  [string]$action
)
Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
foreach ($vm in $vmlist) {
  if ($action -eq "on") { Start-VM $vm -Confirm:$false }
  elseif ($action -eq "off") { Stop-VM $vm -Confirm:$false }
}
