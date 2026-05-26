#!/usr/bin/env bash

set -e

cd ~/Omega-Production/omega_bank

python3 generate_replay_events_kernel_strict_v1.py
python3 build_postings_from_events_kernel_v9_fixed.py
python3 invariant_engine_kernel_stable.py
python3 omega_replay_runtime_v1_fixed.py

echo "✔ FINAL KERNEL STATE VALID"
