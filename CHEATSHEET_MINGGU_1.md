# CHEAT SHEET - WORKSHOP ADMIN JARINGAN 2026
## Referensi Cepat Konfigurasi Kelompok (v2.2)

---

## FORMULA CEPAT

```
VLAN_ID    = BASE_VLAN + (Nomor_Kelompok - 1)
PROXMOX_IP = 10.252.108.(20 + Nomor_Kelompok)
WAN_IP     = 10.252.108.(50 + Nomor_Kelompok)
LAN_NET    = 192.168.{Nomor_Kelompok}.0/24
PORT_SW    = Nomor_Kelompok + 2

BASE_VLAN per Kelas:
├── Kelas A = 51   (VLAN 51-60)
├── Kelas B = 61   (VLAN 61-70)
├── Kelas C = 71   (VLAN 71-80)
├── Kelas D = 81   (VLAN 81-90)
├── Kelas E = 91   (VLAN 91-100)
└── Kelas F = 101  (VLAN 101-110)
```

---

## INFRASTRUKTUR TETAP

| Komponen | IP Address | Keterangan |
|----------|------------|------------|
| Gateway HO (RB1100) | 10.252.108.1 | Router utama |
| Switch CSS326 | 10.252.108.4 | SwOS Web UI |
| DNS Server | 10.252.108.10 | DNS internal |
| RSYSLOG Server | 10.252.108.20 | Log collector |
| Proxmox VE Klp 1-10 | 10.252.108.21-30 | Cloud Service |
| RB3011 WAN Klp 1-10 | 10.252.108.51-60 | Router kelompok |

### Proxmox VE per Kelompok

| Kelompok | Proxmox IP | Web UI |
|----------|------------|--------|
| 1 | 10.252.108.21 | https://10.252.108.21:8006 |
| 2 | 10.252.108.22 | https://10.252.108.22:8006 |
| 3 | 10.252.108.23 | https://10.252.108.23:8006 |
| 4 | 10.252.108.24 | https://10.252.108.24:8006 |
| 5 | 10.252.108.25 | https://10.252.108.25:8006 |
| 6 | 10.252.108.26 | https://10.252.108.26:8006 |
| 7 | 10.252.108.27 | https://10.252.108.27:8006 |
| 8 | 10.252.108.28 | https://10.252.108.28:8006 |
| 9 | 10.252.108.29 | https://10.252.108.29:8006 |
| 10 | 10.252.108.30 | https://10.252.108.30:8006 |

---

## CSS326 SwOS - KONFIGURASI VIA WEB UI

> ⚠️ **CSS326 menggunakan SwOS, BUKAN RouterOS!**  
> Konfigurasi HANYA via browser: `http://10.252.108.4`

### Akses Awal (IP Default)
```
URL: http://192.168.88.1
Username: admin
Password: (kosong)
```

### VLAN Setting di Web UI

**Tab: VLAN**

| Setting | Nilai |
|---------|-------|
| Port 1 (Uplink) | **T** (Tagged) untuk semua VLAN |
| Port 3-12 (Access) | **U** (Untagged) untuk VLAN masing-masing |

**PVID per Kelas:**

| Port | Kelas A | Kelas B | Kelas C | Kelas D | Kelas E | Kelas F |
|------|---------|---------|---------|---------|---------|---------|
| 3 | 51 | 61 | 71 | 81 | 91 | 101 |
| 4 | 52 | 62 | 72 | 82 | 92 | 102 |
| 5 | 53 | 63 | 73 | 83 | 93 | 103 |
| 6 | 54 | 64 | 74 | 84 | 94 | 104 |
| 7 | 55 | 65 | 75 | 85 | 95 | 105 |
| 8 | 56 | 66 | 76 | 86 | 96 | 106 |
| 9 | 57 | 67 | 77 | 87 | 97 | 107 |
| 10 | 58 | 68 | 78 | 88 | 98 | 108 |
| 11 | 59 | 69 | 79 | 89 | 99 | 109 |
| 12 | 60 | 70 | 80 | 90 | 100 | 110 |

### Pergantian Kelas (Untuk Asisten)

**Opsi 1:** Edit PVID manual di tab VLAN/Ports  
**Opsi 2:** Load backup file per kelas:
- `CSS326-KELAS-A.swb`
- `CSS326-KELAS-B.swb`
- dst...

