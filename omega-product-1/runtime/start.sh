#!/bin/bash

echo "=== OMEGA PRODUCT 1 START ==="

python runtime/omega_runtime_launcher_v1.py || true
python dashboard/omega_dashboard_api_v1.py || true
python omega_stripe_webhook_revenue_intake_v2.py || true

echo "=== OMEGA PRODUCT ACTIVE ==="
