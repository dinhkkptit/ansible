# Windows WLAN Ansible Project

This project contains an Ansible role `windows_wlan` to manage Windows Wi-Fi operations:
- Enable/disable a Wi-Fi adapter (NIC)
- Import a Wi-Fi profile XML
- Set profile parameters (autoconnect + autoswitch)
- Connect to SSID
- Optional cleanup of saved Wi-Fi profiles

## Quick start

1) Install required collection:
```bash
ansible-galaxy collection install ansible.windows
```

2) Edit `inventory.ini` (host IP/credentials).

3) Run an example playbook:

Enable adapter + connect:
```bash
ansible-playbook playbooks/enable_connect.yml
```

Disable adapter:
```bash
ansible-playbook playbooks/disable.yml
```

Cleanup profiles (keep only dinhkk):
```bash
ansible-playbook playbooks/cleanup.yml
```

## Notes
- NIC enable/disable generally needs Administrator rights on the Windows host.
- Wi-Fi profile XML can include plaintext password; protect it appropriately.
