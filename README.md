# HTB “Dancing” SMB Exploit

**Description**  
Exploited a misconfigured SMB share on Hack The Box’s “Dancing” box to retrieve `flag.txt`.

## Contents
- [Write‑Up](writeup/lab-writeup.md)
- [Screenshots](screenshots/)
- [Automation Script](scripts/enum-smb.sh)

## Prerequisites
- Kali Linux (nmap, smbclient) or Parrot OS
- HTB VPN connection

## Quick Start
```bash
git clone https://github.com/keyfive5/obsidiansignal-htb-dancing.git
cd obsidiansignal-htb-dancing
bash scripts/enum-smb.sh 10.129.232.112
