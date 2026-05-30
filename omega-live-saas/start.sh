#!/bin/bash

echo "=== STARTING OMEGA SAAS ==="

python3 omega-live-saas/api/signup.py &
echo "API RUNNING ON :8080"

echo "FRONTEND READY (static files in frontend/)"

wait