---

## NETPLAN TEMPLATE CEPAT

### Direct LAN (Tanpa VLAN)
```yaml
# /etc/netplan/00-direct.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: true
```

### Dengan VLAN (Trunk Port)
```yaml
# /etc/netplan/00-vlan.yaml
# Ganti: VLAN_ID, KELOMPOK, HOST_ID

network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
  vlans:
    vlan{VLAN_ID}:
      id: {VLAN_ID}
      link: enp0s3
      addresses: [192.168.{KELOMPOK}.{HOST_ID}/24]
      routes: [{to: default, via: 192.168.{KELOMPOK}.1}]
      nameservers: {addresses: [10.252.108.10, 8.8.8.8]}
```

### Contoh: Kelas C, Kelompok 7, Host 15
```
VLAN_ID = 71 + (7-1) = 77
Network = 192.168.7.0/24
IP = 192.168.7.15/24
Gateway = 192.168.7.1
```

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: false
  vlans:
    vlan77:
      id: 77
      link: enp0s3
      addresses: [192.168.7.15/24]
      routes: [{to: default, via: 192.168.7.1}]
      nameservers: {addresses: [10.252.108.10, 8.8.8.8]}
```

---

## NETPLAN COMMANDS

```bash
sudo netplan generate          # Validasi syntax
sudo netplan try --timeout 120 # Test dengan rollback
sudo netplan apply             # Terapkan permanen

# Verifikasi
ip addr show
ip route show
ping -c 3 192.168.X.1          # Gateway kelompok
ping -c 3 10.252.108.1         # Gateway backbone
ping -c 3 8.8.8.8              # Internet
```

---

## URUTAN L2/L3 NETPLAN

```
1. ethernets   → Physical interface
2. bonds       → NIC aggregation (opsional)
3. bridges     → L2 switching (opsional)
4. vlans       → VLAN tagging
5. addresses   → IP configuration
```

---

## MIKROTIK RB3011 QUICK CONFIG

```routeros
# Identity
/system identity set name="RB3011-KELAS_X-KLP_Y"

# WAN Interface
/interface ethernet set ether1 name=ether1-wan

# Bridge LAN
/interface bridge add name=bridge-lan
/interface bridge port
add bridge=bridge-lan interface=ether2
add bridge=bridge-lan interface=ether3
add bridge=bridge-lan interface=ether4
add bridge=bridge-lan interface=ether5

# IP Address
/ip address 
add address=10.252.108.{50+KLP}/24 interface=ether1-wan
add address=192.168.{KLP}.1/24 interface=bridge-lan

# Gateway & DNS
/ip route add gateway=10.252.108.1
/ip dns set servers=10.252.108.10 allow-remote-requests=yes

# NAT
/ip firewall nat add chain=srcnat out-interface=ether1-wan action=masquerade

# DHCP
/ip pool add name=dhcp-lan ranges=192.168.{KLP}.100-192.168.{KLP}.200
/ip dhcp-server add name=dhcp-lan address-pool=dhcp-lan interface=bridge-lan
/ip dhcp-server network add address=192.168.{KLP}.0/24 gateway=192.168.{KLP}.1 dns-server=10.252.108.10
```

---

## TROUBLESHOOTING

| Masalah | Cek | Solusi |
|---------|-----|--------|
| No IP | `ip addr` | Verifikasi VLAN ID |
| No gateway | `ip route` | Cek routes netplan |
| No DNS | `/etc/resolv.conf` | Cek nameservers |
| No internet | `ping 8.8.8.8` | Cek NAT di RB3011 |
| Switch error | Web UI CSS326 | Cek PVID dan VLAN membership |

---

## PORT ASSIGNMENT CSS326

```
Port 1  → Uplink (Trunk ke RB1100)
Port 2  → Reserved
Port 3  → Kelompok 1
Port 4  → Kelompok 2
Port 5  → Kelompok 3
Port 6  → Kelompok 4
Port 7  → Kelompok 5
Port 8  → Kelompok 6
Port 9  → Kelompok 7
Port 10 → Kelompok 8
Port 11 → Kelompok 9
Port 12 → Kelompok 10
```

---

**Workshop Administrasi Jaringan 2026 - v2.2**
