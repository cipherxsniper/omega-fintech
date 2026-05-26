#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "================================================="
echo "🏛 OMEGA GOVERNANCE MATURITY STACK v1"
echo "================================================="

python3 ~/Omega-Production/omega_bank/omega_governance_control_plane_v1.py

python3 ~/Omega-Production/omega_bank/omega_deterministic_worker_mesh_v1.py

python3 ~/Omega-Production/omega_bank/omega_operational_integrity_index_v1.py

python3 ~/Omega-Production/omega_bank/omega_infrastructure_checkpoint_orchestrator_v1.py

echo "================================================="
echo "✅ GOVERNANCE MATURITY STACK COMPLETE"
echo "================================================="
