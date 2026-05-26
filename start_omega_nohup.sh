#!/data/data/com.termux/files/usr/bin/bash

cd ~/Omega-Production/omega_bank || exit 1

mkdir -p logs

echo "======================================"
echo "      OMEGA NOHUP START STACK"
echo "======================================"

echo "[1] PostgreSQL check..."
pg_isready || {
  echo "[!] Starting PostgreSQL..."
  pg_ctl -D $PREFIX/var/lib/postgresql start
}

echo "[2] Starting Control Plane..."
nohup python3 omega_control_plane_terminal.py > logs/control_plane.log 2>&1 &
CONTROL_PID=$!

echo "[3] Starting Execution Worker..."
nohup python3 omega_execution_worker.py > logs/execution_worker.log 2>&1 &
EXEC_PID=$!

echo "[4] Starting Settlement Worker..."
nohup python3 omega_settlement_worker.py > logs/settlement_worker.log 2>&1 &
SETTLE_PID=$!

echo "[5] Starting Reconciliation Watcher..."
nohup python3 omega_reconcile_watch.py > logs/reconcile.log 2>&1 &
RECON_PID=$!

echo "[6] Starting Risk Engine..."
nohup python3 omega_risk_engine.py > logs/risk_engine.log 2>&1 &
RISK_PID=$!

echo ""
echo "======================================"
echo "OMEGA STACK RUNNING (NOHUP MODE)"
echo "======================================"
echo "Control Plane PID: $CONTROL_PID"
echo "Execution PID:     $EXEC_PID"
echo "Settlement PID:    $SETTLE_PID"
echo "Reconcile PID:     $RECON_PID"
echo "Risk PID:          $RISK_PID"
echo "======================================"
echo ""
echo "TAIL COMMANDS:"
echo "  tail -f logs/control_plane.log"
echo "  tail -f logs/risk_engine.log"
echo "======================================"

wait
