# Tabel Kelompok DHCP & NTP - MINGGU 4
## Workshop Administrasi Sistem & Jaringan - PENS

**Topik:** DHCP Reservations & NTP Sync Mapping  
**DHCP Server:** 10.252.108.20 (ISC DHCP + Chrony Master)  
**DNS Server:** 10.252.108.10 (BIND9 corp.pens.lab - DDNS target)

---

## Mapping Lengkap 40 DHCP Reservations

Gunakan tabel ini untuk konfigurasi dhcpd.conf:
- **VM Hostname** untuk DHCP host declaration
- **MAC Address** (placeholder - WAJIB ganti dengan MAC real VM)
- **Fixed IP** (reservation backbone 10.252.108.151-190)
- **FQDN** untuk DDNS update ke BIND9
- **Relay Gateway** RB3011 yang serve kelompok

| Kelas | Kelompok | VM Hostname   | MAC Address (GANTI!)  | Fixed IP         | FQDN (DDNS)                 | Relay Gateway    |
|-------|----------|---------------|-----------------------|------------------|-----------------------------|------------------|
| **A** | K01      | srv-ho-a01   | 08:00:27:a0:01:01    | 10.252.108.151  | srv-ho-a01.corp.pens.lab   | 10.252.108.51    |
| A     | K02      | srv-ho-a02   | 08:00:27:a0:02:02    | 10.252.108.152  | srv-ho-a02.corp.pens.lab   | 10.252.108.52    |
| A     | K03      | srv-ho-a03   | 08:00:27:a0:03:03    | 10.252.108.153  | srv-ho-a03.corp.pens.lab   | 10.252.108.53    |
| A     | K04      | srv-ho-a04   | 08:00:27:a0:04:04    | 10.252.108.154  | srv-ho-a04.corp.pens.lab   | 10.252.108.54    |
| A     | K05      | srv-ho-a05   | 08:00:27:a0:05:05    | 10.252.108.155  | srv-ho-a05.corp.pens.lab   | 10.252.108.55    |
| A     | K06      | srv-ho-a06   | 08:00:27:a0:06:06    | 10.252.108.156  | srv-ho-a06.corp.pens.lab   | 10.252.108.56    |
| A     | K07      | srv-ho-a07   | 08:00:27:a0:07:07    | 10.252.108.157  | srv-ho-a07.corp.pens.lab   | 10.252.108.57    |
| A     | K08      | srv-ho-a08   | 08:00:27:a0:08:08    | 10.252.108.158  | srv-ho-a08.corp.pens.lab   | 10.252.108.58    |
| A     | K09      | srv-ho-a09   | 08:00:27:a0:09:09    | 10.252.108.159  | srv-ho-a09.corp.pens.lab   | 10.252.108.59    |
| A     | K10      | srv-ho-a10   | 08:00:27:a0:10:0a    | 10.252.108.160  | srv-ho-a10.corp.pens.lab   | 10.252.108.60    |
| **B** | K01      | srv-ho-b01   | 08:00:27:b0:01:01    | 10.252.108.161  | srv-ho-b01.corp.pens.lab   | 10.252.108.51    |
| B     | K02      | srv-ho-b02   | 08:00:27:b0:02:02    | 10.252.108.162  | srv-ho-b02.corp.pens.lab   | 10.252.108.52    |
| B     | K03      | srv-ho-b03   | 08:00:27:b0:03:03    | 10.252.108.163  | srv-ho-b03.corp.pens.lab   | 10.252.108.53    |
| B     | K04      | srv-ho-b04   | 08:00:27:b0:04:04    | 10.252.108.164  | srv-ho-b04.corp.pens.lab   | 10.252.108.54    |
| B     | K05      | srv-ho-b05   | 08:00:27:b0:05:05    | 10.252.108.165  | srv-ho-b05.corp.pens.lab   | 10.252.108.55    |
| B     | K06      | srv-ho-b06   | 08:00:27:b0:06:06    | 10.252.108.166  | srv-ho-b06.corp.pens.lab   | 10.252.108.56    |
| B     | K07      | srv-ho-b07   | 08:00:27:b0:07:07    | 10.252.108.167  | srv-ho-b07.corp.pens.lab   | 10.252.108.57    |
| B     | K08      | srv-ho-b08   | 08:00:27:b0:08:08    | 10.252.108.168  | srv-ho-b08.corp.pens.lab   | 10.252.108.58    |
| B     | K09      | srv-ho-b09   | 08:00:27:b0:09:09    | 10.252.108.169  | srv-ho-b09.corp.pens.lab   | 10.252.108.59    |
| B     | K10      | srv-ho-b10   | 08:00:27:b0:10:0a    | 10.252.108.170  | srv-ho-b10.corp.pens.lab   | 10.252.108.60    |
| **C** | K01      | srv-ho-c01   | 08:00:27:c0:01:01    | 10.252.108.171  | srv-ho-c01.corp.pens.lab   | 10.252.108.51    |
| C     | K02      | srv-ho-c02   | 08:00:27:c0:02:02    | 10.252.108.172  | srv-ho-c02.corp.pens.lab   | 10.252.108.52    |
| C     | K03      | srv-ho-c03   | 08:00:27:c0:03:03    | 10.252.108.173  | srv-ho-c03.corp.pens.lab   | 10.252.108.53    |
| C     | K04      | srv-ho-c04   | 08:00:27:c0:04:04    | 10.252.108.174  | srv-ho-c04.corp.pens.lab   | 10.252.108.54    |
| C     | K05      | srv-ho-c05   | 08:00:27:c0:05:05    | 10.252.108.175  | srv-ho-c05.corp.pens.lab   | 10.252.108.55    |
| C     | K06      | srv-ho-c06   | 08:00:27:c0:06:06    | 10.252.108.176  | srv-ho-c06.corp.pens.lab   | 10.252.108.56    |
| C     | K07      | srv-ho-c07   | 08:00:27:c0:07:07    | 10.252.108.177  | srv-ho-c07.corp.pens.lab   | 10.252.108.57    |
| C     | K08      | srv-ho-c08   | 08:00:27:c0:08:08    | 10.252.108.178  | srv-ho-c08.corp.pens.lab   | 10.252.108.58    |
| C     | K09      | srv-ho-c09   | 08:00:27:c0:09:09    | 10.252.108.179  | srv-ho-c09.corp.pens.lab   | 10.252.108.59    |
| C     | K10      | srv-ho-c10   | 08:00:27:c0:10:0a    | 10.252.108.180  | srv-ho-c10.corp.pens.lab   | 10.252.108.60    |
| **D** | K01      | srv-ho-d01   | 08:00:27:d0:01:01    | 10.252.108.181  | srv-ho-d01.corp.pens.lab   | 10.252.108.51    |
| D     | K02      | srv-ho-d02   | 08:00:27:d0:02:02    | 10.252.108.182  | srv-ho-d02.corp.pens.lab   | 10.252.108.52    |
| D     | K03      | srv-ho-d03   | 08:00:27:d0:03:03    | 10.252.108.183  | srv-ho-d03.corp.pens.lab   | 10.252.108.53    |
| D     | K04      | srv-ho-d04   | 08:00:27:d0:04:04    | 10.252.108.184  | srv-ho-d04.corp.pens.lab   | 10.252.108.54    |
| D     | K05      | srv-ho-d05   | 08:00:27:d0:05:05    | 10.252.108.185  | srv-ho-d05.corp.pens.lab   | 10.252.108.55    |
| D     | K06      | srv-ho-d06   | 08:00:27:d0:06:06    | 10.252.108.186  | srv-ho-d06.corp.pens.lab   | 10.252.108.56    |
| D     | K07      | srv-ho-d07   | 08:00:27:d0:07:07    | 10.252.108.187  | srv-ho-d07.corp.pens.lab   | 10.252.108.57    |
| D     | K08      | srv-ho-d08   | 08:00:27:d0:08:08    | 10.252.108.188  | srv-ho-d08.corp.pens.lab   | 10.252.108.58    |
| D     | K09      | srv-ho-d09   | 08:00:27:d0:09:09    | 10.252.108.189  | srv-ho-d09.corp.pens.lab   | 10.252.108.59    |
| D     | K10      | srv-ho-d10   | 08:00:27:d0:10:0a    | 10.252.108.190  | srv-ho-d10.corp.pens.lab   | 10.252.108.60    |

