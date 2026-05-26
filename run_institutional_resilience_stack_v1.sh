#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "================================================="
echo "🏛 OMEGA INSTITUTIONAL RESILIENCE STACK v1"
echo "================================================="

echo ""
echo "1️⃣ governance lock manager"
python3 ~/Omega-Production/omega_bank/omega_governance_lock_manager_v1.py

echo ""
echo "2️⃣ runtime failover coordinator"
python3 ~/Omega-Production/omega_bank/omega_runtime_failover_coordinator_v1.py

echo ""
echo "3️⃣ external webhook replay validator"
python3 ~/Omega-Production/omega_bank/omega_external_webhook_replay_validator_v1.py

echo ""
echo "================================================="
echo "✅ OMEGA INSTITUTIONAL RESILIENCE COMPLETE"
echo "================================================="
