#!/data/data/com.termux/files/usr/bin/bash

echo "====================================="
echo "     OMEGA SAFE SHUTDOWN"
echo "====================================="

echo "[1] Stopping Python Omega processes..."

pkill -f omega_control_plane_terminal.py
pkill -f omega_execution_worker.py
pkill -f omega_settlement_worker.py
pkill -f omega_reconcile_watch.py
pkill -f omega_risk_engine.py

echo "[2] Killing orphan Python workers (safe filter)..."
pkill -f "python3 .*omega"

echo "[3] Checking PostgreSQL..."

pg_isready > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[4] PostgreSQL is running - leaving it alive (safe default)"
else
    echo "[4] PostgreSQL not responding"
fi

echo ""
echo "====================================="
echo "OMEGA STACK STOPPED (SAFE MODE)"
echo "====================================="