---

## Cara Mendapatkan MAC Address Real VM

**Dari VM Ubuntu:**
```bash
# Method 1: ip link
ip link show | grep ether

# Method 2: ifconfig
ifconfig | grep ether

# Method 3: cat /sys/class/net
cat /sys/class/net/enp1s0/address

# Output example: 08:00:27:a0:01:01
```

**Dari Proxmox Web UI:**
1. Login Proxmox → VM → Hardware
2. Lihat kolom **Network Device** → MAC Address
3. Contoh: `virtio=XX:XX:XX:XX:XX:XX`

**Catatan:** MAC placeholder di tabel (08:00:27:...) adalah format VirtualBox default. Ganti dengan MAC real sebelum input ke dhcpd.conf!

---

## Skema IP Allocation

| Kategori         | Range IP              | Jumlah | Fungsi                          |
|------------------|-----------------------|--------|---------------------------------|
| Gateway          | 10.252.108.1         | 1      | RB1100 HQ Gateway               |
| Infrastructure   | 10.252.108.2-19      | 18     | CSS326, monitoring, tools       |
| DHCP/NTP Server  | 10.252.108.20        | 1      | ISC DHCP + Chrony Master        |
| Static servers   | 10.252.108.21-99     | 79     | DNS, web, mail, database future |
| **Dynamic Pool** | **10.252.108.100-150** | **51** | **DHCP pool untuk device umum** |
| **Reservations Kelas A** | **10.252.108.151-160** | **10** | **srv-ho-a01 sampai a10**       |
| **Reservations Kelas B** | **10.252.108.161-170** | **10** | **srv-ho-b01 sampai b10**       |
| **Reservations Kelas C** | **10.252.108.171-180** | **10** | **srv-ho-c01 sampai c10**       |
| **Reservations Kelas D** | **10.252.108.181-190** | **10** | **srv-ho-d01 sampai d10**       |
| Future expansion | 10.252.108.191-254   | 64     | Reserved untuk growth           |

