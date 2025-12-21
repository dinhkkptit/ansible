param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$host,
  [string]$bundlePath
)

Import-Module VMware.PowerCLI
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server $vcenter -User $username -Password $password

$esx = Get-VMHost -Name $host

Write-Host "Entering Maintenance Mode..." -ForegroundColor Cyan
Set-VMHost -VMHost $esx -State Maintenance -Confirm:$false

Write-Host "Installing patch bundle..." -ForegroundColor Cyan
Install-VMHostPatch -VMHost $esx -LocalPath $bundlePath -HostUser $username -HostPassword $password -ConflictAction Overwrite

Write-Host "Rebooting host..." -ForegroundColor Cyan
Restart-VMHost -VMHost $esx -Confirm:$false

Write-Host "Waiting for host to reconnect..."
while ((Get-VMHost -Name $host).ConnectionState -ne "Connected") {
    Start-Sleep -Seconds 15
}

Write-Host "Exiting Maintenance Mode..." -ForegroundColor Cyan
Set-VMHost -VMHost $esx -State Connected
