#!/data/data/com.termux/files/usr/bin/bash

echo "[OMEGA] starting full processor stack..."

nohup python3 -m uvicorn omega_api:app --host 0.0.0.0 --port 8000 \
  > runtime/logs/api.log 2>&1 &

nohup python3 omega_settlement_worker.py \
  > runtime/logs/worker.log 2>&1 &

nohup python3 omega_reconcile_watch.py \
  > runtime/logs/reconcile.log 2>&1 &

echo "[OMEGA] stack online"
