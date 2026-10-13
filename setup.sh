#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo " Simple Monitoring Dashboard"
echo " Setup Script"
echo "================================="

if ! command -v curl >/dev/null 2>&1; then
    echo "[ERROR] curl belum terpasang."
    exit 1
fi

if command -v netdata >/dev/null 2>&1; then
    echo "[OK] Netdata sudah terpasang."
else
    echo "[INFO] Netdata belum ditemukan."
    echo "[INFO] Menjalankan installer resmi Netdata..."

    curl -fsSL https://get.netdata.cloud/kickstart.sh \
        -o /tmp/netdata-kickstart.sh

    sudo sh /tmp/netdata-kickstart.sh --stable-channel
    rm -f /tmp/netdata-kickstart.sh
fi

if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl enable --now netdata
    sudo systemctl is-active --quiet netdata
    echo "[OK] Service Netdata aktif."
else
    echo "[WARN] systemctl tidak tersedia."
fi

echo "[SUCCESS] Setup selesai."
