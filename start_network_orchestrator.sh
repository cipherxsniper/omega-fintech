#!/data/data/com.termux/files/usr/bin/bash

mkdir -p logs

nohup python3 omega_network_orchestrator.py \
> logs/network_orchestrator.log 2>&1 &

echo "OMEGA NETWORK ORCHESTRATOR STARTED"
echo $!
