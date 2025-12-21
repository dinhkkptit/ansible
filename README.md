# Ansible Projects Monorepo

This repository contains multiple Ansible projects for different automation domains. Each project is self-contained with its own inventory, playbooks, roles, and documentation.

## Projects

### 1) Windows + SQL Patching
Path: `ansible_patching_project/`

Automates Windows OS patching and SQL Server SP/CU patching with cluster-safe rolling updates and logging.

- Docs: `ansible_patching_project/README.md`
- Key entry points:
  - `ansible_patching_project/playbooks/windows_cluster_patching.yml`
  - `ansible_patching_project/playbooks/windows_os_patching.yml`
  - `ansible_patching_project/playbooks/sql_patching.yml`

### 2) Network Maintenance
Path: `net-maint/`

Automates maintenance workflows for Cisco NX-OS, Cisco IOS/IOS-XE, and Citrix NetScaler devices with pre/maint/post task phases and CSV artifact capture.

- Docs: `net-maint/README.md`
- Key entry point:
  - `net-maint/playbooks/maintenance.yml`

### 3) Windows WLAN Management
Path: `windows_wlan_ansible_project/`

Provides an Ansible role to manage Windows Wi-Fi adapter state, profiles, and connections.

- Docs: `windows_wlan_ansible_project/README.md`
- Key entry points:
  - `windows_wlan_ansible_project/playbooks/enable_connect.yml`
  - `windows_wlan_ansible_project/playbooks/disable.yml`
  - `windows_wlan_ansible_project/playbooks/cleanup.yml`

### 4) VMware PowerCLI Integration
Path: `vmware_powercli_full/`

An Ansible setup intended to integrate with PowerCLI-based workflows.

- Example playbook: `vmware_powercli_full/example_playbook.yml`

## Getting Started

Each project has its own dependencies and configuration. Start with the README in the project you plan to use and follow its setup instructions.

## Repo Conventions

- All paths in this README are relative to the repo root.
- Projects are independent; inventories and credentials are not shared across projects.
