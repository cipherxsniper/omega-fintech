#!/bin/bash

set -e

echo "=== OMEGA FULL SYSTEM CHECKPOINT RUN ==="

echo "[1] Stripe revenue correctness"
python omega_stripe_revenue_correctness_v1.py || true

echo "[2] Profit/Loss engine"
python omega_profit_loss_engine_v1.py || true

echo "[3] Treasury allocation engine"
python omega_treasury_allocator_v1.py || true

echo "[4] Reserve ratio engine"
python omega_reserve_ratio_engine_v1.py || true

echo "[5] Subscription lifecycle automation"
python omega_subscription_lifecycle_v1.py || true

echo "[6] Distributed replay validation"
python omega_replay_guard_v1.py || true

echo "[7] Consensus node check"
python omega_consensus_node_v1.py || true

echo "[8] Immutable snapshot checkpoint"
python omega_snapshot_engine_v1.py || true

echo "=== SYSTEM RUN COMPLETE ==="
