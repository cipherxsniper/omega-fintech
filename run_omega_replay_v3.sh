#!/data/data/com.termux/files/usr/bin/bash

cd ~/Omega-Production/omega_bank

echo "BUILDING POSTINGS..."
python3 build_postings_from_events_v3.py

echo "RUNNING REPLAY..."
python3 omega_replay_runtime_v1_fixed.py

echo "DONE"
