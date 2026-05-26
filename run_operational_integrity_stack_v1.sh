#!/data/data/com.termux/files/usr/bin/bash

cd ~/Omega-Production/omega_bank || exit 1

echo "================================================="
echo "🚀 OMEGA OPERATIONAL INTEGRITY STACK v1"
echo "================================================="

echo
echo "1️⃣ settlement engine"
python3 omega_settlement_engine_v2.py

echo
echo "2️⃣ webhook validation"
python3 omega_webhook_validation_layer_v1.py

echo
echo "3️⃣ reconciliation engine"
python3 omega_reconciliation_engine_v2.py

echo
echo "4️⃣ reconciliation router"
python3 omega_reconciliation_event_router_v1.py

echo
echo "5️⃣ external truth persistence"
python3 omega_external_truth_persistence_v1.py

echo
echo "6️⃣ audit proof system"
python3 omega_audit_proof_system_v1.py

echo
echo "7️⃣ balance proof generator"
python3 omega_balance_proof_generator_v1.py

echo
echo "8️⃣ operational monitoring"
python3 omega_operational_monitoring_v1.py

echo
echo "================================================="
echo "✅ OMEGA STACK COMPLETE"
echo "================================================="

