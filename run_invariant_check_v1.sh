#!/bin/bash

cd ~/Omega-Production/omega_bank

python3 -m py_compile invariant_engine_v1.py
if [ $? -ne 0 ]; then
  echo "INVARIANT ENGINE COMPILATION FAILED"
  exit 1
fi

python3 invariant_engine_v1.py
