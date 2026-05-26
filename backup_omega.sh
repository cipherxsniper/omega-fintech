#!/data/data/com.termux/files/usr/bin/bash

SRC="$HOME/Omega-Production/omega_bank"
DEST="$HOME/Omega-Production/omega_bank_backup_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$DEST"

cp -a "$SRC/." "$DEST/"

echo "Backup complete:"
echo "$DEST"
