#!/data/data/com.termux/files/usr/bin/bash

mkdir -p logs

nohup python3 omega_async_settlement_worker.py \
> logs/async_settlement_worker.log 2>&1 &

nohup python3 omega_hold_expiration_worker.py \
> logs/hold_expiration_worker.log 2>&1 &

echo "OMEGA FINANCIAL WORKERS STARTED"

