# Deployment

## Requirements
- Python 3.11+
- Stripe Account
- SQLite
- Flask
- Telegram Bot Token
- Cloudflare Tunnel (optional)

## Launch Runtime
chmod +x runtime/start.sh
./runtime/start.sh

## Dashboard
python dashboard/omega_dashboard_api_v1.py

## Billing Runtime
python omega_stripe_webhook_revenue_intake_v2.py
