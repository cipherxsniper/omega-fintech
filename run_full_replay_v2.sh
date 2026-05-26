#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "INIT SYSTEM ACCOUNTS"
python3 init_system_accounts_v2.py

echo "BUILD POSTINGS FROM EVENTS"
python3 build_postings_from_events_v2.py

echo "COMPILE INVARIANT ENGINE"
python3 -m py_compile invariant_engine_v2.py

echo "RUN INVARIANT ENGINE"
python3 invariant_engine_v2.py

echo "DONE: OMEGA LEDGER STATE VERIFIED"
