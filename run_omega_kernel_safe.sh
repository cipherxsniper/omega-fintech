#!/usr/bin/env bash

set -e

echo "=== OMEGA KERNEL SAFE RUN ==="

echo "[1] GENERATING EVENTS (STRICT)"
python3 generate_replay_events_kernel_strict_v1.py

echo "[2] BUILDING POSTINGS (CANONICAL V9 FIXED)"
python3 build_postings_from_events_kernel_v9_fixed.py

echo "[3] RUNNING INVARIANT ENGINE (V4 ONLY)"
python3 invariant_engine_kernel_v4.py

echo "[4] RUNNING REPLAY ENGINE (FIXED)"
python3 omega_replay_runtime_v1_fixed.py

echo "=== KERNEL PIPELINE COMPLETE ==="
