#!/data/data/com.termux/files/usr/bin/bash

SRC="$HOME/Omega-Production/omega_bank/"
DEST="$HOME/Omega-Production/omega_bank_backup/"

mkdir -p "$DEST"

rsync -av --delete "$SRC" "$DEST"

echo "Sync complete"
