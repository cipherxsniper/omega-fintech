
#!/data/data/com.termux/files/usr/bin/bash

echo "[OMEGA] Starting processor-grade settlement stack..."

nohup python3 omega_settlement_orchestrator.py \
> settlement.log 2>&1 &

nohup python3 omega_spend_engine.py \
> spend_engine.log 2>&1 &

nohup python3 reconciliation_daemon.py \
> reconciliation.log 2>&1 &

nohup python3 auth_capture_worker.py \
> auth_capture.log 2>&1 &

echo "[OMEGA] Processor stack online."

