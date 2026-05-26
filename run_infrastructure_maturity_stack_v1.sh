#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "================================================="
echo "🏦 OMEGA INFRASTRUCTURE MATURITY STACK v1"
echo "================================================="

echo ""
echo "1️⃣ settlement engine"
python3 ~/Omega-Production/omega_bank/omega_settlement_engine_v2.py

echo ""
echo "2️⃣ webhook validation"
python3 ~/Omega-Production/omega_bank/omega_webhook_validation_layer_v1.py

echo ""
echo "3️⃣ reconciliation engine"
python3 ~/Omega-Production/omega_bank/omega_reconciliation_engine_v2.py

echo ""
echo "4️⃣ reconciliation router"
python3 ~/Omega-Production/omega_bank/omega_reconciliation_event_router_v1.py

echo ""
echo "5️⃣ external truth persistence"
python3 ~/Omega-Production/omega_bank/omega_external_truth_persistence_v1.py

echo ""
echo "6️⃣ audit proof system"
python3 ~/Omega-Production/omega_bank/omega_audit_proof_system_v1.py

echo ""
echo "7️⃣ balance proof generator"
python3 ~/Omega-Production/omega_bank/omega_balance_proof_generator_v1.py

echo ""
echo "8️⃣ operational monitoring"
python3 ~/Omega-Production/omega_bank/omega_operational_monitoring_v1.py

echo ""
echo "9️⃣ operational alerting"
python3 ~/Omega-Production/omega_bank/omega_operational_alerting_v1.py

echo ""
echo "================================================="
echo "✅ OMEGA INFRASTRUCTURE MATURITY COMPLETE"
echo "================================================="
