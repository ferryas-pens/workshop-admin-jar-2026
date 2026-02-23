#!/bin/bash
# ============================================================
# WORKSHOP ADMIN JARINGAN 2026
# Script Generator Konfigurasi Otomatis
# ============================================================
# Usage: ./generate-config.sh <KELAS> <KELOMPOK> <HOST_ID>
# Contoh: ./generate-config.sh A 5 10
# ============================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}Usage: $0 <KELAS> <KELOMPOK> [HOST_ID]${NC}"
    echo "  KELAS    : A, B, C, D, E, atau F"
    echo "  KELOMPOK : 1-10"
    echo "  HOST_ID  : 10-99 (opsional, default: 10)"
    echo ""
    echo "Contoh: $0 A 5 15"
    exit 1
fi

KELAS=$(echo "$1" | tr '[:lower:]' '[:upper:]')
KELOMPOK=$2
HOST_ID=${3:-10}

# Validate KELAS
case $KELAS in
    A) BASE_VLAN=51 ;;
    B) BASE_VLAN=61 ;;
    C) BASE_VLAN=71 ;;
    D) BASE_VLAN=81 ;;
    E) BASE_VLAN=91 ;;
    F) BASE_VLAN=101 ;;
    *)
        echo -e "${RED}Error: Kelas tidak valid. Pilih A, B, C, D, E, atau F${NC}"
        exit 1
        ;;
esac

# Validate KELOMPOK
if [ "$KELOMPOK" -lt 1 ] || [ "$KELOMPOK" -gt 10 ]; then
    echo -e "${RED}Error: Kelompok harus antara 1-10${NC}"
    exit 1
fi

# Validate HOST_ID
if [ "$HOST_ID" -lt 2 ] || [ "$HOST_ID" -gt 254 ]; then
    echo -e "${RED}Error: HOST_ID harus antara 2-254${NC}"
    exit 1
fi

# Calculate values
VLAN_ID=$((BASE_VLAN + KELOMPOK - 1))
PROXMOX_IP="10.252.108.$((20 + KELOMPOK))"
WAN_IP="10.252.108.$((50 + KELOMPOK))"
LAN_NETWORK="192.168.${KELOMPOK}"
PORT_SWITCH=$((KELOMPOK + 2))
HOST_IP="${LAN_NETWORK}.${HOST_ID}"

