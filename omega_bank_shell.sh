#!/data/data/com.termux/files/usr/bin/bash

echo "====================================="
echo "      OMEGA BANK CONTROL SHELL"
echo "====================================="

cd ~/Omega-Production/omega_bank || exit 1

echo "[1] Starting PostgreSQL check..."
pg_isready || {
  echo "[!] PostgreSQL not ready - starting..."
  pg_ctl -D $PREFIX/var/lib/postgresql start
}

echo "[2] Launching Control Plane UI..."
python3 omega_control_plane_ui.py &
UI_PID=$!

echo "[3] Launching Execution Worker..."
python3 omega_execution_worker.py &
WORKER_PID=$!

echo "[4] Launching Settlement Worker..."
python3 omega_settlement_worker.py &
SETTLE_PID=$!

echo ""
echo "OMEGA SYSTEM RUNNING"
echo "UI PID: $UI_PID"
echo "WORKER PID: $WORKER_PID"
echo "SETTLEMENT PID: $SETTLE_PID"
echo ""
echo "Type 'stop_omega' to kill all processes"
echo ""

# keep shell alive
wait
