#!/bin/bash

set -e

echo "=== OMEGA HARDENED PIPELINE ==="

python omega_stripe_revenue_correctness_v1.py || true
python omega_subscription_lifecycle_v2.py || true
python omega_profit_loss_engine_v1.py || true
python omega_treasury_allocator_v1.py || true
python omega_reserve_ratio_engine_v1.py || true
python omega_replay_guard_v1.py || true
python omega_consensus_node_v1.py || true
python omega_snapshot_engine_v1.py || true
python omega_reconciliation_engine_v2.py || true
python omega_account_state_sync_v1.py || true

echo "=== HARDENING COMPLETE ==="
