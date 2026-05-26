#!/data/data/com.termux/files/usr/bin/bash

echo "OMEGA CREDIT RISK ENGINE STARTING..."

nohup python3 omega_credit_risk_loop.py > logs/risk_loop.log 2>&1 &
echo "Risk Loop PID: $!"

echo "ENGINE ONLINE"
