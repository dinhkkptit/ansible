param(
  [string]$vcenter,
  [string]$username,
  [string]$password,
  [string]$cluster
)

Import-Module VMware.PowerCLI
Connect-VIServer $vcenter -User $username -Password $password
$hosts = Get-Cluster $cluster | Get-VMHost

foreach ($h in $hosts) {
  Write-Host "`n===== Host: $($h.Name) =====" -ForegroundColor Yellow

  $firm = Get-VMHostFirmware -VMHost $h
  $pci = Get-VMHostPciDevice -VMHost $h | Select Name,VendorName,DeviceName,Driver,VID,DID,SVID,SDID

  [PSCustomObject]@{
    Host = $h.Name
    Firmware = $firm.Version
    Build = $firm.Build
    PCI = $pci
  } | ConvertTo-Json -Depth 5
}
