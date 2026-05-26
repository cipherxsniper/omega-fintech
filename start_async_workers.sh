#!/data/data/com.termux/files/usr/bin/bash

mkdir -p logs

nohup python3 omega_async_settlement_worker.py \
> logs/settlement_worker.log 2>&1 &

nohup python3 omega_authorization_expiration_worker.py \
> logs/expiration_worker.log 2>&1 &

nohup python3 omega_velocity_fraud_engine.py \
> logs/fraud_worker.log 2>&1 &

echo "OMEGA ASYNC WORKERS STARTED"