**Total backbone capacity:** 254 usable IPs (10.252.108.1-254)  
**Allocated:** 40 reservations + 51 pool + 80 static = 171 IPs  
**Available:** 83 IPs untuk ekspansi

---

## Template dhcpd.conf (Host Declarations)

Copy-paste section ini ke `/etc/dhcp/dhcpd.conf` setelah subnet declaration.  
**WAJIB ganti MAC address dengan real MAC VM Anda!**

```
# ===== Host Reservations: 40 VM srv-ho-kXX =====

# === KELAS A (K01-K10: IP .151-.160) ===
host srv-ho-a01 {
    hardware ethernet 08:00:27:a0:01:01;  # GANTI MAC REAL
    fixed-address 10.252.108.151;
    option host-name "srv-ho-a01.corp.pens.lab";
}

host srv-ho-a02 {
    hardware ethernet 08:00:27:a0:02:02;
    fixed-address 10.252.108.152;
    option host-name "srv-ho-a02.corp.pens.lab";
}

host srv-ho-a03 {
    hardware ethernet 08:00:27:a0:03:03;
    fixed-address 10.252.108.153;
    option host-name "srv-ho-a03.corp.pens.lab";
}

host srv-ho-a04 {
    hardware ethernet 08:00:27:a0:04:04;
    fixed-address 10.252.108.154;
    option host-name "srv-ho-a04.corp.pens.lab";
}

host srv-ho-a05 {
    hardware ethernet 08:00:27:a0:05:05;
    fixed-address 10.252.108.155;
    option host-name "srv-ho-a05.corp.pens.lab";
}

host srv-ho-a06 {
    hardware ethernet 08:00:27:a0:06:06;
    fixed-address 10.252.108.156;
    option host-name "srv-ho-a06.corp.pens.lab";
}

host srv-ho-a07 {
    hardware ethernet 08:00:27:a0:07:07;
    fixed-address 10.252.108.157;
    option host-name "srv-ho-a07.corp.pens.lab";
}

host srv-ho-a08 {
    hardware ethernet 08:00:27:a0:08:08;
    fixed-address 10.252.108.158;
    option host-name "srv-ho-a08.corp.pens.lab";
}

host srv-ho-a09 {
    hardware ethernet 08:00:27:a0:09:09;
    fixed-address 10.252.108.159;
    option host-name "srv-ho-a09.corp.pens.lab";
}

host srv-ho-a10 {
    hardware ethernet 08:00:27:a0:10:0a;
    fixed-address 10.252.108.160;
    option host-name "srv-ho-a10.corp.pens.lab";
}

# === KELAS B (K01-K10: IP .161-.170) ===
host srv-ho-b01 {
    hardware ethernet 08:00:27:b0:01:01;
    fixed-address 10.252.108.161;
    option host-name "srv-ho-b01.corp.pens.lab";
}

host srv-ho-b02 {
    hardware ethernet 08:00:27:b0:02:02;
    fixed-address 10.252.108.162;
    option host-name "srv-ho-b02.corp.pens.lab";
}

host srv-ho-b03 {
    hardware ethernet 08:00:27:b0:03:03;
    fixed-address 10.252.108.163;
    option host-name "srv-ho-b03.corp.pens.lab";
}

host srv-ho-b04 {
    hardware ethernet 08:00:27:b0:04:04;
    fixed-address 10.252.108.164;
    option host-name "srv-ho-b04.corp.pens.lab";
}

host srv-ho-b05 {
    hardware ethernet 08:00:27:b0:05:05;
    fixed-address 10.252.108.165;
    option host-name "srv-ho-b05.corp.pens.lab";
}

host srv-ho-b06 {
    hardware ethernet 08:00:27:b0:06:06;
    fixed-address 10.252.108.166;
    option host-name "srv-ho-b06.corp.pens.lab";
}

host srv-ho-b07 {
    hardware ethernet 08:00:27:b0:07:07;
    fixed-address 10.252.108.167;
    option host-name "srv-ho-b07.corp.pens.lab";
}

host srv-ho-b08 {
    hardware ethernet 08:00:27:b0:08:08;
    fixed-address 10.252.108.168;
    option host-name "srv-ho-b08.corp.pens.lab";
}

host srv-ho-b09 {
    hardware ethernet 08:00:27:b0:09:09;
    fixed-address 10.252.108.169;
    option host-name "srv-ho-b09.corp.pens.lab";
}

host srv-ho-b10 {
    hardware ethernet 08:00:27:b0:10:0a;
    fixed-address 10.252.108.170;
    option host-name "srv-ho-b10.corp.pens.lab";
}

# === KELAS C (K01-K10: IP .171-.180) ===
host srv-ho-c01 {
    hardware ethernet 08:00:27:c0:01:01;
    fixed-address 10.252.108.171;
    option host-name "srv-ho-c01.corp.pens.lab";
}

host srv-ho-c02 {
    hardware ethernet 08:00:27:c0:02:02;
    fixed-address 10.252.108.172;
    option host-name "srv-ho-c02.corp.pens.lab";
}

host srv-ho-c03 {
    hardware ethernet 08:00:27:c0:03:03;
    fixed-address 10.252.108.173;
    option host-name "srv-ho-c03.corp.pens.lab";
}

host srv-ho-c04 {
    hardware ethernet 08:00:27:c0:04:04;
    fixed-address 10.252.108.174;
    option host-name "srv-ho-c04.corp.pens.lab";
}

host srv-ho-c05 {
    hardware ethernet 08:00:27:c0:05:05;
    fixed-address 10.252.108.175;
    option host-name "srv-ho-c05.corp.pens.lab";
}

host srv-ho-c06 {
    hardware ethernet 08:00:27:c0:06:06;
    fixed-address 10.252.108.176;
    option host-name "srv-ho-c06.corp.pens.lab";
}

host srv-ho-c07 {
    hardware ethernet 08:00:27:c0:07:07;
    fixed-address 10.252.108.177;
    option host-name "srv-ho-c07.corp.pens.lab";
}

host srv-ho-c08 {
    hardware ethernet 08:00:27:c0:08:08;
    fixed-address 10.252.108.178;
    option host-name "srv-ho-c08.corp.pens.lab";
}

host srv-ho-c09 {
    hardware ethernet 08:00:27:c0:09:09;
    fixed-address 10.252.108.179;
    option host-name "srv-ho-c09.corp.pens.lab";
}

host srv-ho-c10 {
    hardware ethernet 08:00:27:c0:10:0a;
    fixed-address 10.252.108.180;
    option host-name "srv-ho-c10.corp.pens.lab";
}

# === KELAS D (K01-K10: IP .181-.190) ===
host srv-ho-d01 {
    hardware ethernet 08:00:27:d0:01:01;
    fixed-address 10.252.108.181;
    option host-name "srv-ho-d01.corp.pens.lab";
}

host srv-ho-d02 {
    hardware ethernet 08:00:27:d0:02:02;
    fixed-address 10.252.108.182;
    option host-name "srv-ho-d02.corp.pens.lab";
}

host srv-ho-d03 {
    hardware ethernet 08:00:27:d0:03:03;
    fixed-address 10.252.108.183;
    option host-name "srv-ho-d03.corp.pens.lab";
}

host srv-ho-d04 {
    hardware ethernet 08:00:27:d0:04:04;
    fixed-address 10.252.108.184;
    option host-name "srv-ho-d04.corp.pens.lab";
}

host srv-ho-d05 {
    hardware ethernet 08:00:27:d0:05:05;
    fixed-address 10.252.108.185;
    option host-name "srv-ho-d05.corp.pens.lab";
}

host srv-ho-d06 {
    hardware ethernet 08:00:27:d0:06:06;
    fixed-address 10.252.108.186;
    option host-name "srv-ho-d06.corp.pens.lab";
}

host srv-ho-d07 {
    hardware ethernet 08:00:27:d0:07:07;
    fixed-address 10.252.108.187;
    option host-name "srv-ho-d07.corp.pens.lab";
}

host srv-ho-d08 {
    hardware ethernet 08:00:27:d0:08:08;
    fixed-address 10.252.108.188;
    option host-name "srv-ho-d08.corp.pens.lab";
}

host srv-ho-d09 {
    hardware ethernet 08:00:27:d0:09:09;
    fixed-address 10.252.108.189;
    option host-name "srv-ho-d09.corp.pens.lab";
}

host srv-ho-d10 {
    hardware ethernet 08:00:27:d0:10:0a;
    fixed-address 10.252.108.190;
    option host-name "srv-ho-d10.corp.pens.lab";
}

# END of Host Reservations
```

