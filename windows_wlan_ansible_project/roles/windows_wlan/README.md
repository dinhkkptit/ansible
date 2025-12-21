# windows_wlan (Ansible role)

Manage Windows Wi-Fi (WLAN) operations for automation/ops:
- Enable/disable a Wi-Fi adapter (NIC)
- Import a portable Wi-Fi profile XML (optionally hidden SSID)
- Connect to an SSID
- Set profile parameters (autoconnect, autoswitch)
- Optional: remove old/duplicate Wi-Fi profiles

## Role Variables

### Core
- `wlan_adapter_name` (default: `Wi-Fi 3`) – Adapter name from `Get-NetAdapter`
- `wlan_ssid` (default: `dinhkk`) – SSID/profile name to connect
- `wlan_connect` (default: `true`) – Run connect step
- `wlan_enable_adapter` (default: `true`) – Ensure adapter is Up
- `wlan_disable_adapter` (default: `false`) – Disable adapter (if true, overrides enable/connect)

### Profile import
- `wlan_profile_import` (default: `false`) – Import profile XML before connecting
- `wlan_profile_xml_path` (default: empty) – Path on Windows host to profile XML
- `wlan_profile_user` (default: `all`) – `all` or `current`

### Profile parameters
- `wlan_set_connectionmode_auto` (default: `true`) – Set `connectionmode=auto`
- `wlan_set_autoswitch_no` (default: `true`) – Set `autoswitch=no`

### Cleanup
- `wlan_cleanup_profiles` (default: `false`) – Delete profiles not in keep list
- `wlan_keep_profiles` (default: `[dinhkk]`) – Profiles to keep if cleanup enabled

## Tags
- `disable`, `enable`, `import`, `profile_params`, `connect`, `cleanup`
