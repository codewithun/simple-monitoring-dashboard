
#!/usr/bin/env bash
set -euo pipefail

ALERT_FILE="/etc/netdata/health.d/cpu_usage.conf"

echo "================================="
echo " Netdata Cleanup"
echo "================================="
echo "Script ini hanya menghapus custom CPU alert."
echo "Netdata dan data monitoring tidak akan dihapus."
echo

if [[ ! -f "$ALERT_FILE" ]]; then
    echo "[INFO] Custom CPU alert tidak ditemukan."
    exit 0
fi

read -r -p "Yakin ingin menghapus custom CPU alert? (y/N): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "[CANCELLED] Tidak ada perubahan."
    exit 0
fi

sudo rm "$ALERT_FILE"
sudo netdatacli reload-health

echo "[SUCCESS] Custom CPU alert berhasil dihapus."
