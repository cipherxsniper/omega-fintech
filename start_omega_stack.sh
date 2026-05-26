#!/data/data/com.termux/files/usr/bin/bash

cd ~/Omega-Production/omega_bank || exit 1

mkdir -p logs

echo "======================================"
echo "     OMEGA PRODUCTION BOOT STACK"
echo "======================================"

echo "[1] PostgreSQL check..."
pg_isready >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "[!] Starting PostgreSQL..."
  pg_ctl -D $PREFIX/var/lib/postgresql start
fi

echo "[2] Cleaning old Omega processes..."
pkill -f omega_control_plane_terminal.py
pkill -f omega_execution_worker.py
pkill -f omega_settlement_worker.py
pkill -f omega_reconcile_watch.py
pkill -f omega_risk_engine.py

sleep 1

echo "[3] Starting Control Plane..."
nohup python3 omega_control_plane_terminal.py > logs/control_plane.log 2>&1 &
CONTROL_PID=$!

echo "[4] Starting Execution Worker..."
nohup python3 omega_execution_worker.py > logs/execution_worker.log 2>&1 &
EXEC_PID=$!

echo "[5] Starting Settlement Worker..."
nohup python3 omega_settlement_worker.py > logs/settlement_worker.log 2>&1 &
SETTLE_PID=$!

echo "[6] Starting Reconciliation Watcher..."
nohup python3 omega_reconcile_watch.py > logs/reconcile.log 2>&1 &
RECON_PID=$!

if [ -f omega_risk_engine.py ]; then
  echo "[7] Starting Risk Engine..."
  nohup python3 omega_risk_engine.py > logs/risk_engine.log 2>&1 &
  RISK_PID=$!
fi

echo ""
echo "======================================"
echo "OMEGA STACK ONLINE"
echo "======================================"
echo "Control Plane PID: $CONTROL_PID"
echo "Execution PID:     $EXEC_PID"
echo "Settlement PID:    $SETTLE_PID"
echo "Reconcile PID:     $RECON_PID"
echo "Risk PID:          ${RISK_PID:-N/A}"
echo "======================================"
echo ""

echo "tail -f logs/control_plane.log"
wait
