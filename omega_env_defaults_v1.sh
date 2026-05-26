#!/usr/bin/env bash

if [ -z "$DATABASE_URL" ]; then
  export DATABASE_URL="sqlite:///$(pwd)/omega_ledger.db"
fi
