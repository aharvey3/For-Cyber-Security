#!/usr/bin/env python3
# failed_ssh_check.py - Parses /var/log/auth.log for failed SSH attempts

import re
from collections import Counter

log_file = "/var/log/auth.log"
failed_pattern = r"Failed password for .* from (\d+\.\d+\.\d+\.\d+)"

failed_ips = []

with open(log_file, "r") as f:
    for line in f:
        match = re.search(failed_pattern, line)
        if match:
            failed_ips.append(match.group(1))

print(f"Total failed attempts: {len(failed_ips)}")
for ip, count in Counter(failed_ips).most_common(10):
    print(f"{ip:15} : {count} attempts")

# Optional: block top offenders via firewall (uncomment with caution)
# import subprocess
# for ip, _ in Counter(failed_ips).most_common(5):
#     subprocess.run(["sudo", "iptables", "-A", "INPUT", "-s", ip, "-j", "DROP"])
