#!/usr/bin/env bash

echo "================================================="
echo "🔐 OMEGA ENV INTEGRITY CHECK v1"
echo "================================================="

python3 - << 'PY'
from omega_env_safe_v1 import env_health_check, get_database_path

print("ENV STATUS:", env_health_check())
print("DB PATH:", get_database_path())
PY

echo "================================================="
echo "✅ ENV INTEGRITY COMPLETE"
echo "================================================="
