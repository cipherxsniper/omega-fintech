#!/data/data/com.termux/files/usr/bin/bash

mkdir -p logs

echo "STARTING OMEGA CONSENSUS GATE..."

nohup python3 omega_consensus_gate.py \
> logs/consensus_gate.log 2>&1 &

echo "CONSENSUS GATE PID: $!"
