# Simple Monitoring Dashboard

A lightweight Linux server monitoring dashboard built with Netdata.

## Features

- Real-time CPU monitoring
- Memory monitoring
- Disk I/O monitoring
- Custom CPU alert:
  - Warning above 80%
  - Critical above 95%
- Automated setup and dashboard checks
- SSH tunnel access for safer remote monitoring

## Requirements

- Ubuntu Linux
- Root or sudo access
- Internet connection for installation
- SSH access to the server

## Installation

```bash
sudo bash setup.sh
```

## Access Dashboard

From your local machine, open an SSH tunnel:

```bash
ssh -L 19999:127.0.0.1:19999 roadmap-server
```

Keep the tunnel open and visit:

http://localhost:19999

## Test

Run on the Linux server:

```bash
sudo bash test_dashboard.sh
```

## Cleanup

```bash
bash cleanup.sh
```

The cleanup script does not uninstall Netdata or delete monitoring data.

## Security

Do not expose Netdata port 19999 directly to the public internet.
Use an SSH tunnel for remote dashboard access.
