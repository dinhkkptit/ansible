import csv
from pathlib import Path
import sys

def main():
    if len(sys.argv) < 3:
        print("Usage: python combine_maintenance_csv.py <snapshot_dir> <run_ts>")
        sys.exit(1)

    snapshot_dir = Path(sys.argv[1])
    run_ts = sys.argv[2]

    pretask_file  = snapshot_dir / f"pretask_{run_ts}.csv"
    posttask_file = snapshot_dir / f"posttask_{run_ts}.csv"
    # Example for a single vPC pair, adjust or extend as needed:
    sw1_down_file = snapshot_dir / f"maintask_nxos-sw01_down_{run_ts}.csv"
    sw1_up_file   = snapshot_dir / f"maintask_nxos-sw01_up_{run_ts}.csv"

    col_pretask  = f"pretask_{run_ts}"
    col_sw1_down = f"maintask_nxos-sw01_down_{run_ts}"
    col_sw1_up   = f"maintask_nxos-sw01_up_{run_ts}"
    col_posttask = f"posttask_{run_ts}"

    combined = {}

    def load_phase_csv(csv_path, value_column_name):
        if not csv_path.exists():
            return
        with csv_path.open(newline='', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                hostname = row['hostname']
                command = row['command']
                fields = list(row.keys())
                phase_col = fields[-1]
                value = row[phase_col]
                key = (hostname, command)
                combined.setdefault(key, {})
                combined[key][value_column_name] = value

    load_phase_csv(pretask_file,  col_pretask)
    load_phase_csv(sw1_down_file, col_sw1_down)
    load_phase_csv(sw1_up_file,   col_sw1_up)
    load_phase_csv(posttask_file, col_posttask)

    combined_file = snapshot_dir / f"combined_pretask_maintask_posttask_{run_ts}.csv"
    with combined_file.open('w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['hostname', 'command',
                         col_pretask, col_sw1_down, col_sw1_up, col_posttask])
        for (hostname, command), phases in sorted(combined.items()):
            writer.writerow([
                hostname,
                command,
                phases.get(col_pretask,  ''),
                phases.get(col_sw1_down, ''),
                phases.get(col_sw1_up,   ''),
                phases.get(col_posttask, ''),
            ])
    print(f"Wrote {combined_file}")

if __name__ == "__main__":
    main()
