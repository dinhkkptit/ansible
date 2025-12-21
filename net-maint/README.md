# Network Maintenance Ansible Project

This repository automates **Cisco NX-OS**, **Cisco IOS/IOS-XE**, and **Citrix NetScaler** maintenance with:

- Roles per platform: `pretask`, `maintask`, `posttask`
- Safe execution for junior engineers (`serial: 1`, explicit confirmation flag)
- Text snapshots per device (`_pre.txt`, `_down.txt`, `_up.txt`)
- Per-phase CSV outputs for easy audit:
  - `pretask_<run_ts>.csv`
  - `posttask_<run_ts>.csv`
  - `maintask_<hostname>_pre_<run_ts>.csv`
  - `maintask_<hostname>_down_<run_ts>.csv`
  - `maintask_<hostname>_wait_*_<run_ts>.csv`
  - `maintask_<hostname>_up_<run_ts>.csv`
- Optional **combined** CSV via `combine_maintenance_csv.py`.

---

## 1. Layout

```text
ansible.cfg
requirements.yml
inventory/
  hosts.yml
  group_vars/
    all.yml
    nxos.yml
    ios.yml
    netscaler.yml
playbooks/
  maintenance.yml
roles/
  common_csv/
    tasks/append_phase_csv.yml
  nxos_pretask/
  nxos_maintask/
  nxos_posttask/
  ios_pretask/
  ios_maintask/
  ios_posttask/
  netscaler_pretask/
  netscaler_maintask/
  netscaler_posttask/
PROMPT.md
combine_maintenance_csv.py
```

---

## 2. Install dependencies

```bash
ansible-galaxy collection install -r requirements.yml
```

---

## 3. Inventory and variables

Edit `inventory/hosts.yml` and `inventory/group_vars/*.yml` to match:

- IPs / credentials (add in `host_vars/<hostname>.yml`)
- NX-OS vPC pairs
- Critical port-channel IDs, etc.

**Important variables:**

- `maintenance_id` – used to build `snapshot_dir` (`./artifacts/<maintenance_id>`)
- `run_ts` – timestamp for this maintenance run.  
  - Recommended: pass from CLI:

    ```bash
    export RUN_TS=$(date +%Y%m%d-%H%M%S)
    ```

- `target_hosts_csv` – limit MAINTASK to specific hosts:

  ```bash
  -e target_hosts_csv="nxos-sw01,nxos-sw02"
  ```

---

## 4. Execution model

### 4.1. Guardrail

All plays require:

```bash
-e maintenance_confirm=true
```

or they abort.

### 4.2. Typical workflow

**1) PRETASK for all devices**

```bash
ansible-playbook playbooks/maintenance.yml \
  -e maintenance_confirm=true \
  -e maintenance_id=CHG-12345 \
  -e run_ts=$RUN_TS \
  --tags pretask
```

This will:

- Run show commands per profile
- Write `pretask_<run_ts>.csv` with columns:

  `timestamp,hostname,command,pretask_<run_ts>`

**2) MAINTASK one host at a time (for juniors)**

For NX-OS, run only one or a small list at a time:

```bash
ansible-playbook playbooks/maintenance.yml \
  -l nxos \
  --tags maintask \
  -e maintenance_confirm=true \
  -e maintenance_id=CHG-12345 \
  -e run_ts=$RUN_TS \
  -e target_hosts_csv="nxos-sw01"
```

Then repeat with:

```bash
-e target_hosts_csv="nxos-sw02"
```

NX-OS MAINTASK will:

- Save `<hostname>_pre.txt`, `_down.txt`, `_up.txt`
- Do vPC peer-check after DOWN snapshot
- Reboot and wait for:
  - vPC (`show vpc brief`)
  - HSRP (`show hsrp brief`)
  - OSPF (`show ip ospf neighbor vrf all`)
  - Critical port-channels
- Write CSV files like:
  - `maintask_<hostname>_pre_<run_ts>.csv`
  - `maintask_<hostname>_down_<run_ts>.csv`
  - `maintask_<hostname>_wait_vpc_<run_ts>.csv`
  - `maintask_<hostname>_wait_hsrp_<run_ts>.csv`
  - `maintask_<hostname>_wait_ospf_<run_ts>.csv`
  - `maintask_<hostname>_up_<run_ts>.csv`

**3) POSTTASK for all devices**

```bash
ansible-playbook playbooks/maintenance.yml \
  -e maintenance_confirm=true \
  -e maintenance_id=CHG-12345 \
  -e run_ts=$RUN_TS \
  --tags posttask
```

This writes:

- `posttask_<run_ts>.csv` with columns:  
  `timestamp,hostname,command,posttask_<run_ts>`

---

## 5. CSV format details

Every CSV has the same basic shape:

```text
timestamp,hostname,command,<phase_or_stage_column>
```

For example, `pretask_20251210-140000.csv`:

```csv
timestamp,hostname,command,pretask_20251210-140000
2025-12-10T14:01:12+07:00,nxos-sw01,"show vpc brief","Peer status : peer adjacency formed ok ..."
...
```

`maintask_nxos-sw01_down_20251210-140000.csv`:

```csv
timestamp,hostname,command,maintask_nxos-sw01_down_20251210-140000
2025-12-10T14:02:03+07:00,nxos-sw01,"show hsrp brief","Vlan10 Active ..."
...
```

---

## 6. Combined CSV (optional)

Use `combine_maintenance_csv.py` to join multiple CSVs by `(hostname,command)`.

Example:

```bash
python combine_maintenance_csv.py artifacts/CHG-12345 $RUN_TS
```

This will read:

- `pretask_<run_ts>.csv`
- `maintask_nxos-sw01_down_<run_ts>.csv`
- `maintask_nxos-sw01_up_<run_ts>.csv`
- `posttask_<run_ts>.csv`

and write:

```text
combined_pretask_maintask_posttask_<run_ts>.csv
```

with columns:

```text
hostname,command,pretask_<run_ts>,maintask_nxos-sw01_down_<run_ts>,maintask_nxos-sw01_up_<run_ts>,posttask_<run_ts>
```

You can extend the script to include additional hosts/columns (e.g. `nxos-sw02`) as needed.

---

## 7. Wait / health logic

- **HSRP (NX-OS)**  
  `show hsrp brief` until:
  - `ACTIVE` or `STANDBY` present (case-insensitive)
  - No `INIT`, `SPEAK`, `LISTEN`, `LEARN` in output

- **OSPF (NX-OS)**  
  `show ip ospf neighbor vrf all` until:
  - `FULL` present
  - No `INIT`, `2WAY`, `EXSTART`, `EXCHANGE`, `LOADING`

- **vPC (NX-OS)**  
  `show vpc brief` until:
  - Contains `peer adjacency formed ok`
  - Contains `peer is alive`
  - Does not contain `DOWN`

- **EtherChannel (IOS)**  
  `show etherchannel summary` until:
  - Output contains `PO`

- **NetScaler HA**  
  `show ha node` until:
  - Contains `PRIMARY` or `SECONDARY`
  - Does not contain `DOWN` or `DISABLED`

---

## 8. Prompt engineering support

See `PROMPT.md` for a reusable ChatGPT / AI prompt that describes:

- The environment (NX-OS, IOS, NetScaler)
- The roles and goals
- The CSV and snapshot patterns
- The wait/health logic

You can paste that prompt into ChatGPT to generate or adjust playbooks in this repo.
