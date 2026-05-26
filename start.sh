#!/bin/bash

echo "Starting Omega Financial Engine..."

uvicorn api.webhook_server:app --host 0.0.0.0 --port 8000 &

python workers/event_worker.py
