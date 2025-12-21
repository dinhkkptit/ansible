param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$cluster,
  [string]$bundlePath
)

Import-Module VMware.PowerCLI
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server $vcenter -User $username -Password $password

$hosts = Get-Cluster $cluster | Get-VMHost | Sort Name

foreach ($h in $hosts) {

    Write-Host "=== Processing host $($h.Name) ===" -ForegroundColor Yellow

    Write-Host "Entering maintenance mode..."
    Set-VMHost -VMHost $h -State Maintenance -Confirm:$false

    Write-Host "Applying patch..."
    Install-VMHostPatch -VMHost $h -LocalPath $bundlePath -HostUser $username -HostPassword $password -ConflictAction Overwrite

    Write-Host "Rebooting host..."
    Restart-VMHost -VMHost $h -Confirm:$false

    Write-Host "Waiting for host to return..." -ForegroundColor Cyan
    while ((Get-VMHost $h.Name).ConnectionState -ne "Connected") {
        Start-Sleep -Seconds 15
    }

    Write-Host "Exiting maintenance..." -ForegroundColor Cyan
    Set-VMHost -VMHost $h -State Connected

    Write-Host "=== Host $($h.Name) upgrade complete ===" -ForegroundColor Green
}
