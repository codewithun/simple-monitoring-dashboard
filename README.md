# Simple Monitoring Dashboard

A lightweight server monitoring project using Netdata to monitor CPU,
memory, and disk I/O on an Ubuntu VPS.

## Features

- Real-time server monitoring with Netdata.
- CPU, RAM, and disk I/O monitoring.
- Custom CPU usage alert.
- Automated setup and dashboard validation scripts.
- Safe cleanup script for the custom CPU alert.

## Requirements

- Ubuntu VPS.
- SSH access to the server.
- sudo privileges.
- curl and Python 3.
- Netdata dashboard running on port 19999.

## Project Structure

```text
simple-monitoring-dashboard/
├── setup.sh
├── test_dashboard.sh
├── cleanup.sh
└── README.md
```

## Setup

Run this script on the Ubuntu VPS, not on your local MacBook:

```bash
chmod +x setup.sh test_dashboard.sh cleanup.sh
./setup.sh
```

## Configure CPU Alert

Create the following file on the VPS:

`/etc/netdata/health.d/cpu_usage.conf`

```conf
alarm: custom_cpu_usage
    on: system.cpu
 lookup: average -1m unaligned of user,system,softirq,irq,guest
 units: %
 every: 10s
   warn: $this > 80
   crit: $this > 95
 summary: Custom CPU usage alert
    info: CPU usage is high
    to: silent
```

Reload the health configuration:

```bash
sudo netdatacli reload-health
```

The alert changes to WARNING above 80% CPU usage and CRITICAL above 95%.
Actual alert behavior depends on the collected metric and evaluation period.

## Test Dashboard

Run on the VPS:

```bash
./test_dashboard.sh
```

The test checks the Netdata API, required charts, and CPU data.

## Access Dashboard Securely

From your local MacBook terminal, open an SSH tunnel:

```bash
ssh -i ~/.ssh/roadmap_server_key \
  -p 32200 \
  -L 19999:127.0.0.1:19999 \
  root@169.58.223.6
```

Keep the terminal open and visit:

http://localhost:19999

## Cleanup

Run on the VPS:

```bash
./cleanup.sh
```

This removes only the custom CPU alert configuration.
It does not uninstall Netdata or delete monitoring history.

## Security

- Prefer SSH tunneling over exposing port 19999 publicly.
- Keep SSH private keys secure.
- Review scripts before running them with sudo.