# Print header
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        WORKSHOP ADMIN JARINGAN 2026 - GENERATOR CONFIG         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Print configuration summary
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  KONFIGURASI UNTUK: KELAS ${KELAS} - KELOMPOK ${KELOMPOK}${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Informasi Jaringan:${NC}"
echo "  • VLAN ID        : ${VLAN_ID}"
echo "  • Port CSS326    : ${PORT_SWITCH}"
echo "  • Proxmox VE     : ${PROXMOX_IP}/24 (https://${PROXMOX_IP}:8006)"
echo "  • WAN IP (RB3011): ${WAN_IP}/24"
echo "  • LAN Network    : ${LAN_NETWORK}.0/24"
echo "  • LAN Gateway    : ${LAN_NETWORK}.1"
echo "  • Host IP        : ${HOST_IP}/24"
echo ""

# Generate Netplan configuration
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  NETPLAN CONFIGURATION (Ubuntu)${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
cat << EOF
# File: /etc/netplan/00-workshop-kelas${KELAS}-klp${KELOMPOK}.yaml
# Kelas ${KELAS}, Kelompok ${KELOMPOK}
# VLAN ID: ${VLAN_ID}

network:
  version: 2
  renderer: networkd
  
  ethernets:
    enp0s3:
      dhcp4: false
      dhcp6: false
  
  vlans:
    vlan${VLAN_ID}:
      id: ${VLAN_ID}
      link: enp0s3
      addresses:
        - ${HOST_IP}/24
      routes:
        - to: default
          via: ${LAN_NETWORK}.1
      nameservers:
        addresses:
          - 10.252.108.10
          - 8.8.8.8
EOF

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  MIKROTIK RB3011 CONFIGURATION${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
cat << EOF
# RouterOS Configuration for RB3011
# Kelas ${KELAS}, Kelompok ${KELOMPOK}

# 1. Set Identity
/system identity set name="RB3011-KELAS_${KELAS}-KLP${KELOMPOK}"

# 2. Interface Configuration
/interface ethernet set ether1 name=ether1-wan
/interface bridge add name=bridge-lan protocol-mode=none

/interface bridge port
add bridge=bridge-lan interface=ether2
add bridge=bridge-lan interface=ether3
add bridge=bridge-lan interface=ether4
add bridge=bridge-lan interface=ether5
add bridge=bridge-lan interface=ether6
add bridge=bridge-lan interface=ether7
add bridge=bridge-lan interface=ether8
add bridge=bridge-lan interface=ether9
add bridge=bridge-lan interface=ether10

# 3. IP Address
/ip address
add address=${WAN_IP}/24 interface=ether1-wan network=10.252.108.0 comment="WAN"
add address=${LAN_NETWORK}.1/24 interface=bridge-lan network=${LAN_NETWORK}.0 comment="LAN"

# 4. Routing
/ip route add gateway=10.252.108.1 comment="Default Gateway"

# 5. DNS
/ip dns set servers=10.252.108.10 allow-remote-requests=yes

# 6. DHCP Server
/ip pool add name=dhcp-pool ranges=${LAN_NETWORK}.100-${LAN_NETWORK}.200
/ip dhcp-server add name=dhcp-lan address-pool=dhcp-pool interface=bridge-lan disabled=no
/ip dhcp-server network add address=${LAN_NETWORK}.0/24 gateway=${LAN_NETWORK}.1 dns-server=10.252.108.10,8.8.8.8

# 7. NAT
/ip firewall nat add chain=srcnat out-interface=ether1-wan action=masquerade comment="NAT"

# 8. Basic Firewall
/ip firewall filter
add chain=input action=accept connection-state=established,related,untracked
add chain=input action=drop connection-state=invalid
add chain=input action=accept protocol=icmp
add chain=input action=accept src-address=10.252.108.0/24
add chain=input action=accept src-address=${LAN_NETWORK}.0/24
add chain=input action=drop in-interface=ether1-wan
add chain=forward action=accept connection-state=established,related,untracked
add chain=forward action=drop connection-state=invalid
add chain=forward action=accept in-interface=bridge-lan
add chain=forward action=drop in-interface=ether1-wan connection-nat-state=!dstnat

# 9. Logging to RSYSLOG
/system logging action add name=remote-syslog target=remote remote=10.252.108.20 remote-port=514
/system logging add action=remote-syslog topics=info
/system logging add action=remote-syslog topics=warning
/system logging add action=remote-syslog topics=error
EOF

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  VERIFIKASI COMMANDS${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
cat << EOF
# Di Ubuntu, jalankan:
sudo netplan generate
sudo netplan try --timeout 120
sudo netplan apply

# Verifikasi:
ip addr show vlan${VLAN_ID}
ip route show
ping -c 3 ${LAN_NETWORK}.1
ping -c 3 10.252.108.1
ping -c 3 10.252.108.10
ping -c 3 8.8.8.8
nslookup google.com
EOF

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              KONFIGURASI SELESAI DIGENERATE                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Ask if user wants to save to files
read -p "Simpan konfigurasi ke file? (y/n): " SAVE_CHOICE
if [ "$SAVE_CHOICE" = "y" ] || [ "$SAVE_CHOICE" = "Y" ]; then
    OUTDIR="./config-kelas${KELAS}-klp${KELOMPOK}"
    mkdir -p "$OUTDIR"
    
    # Save Netplan
    cat << EOF > "${OUTDIR}/netplan-config.yaml"
# File: /etc/netplan/00-workshop-kelas${KELAS}-klp${KELOMPOK}.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
      dhcp6: false
  vlans:
    vlan${VLAN_ID}:
      id: ${VLAN_ID}
      link: enp0s3
      addresses:
        - ${HOST_IP}/24
      routes:
        - to: default
          via: ${LAN_NETWORK}.1
      nameservers:
        addresses:
          - 10.252.108.10
          - 8.8.8.8
EOF

    # Save RouterOS config
    cat << EOF > "${OUTDIR}/rb3011-config.rsc"
# RouterOS Configuration
# Kelas ${KELAS}, Kelompok ${KELOMPOK}

/system identity set name="RB3011-KELAS_${KELAS}-KLP${KELOMPOK}"
/interface ethernet set ether1 name=ether1-wan
/interface bridge add name=bridge-lan protocol-mode=none
/interface bridge port
add bridge=bridge-lan interface=ether2
add bridge=bridge-lan interface=ether3
add bridge=bridge-lan interface=ether4
add bridge=bridge-lan interface=ether5
add bridge=bridge-lan interface=ether6
add bridge=bridge-lan interface=ether7
add bridge=bridge-lan interface=ether8
add bridge=bridge-lan interface=ether9
add bridge=bridge-lan interface=ether10
/ip address
add address=${WAN_IP}/24 interface=ether1-wan network=10.252.108.0 comment="WAN"
add address=${LAN_NETWORK}.1/24 interface=bridge-lan network=${LAN_NETWORK}.0 comment="LAN"
/ip route add gateway=10.252.108.1 comment="Default Gateway"
/ip dns set servers=10.252.108.10 allow-remote-requests=yes
/ip pool add name=dhcp-pool ranges=${LAN_NETWORK}.100-${LAN_NETWORK}.200
/ip dhcp-server add name=dhcp-lan address-pool=dhcp-pool interface=bridge-lan disabled=no
/ip dhcp-server network add address=${LAN_NETWORK}.0/24 gateway=${LAN_NETWORK}.1 dns-server=10.252.108.10,8.8.8.8
/ip firewall nat add chain=srcnat out-interface=ether1-wan action=masquerade comment="NAT"
/ip firewall filter
add chain=input action=accept connection-state=established,related,untracked
add chain=input action=drop connection-state=invalid
add chain=input action=accept protocol=icmp
add chain=input action=accept src-address=10.252.108.0/24
add chain=input action=accept src-address=${LAN_NETWORK}.0/24
add chain=input action=drop in-interface=ether1-wan
add chain=forward action=accept connection-state=established,related,untracked
add chain=forward action=drop connection-state=invalid
add chain=forward action=accept in-interface=bridge-lan
add chain=forward action=drop in-interface=ether1-wan connection-nat-state=!dstnat
/system logging action add name=remote-syslog target=remote remote=10.252.108.20 remote-port=514
/system logging add action=remote-syslog topics=info
/system logging add action=remote-syslog topics=warning
/system logging add action=remote-syslog topics=error
EOF

    # Save info file
    cat << EOF > "${OUTDIR}/INFO.txt"
WORKSHOP ADMIN JARINGAN 2026
============================
Kelas    : ${KELAS}
Kelompok : ${KELOMPOK}
============================

VLAN ID       : ${VLAN_ID}
Port CSS326   : ${PORT_SWITCH}
Proxmox VE    : ${PROXMOX_IP}/24
Proxmox URL   : https://${PROXMOX_IP}:8006
WAN IP        : ${WAN_IP}/24
LAN Network   : ${LAN_NETWORK}.0/24
LAN Gateway   : ${LAN_NETWORK}.1
Host IP       : ${HOST_IP}/24

INFRASTRUKTUR:
- Gateway HO  : 10.252.108.1
- DNS HO      : 10.252.108.10
- RSYSLOG HO  : 10.252.108.20
- Switch CSS  : 10.252.108.4
EOF

    echo -e "${GREEN}File disimpan di: ${OUTDIR}/${NC}"
    ls -la "$OUTDIR"
fi

echo ""
echo -e "${YELLOW}CATATAN PENTING:${NC}"
echo "CSS326 menggunakan SwOS dan hanya bisa dikonfigurasi via Web UI."
echo "Hubungi asisten untuk konfigurasi VLAN di switch."
echo "Akses switch: http://10.252.108.4"
echo ""
echo "Selesai!"
