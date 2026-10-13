# Simple Monitoring Dashboard

A lightweight server monitoring project built with [Netdata](https://www.netdata.cloud/) on an Ubuntu VPS. This project monitors CPU usage, memory consumption, and disk I/O, with a custom CPU alert and shell scripts for setup, testing, and cleanup.

This project is part of the [roadmap.sh Simple Monitoring project](https://roadmap.sh/projects/simple-monitoring-dashboard).

## Overview

The goal of this project is to learn the fundamentals of Linux server monitoring and basic DevOps automation.

Netdata collects real-time system metrics and provides a web-based dashboard to visualize server performance. A custom health alert helps identify high CPU usage, while shell scripts simplify installation and validation.

## Features

- **Real-time monitoring:** Visualize CPU, memory, and disk I/O metrics.
- **Custom CPU alert:** Configure warning and critical thresholds.
- **Dashboard access:** Access the Netdata dashboard through a web browser.
- **Automated setup:** Install and configure Netdata using a shell script.
- **Automated testing:** Validate the Netdata API, required charts, CPU data, and alert registration.
- **Cleanup automation:** Remove the project's custom CPU alert with confirmation.
- **Secure remote access:** Use SSH tunneling to access the dashboard without exposing the Netdata port publicly.

## Technology Stack

| Technology | Purpose |
|---|---|
| Ubuntu 24.04 | VPS operating system |
| Netdata | Monitoring and visualization |
| Bash | Setup, testing, and cleanup automation |
| Python 3 | Parsing API responses during validation |
| curl | HTTP requests to the Netdata API |
| SSH | Secure remote server access |

## Requirements

- A Linux server running Ubuntu.
- SSH access and administrative privileges.
- `curl` and Python 3.
- `systemd` for service management.
- Internet access for installing Netdata.

## Project Structure

```text
simple-monitoring-dashboard/
├── configs/
│   └── cpu_usage.conf
├── setup.sh
├── test_dashboard.sh
├── cleanup.sh
└── README.md
```

## Installation and Setup

Clone the repository on your Linux server:

```bash
git clone https://github.com/codewithun/simple-monitoring-dashboard.git
cd simple-monitoring-dashboard
```

Make the scripts executable:

```bash
chmod +x setup.sh test_dashboard.sh cleanup.sh
```

Run the setup script:

```bash
./setup.sh
```

The setup script checks for Netdata, installs it if necessary, enables the service, installs the custom CPU alert configuration, and reloads the health configuration.

Verify that the service is running:

```bash
sudo systemctl status netdata
```

## Monitoring Dashboard

Netdata provides a web dashboard for observing server performance.

The main metrics monitored in this project are:

- **CPU usage:** Observe CPU activity and system load.
- **Memory usage:** Monitor RAM consumption.
- **Disk I/O:** Observe disk read/write activity.

The Netdata API is available locally at:

```text
http://localhost:19999
```

For remote access, use an SSH tunnel rather than exposing port `19999` directly to the public internet.

## Custom CPU Alert

The project includes a custom alert configuration in `configs/cpu_usage.conf`.

| Setting | Value |
|---|---|
| Monitored chart | `system.cpu` |
| Warning threshold | Above 80% |
| Critical threshold | Above 95% |
| Evaluation interval | 10 seconds |
| Average window | 1 minute |

The alert configuration:

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

Install or reload the alert through the setup script:

```bash
./setup.sh
```

Check registered alerts through the API:

```bash
curl -fsS 'http://localhost:19999/api/v1/alarms?all'
```

A `CLEAR` status indicates that the alert is registered but its configured thresholds are not currently being exceeded.

The alert is configured with `to: silent`, so external notifications are not enabled.

## Testing

Run the validation script:

```bash
./test_dashboard.sh
```

The script verifies:

1. Netdata API availability.
2. Required CPU, RAM, and disk I/O charts.
3. Availability of CPU metric data.
4. Registration of the custom CPU alert.

The expected final message is:

```text
[SUCCESS] Semua tes berhasil.
```

To use a different API endpoint:

```bash
NETDATA_URL=http://localhost:19999 ./test_dashboard.sh
```

## Secure Remote Access

From your local machine, create an SSH tunnel to the VPS:

```bash
ssh -i ~/.ssh/roadmap_server_key \
  -p 32200 \
  -L 19999:127.0.0.1:19999 \
  root@YOUR_SERVER_IP
```

Replace `YOUR_SERVER_IP` with your VPS public IP and adjust the SSH port and key path if needed.

Keep the SSH session open, then open this address in your browser:

```text
http://localhost:19999
```

The browser connects through the encrypted SSH tunnel to the Netdata service on the server.

## Cleanup

Run the cleanup script:

```bash
./cleanup.sh
```

The current cleanup script removes only the custom CPU alert configuration after asking for confirmation. It does not uninstall Netdata or delete monitoring history.

## Troubleshooting

### Netdata API is unavailable

Check the service:

```bash
sudo systemctl status netdata
```

Check the local API:

```bash
curl -fsS http://localhost:19999/api/v1/info
```

### Required charts are missing

Check the available charts:

```bash
curl -fsS http://localhost:19999/api/v1/charts
```

### Custom alert is missing

Check the configuration file:

```bash
sudo cat /etc/netdata/health.d/cpu_usage.conf
```

Reload the health configuration:

```bash
sudo netdatacli reload-health
```

### Dashboard cannot be opened remotely

Confirm that the SSH tunnel is running and that port `19999` is not being confused with the VPS's external SSH or HTTP port.

## Security Considerations

- Avoid exposing the Netdata dashboard directly to the public internet.
- Protect SSH private keys and server credentials.
- Review shell scripts before executing commands with elevated privileges.
- Use explicit confirmation for destructive cleanup operations.

## Learning Outcomes

Through this project, I practiced:

- Installing and managing a Linux monitoring agent.
- Reading real-time system metrics.
- Configuring custom monitoring alerts.
- Using HTTP APIs to validate monitoring data.
- Automating server tasks with Bash.
- Accessing server services securely through SSH tunneling.
- Documenting and maintaining a small DevOps project.

## Reference

- [roadmap.sh — Simple Monitoring](https://roadmap.sh/projects/simple-monitoring-dashboard)
- [Netdata Documentation](https://learn.netdata.cloud/docs/netdata-agent)
- [Netdata Installation Guide](https://learn.netdata.cloud/docs/netdata-agent/installation/linux)

## Author

**codewithun**

GitHub: [https://github.com/codewithun](https://github.com/codewithun)
