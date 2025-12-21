# Ansible Windows + SQL Patching Project

This project provides a production-style starting point for:
- Windows OS patching via Task Scheduler
- SQL Server SP/CU patching via Task Scheduler
- Cluster-safe rolling patching (serial: 1)
- Logging for OS and SQL patches

## Structure

- inventories/hosts.ini          # Windows SQL hosts
- group_vars/windows_sql.yml     # Group defaults for patching
- host_vars/win-sql-01.yml       # Per-host SQL patch list (2016)
- host_vars/win-sql-02.yml       # Per-host SQL patch list (2019)
- playbooks/windows_cluster_patching.yml
- playbooks/windows_os_patching.yml
- playbooks/sql_patching.yml
- roles/windows_os_patch         # OS patching role
- roles/sql_patching             # SQL SP/CU patching role

## Basic Usage

Dry run first with:

    ansible-playbook -i inventories/hosts.ini playbooks/windows_cluster_patching.yml --check

Then run for real:

    ansible-playbook -i inventories/hosts.ini playbooks/windows_cluster_patching.yml

Adjust the following before use:
- Credentials in inventories/hosts.ini
- Patch file paths in group_vars/ and host_vars/
- Ensure patches are staged in C:\Patches and C:\SQLPatches on targets
