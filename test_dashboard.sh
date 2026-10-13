
#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${NETDATA_URL:-http://localhost:19999}"

echo "================================="
echo " Netdata Dashboard Test"
echo "================================="

echo "[1/3] Checking Netdata API..."

if ! curl -fsS --max-time 5 \
    "$BASE_URL/api/v1/info" >/dev/null; then
    echo "[FAIL] Netdata API tidak dapat diakses."
    echo "Pastikan Netdata aktif dan BASE_URL benar."
    exit 1
fi

echo "[OK] Netdata API merespons."

echo "[2/3] Checking required charts..."

CHARTS="$(curl -fsS --max-time 10 \
    "$BASE_URL/api/v1/charts")"

python3 -c '
import json
import sys

charts = json.loads(sys.argv[1]).get("charts", {})
required = ["system.cpu", "system.ram", "system.io"]
missing = [name for name in required if name not in charts]

for name in required:
    if name in charts:
        print(f"[OK] {name}")
    else:
        print(f"[FAIL] {name}")

sys.exit(1 if missing else 0)
' "$CHARTS"

echo "[3/3] Checking CPU data..."

curl -fsS --max-time 10 \
    "$BASE_URL/api/v1/data?chart=system.cpu&after=-60&points=3" |
python3 -c '
import json
import sys

data = json.load(sys.stdin)

if not data.get("data"):
    print("[FAIL] Data CPU kosong.")
    sys.exit(1)

print("[OK] Data CPU tersedia.")
'

echo "[SUCCESS] Semua tes berhasil."
