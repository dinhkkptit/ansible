param(
  [string]$vcenter,
  [string]$username,
  [string]$password
)

Import-Module VMware.PowerCLI
Connect-VIServer -Server $vcenter -User $username -Password $password

$updates = Get-VIApplianceUpdate
$updates | Format-List *