**Setelah edit MAC real, test syntax:**
```bash
sudo dhcpd -t -cf /etc/dhcp/dhcpd.conf
```

---

## Catatan untuk Asisten Lab

**Pre-Lab Setup (DHCP/NTP Server 10.252.108.20):**

1. **Generate rndc-key:**
   ```bash
   sudo dnssec-keygen -a HMAC-MD5 -b 128 -n USER rndc-key
   cat Krndc-key.*.private | grep Key:
   # Catat secret untuk sync ke BIND9 HO
   ```

2. **Edit dhcpd.conf di HO:**
   - Tambahkan 40 host declarations dari template di atas
   - Update semua MAC address dengan real MAC VM (koordinasi dengan mahasiswa via shared sheet)
   - Verify syntax: `dhcpd -t`

3. **Sync rndc-key ke BIND9 HO (10.252.108.10):**
   ```bash
   # Di DNS HO, edit /etc/bind/named.conf.local
   key rndc-key {
       algorithm hmac-md5;
       secret "SAME_SECRET_FROM_DHCP_SERVER";
   };

   zone "corp.pens.lab" {
       type master;
       file "/etc/bind/db.corp.pens.lab";
       allow-update { key rndc-key; };  # Allow DDNS
   };

   zone "108.252.10.in-addr.arpa" {
       type master;
       file "/etc/bind/db.10.252.108";
       allow-update { key rndc-key; };
   };
   ```

4. **Set file permissions (BIND9 HO):**
   ```bash
   sudo chown bind:bind /etc/bind/db.corp.pens.lab
   sudo chown bind:bind /etc/bind/db.10.252.108
   sudo chmod 644 /etc/bind/db.*
   sudo rndc reload
   ```

5. **Konfigurasi DHCP relay di 10 RB3011 (K01-K10):**
   - Script batch via Ansible/Terraform (recommended)
   - Manual via Winbox: /ip dhcp-relay add interface=bridge-LAN server=10.252.108.20

6. **Test DDNS integration:**
   ```bash
   # Dari DHCP server, force update test
   sudo tail -f /var/log/syslog | grep dhcpd
   
   # Dari client, request lease
   sudo dhclient -v enp1s0
   
   # Verify DNS update
   dig srv-ho-a01.corp.pens.lab @10.252.108.10
   # Expected: A record 10.252.108.151
   ```

---

## Script Helper: Collect MAC Addresses (Asisten)

Gunakan script ini untuk collect MAC address dari 40 VM via SSH:

```bash
#!/bin/bash
# collect-mac.sh - Collect MAC addresses dari 40 VM

VMLIST=(
  "srv-ho-a01:192.168.1.10" "srv-ho-a02:192.168.2.20" # ... dst 40 VM
)

echo "Kelas,Kelompok,VM,MAC,FixedIP" > mac-addresses.csv

for entry in "${VMLIST[@]}"; do
  VM=$(echo $entry | cut -d: -f1)
  IP=$(echo $entry | cut -d: -f2)
  
  echo "Collecting MAC from $VM ($IP)..."
  MAC=$(ssh user@$IP "ip link show | grep ether | head -n1 | awk '{print \$2}'")
  
  KELAS=$(echo $VM | grep -oP 'srv-ho-\K[abcd]')
  KELOMPOK=$(echo $VM | grep -oP 'srv-ho-[abcd]\K[0-9]+')
  
  echo "$KELAS,$KELOMPOK,$VM,$MAC,$IP" >> mac-addresses.csv
done

echo "Done! Check mac-addresses.csv"
```

**Output CSV dapat import ke spreadsheet atau auto-generate dhcpd.conf.**

---

**End of TABEL_KELOMPOK_DHCP.md**  
Siap distribusi ke 40 kelompok, 4 kelas paralel!  
Print tabel ini sebagai lampiran MINGGU_4_DHCP_NTP.md
