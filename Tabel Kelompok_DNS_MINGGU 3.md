# Tabel Kelompok DNS Subdomain - MINGGU 3
## Workshop Administrasi Sistem & Jaringan - PENS

**Topik:** DNS Delegated Subdomain corp.pens.lab  
**Total:** 40 Kelompok (4 Kelas × 10 Kelompok)  
**Domain Parent:** corp.pens.lab (HO: 10.252.108.10)

---

## Mapping Lengkap 40 Subdomain

Gunakan tabel ini untuk identifikasi:
- **Subdomain** kelompok Anda
- **VM IP** untuk konfigurasi BIND9
- **NS Hostname** untuk zone file
- **Glue A Record** yang harus ada di HO (asisten pre-load sebelum lab)
- **www IP Example** untuk testing

| Kelas | Kelompok | Subdomain              | VM IP (LAN)    | NS Hostname                  | Glue A (HO Zone)     | www IP Example   |
|-------|----------|------------------------|----------------|------------------------------|----------------------|------------------|
| **A** | K01      | a01.corp.pens.lab     | 192.168.1.10  | ns1.a01.corp.pens.lab.      | 192.168.1.10        | 192.168.1.11    |
| A     | K02      | a02.corp.pens.lab     | 192.168.2.20  | ns1.a02.corp.pens.lab.      | 192.168.2.20        | 192.168.2.21    |
| A     | K03      | a03.corp.pens.lab     | 192.168.3.30  | ns1.a03.corp.pens.lab.      | 192.168.3.30        | 192.168.3.31    |
| A     | K04      | a04.corp.pens.lab     | 192.168.4.40  | ns1.a04.corp.pens.lab.      | 192.168.4.40        | 192.168.4.41    |
| A     | K05      | a05.corp.pens.lab     | 192.168.5.10  | ns1.a05.corp.pens.lab.      | 192.168.5.10        | 192.168.5.11    |
| A     | K06      | a06.corp.pens.lab     | 192.168.6.20  | ns1.a06.corp.pens.lab.      | 192.168.6.20        | 192.168.6.21    |
| A     | K07      | a07.corp.pens.lab     | 192.168.7.30  | ns1.a07.corp.pens.lab.      | 192.168.7.30        | 192.168.7.31    |
| A     | K08      | a08.corp.pens.lab     | 192.168.8.40  | ns1.a08.corp.pens.lab.      | 192.168.8.40        | 192.168.8.41    |
| A     | K09      | a09.corp.pens.lab     | 192.168.9.10  | ns1.a09.corp.pens.lab.      | 192.168.9.10        | 192.168.9.11    |
| A     | K10      | a10.corp.pens.lab     | 192.168.10.20 | ns1.a10.corp.pens.lab.      | 192.168.10.20       | 192.168.10.21   |
| **B** | K01      | b01.corp.pens.lab     | 192.168.1.20  | ns1.b01.corp.pens.lab.      | 192.168.1.20        | 192.168.1.21    |
| B     | K02      | b02.corp.pens.lab     | 192.168.2.30  | ns1.b02.corp.pens.lab.      | 192.168.2.30        | 192.168.2.31    |
| B     | K03      | b03.corp.pens.lab     | 192.168.3.40  | ns1.b03.corp.pens.lab.      | 192.168.3.40        | 192.168.3.41    |
| B     | K04      | b04.corp.pens.lab     | 192.168.4.10  | ns1.b04.corp.pens.lab.      | 192.168.4.10        | 192.168.4.11    |
| B     | K05      | b05.corp.pens.lab     | 192.168.5.20  | ns1.b05.corp.pens.lab.      | 192.168.5.20        | 192.168.5.21    |
| B     | K06      | b06.corp.pens.lab     | 192.168.6.30  | ns1.b06.corp.pens.lab.      | 192.168.6.30        | 192.168.6.31    |
| B     | K07      | b07.corp.pens.lab     | 192.168.7.40  | ns1.b07.corp.pens.lab.      | 192.168.7.40        | 192.168.7.41    |
| B     | K08      | b08.corp.pens.lab     | 192.168.8.10  | ns1.b08.corp.pens.lab.      | 192.168.8.10        | 192.168.8.11    |
| B     | K09      | b09.corp.pens.lab     | 192.168.9.20  | ns1.b09.corp.pens.lab.      | 192.168.9.20        | 192.168.9.21    |
| B     | K10      | b10.corp.pens.lab     | 192.168.10.30 | ns1.b10.corp.pens.lab.      | 192.168.10.30       | 192.168.10.31   |
| **C** | K01      | c01.corp.pens.lab     | 192.168.1.30  | ns1.c01.corp.pens.lab.      | 192.168.1.30        | 192.168.1.31    |
| C     | K02      | c02.corp.pens.lab     | 192.168.2.40  | ns1.c02.corp.pens.lab.      | 192.168.2.40        | 192.168.2.41    |
| C     | K03      | c03.corp.pens.lab     | 192.168.3.10  | ns1.c03.corp.pens.lab.      | 192.168.3.10        | 192.168.3.11    |
| C     | K04      | c04.corp.pens.lab     | 192.168.4.20  | ns1.c04.corp.pens.lab.      | 192.168.4.20        | 192.168.4.21    |
| C     | K05      | c05.corp.pens.lab     | 192.168.5.30  | ns1.c05.corp.pens.lab.      | 192.168.5.30        | 192.168.5.31    |
| C     | K06      | c06.corp.pens.lab     | 192.168.6.40  | ns1.c06.corp.pens.lab.      | 192.168.6.40        | 192.168.6.41    |
| C     | K07      | c07.corp.pens.lab     | 192.168.7.10  | ns1.c07.corp.pens.lab.      | 192.168.7.10        | 192.168.7.11    |
| C     | K08      | c08.corp.pens.lab     | 192.168.8.20  | ns1.c08.corp.pens.lab.      | 192.168.8.20        | 192.168.8.21    |
| C     | K09      | c09.corp.pens.lab     | 192.168.9.30  | ns1.c09.corp.pens.lab.      | 192.168.9.30        | 192.168.9.31    |
| C     | K10      | c10.corp.pens.lab     | 192.168.10.40 | ns1.c10.corp.pens.lab.      | 192.168.10.40       | 192.168.10.41   |
| **D** | K01      | d01.corp.pens.lab     | 192.168.1.40  | ns1.d01.corp.pens.lab.      | 192.168.1.40        | 192.168.1.41    |
| D     | K02      | d02.corp.pens.lab     | 192.168.2.10  | ns1.d02.corp.pens.lab.      | 192.168.2.10        | 192.168.2.11    |
| D     | K03      | d03.corp.pens.lab     | 192.168.3.20  | ns1.d03.corp.pens.lab.      | 192.168.3.20        | 192.168.3.21    |
| D     | K04      | d04.corp.pens.lab     | 192.168.4.30  | ns1.d04.corp.pens.lab.      | 192.168.4.30        | 192.168.4.31    |
| D     | K05      | d05.corp.pens.lab     | 192.168.5.40  | ns1.d05.corp.pens.lab.      | 192.168.5.40        | 192.168.5.41    |
| D     | K06      | d06.corp.pens.lab     | 192.168.6.10  | ns1.d06.corp.pens.lab.      | 192.168.6.10        | 192.168.6.11    |
| D     | K07      | d07.corp.pens.lab     | 192.168.7.20  | ns1.d07.corp.pens.lab.      | 192.168.7.20        | 192.168.7.21    |
| D     | K08      | d08.corp.pens.lab     | 192.168.8.30  | ns1.d08.corp.pens.lab.      | 192.168.8.30        | 192.168.8.31    |
| D     | K09      | d09.corp.pens.lab     | 192.168.9.40  | ns1.d09.corp.pens.lab.      | 192.168.9.40        | 192.168.9.41    |
| D     | K10      | d10.corp.pens.lab     | 192.168.10.10 | ns1.d10.corp.pens.lab.      | 192.168.10.10       | 192.168.10.11   |

---

## Skema IP Offset per Kelas

| Kelas | IP Offset | Range Kelompok       | Contoh VM IP      |
|-------|-----------|----------------------|-------------------|
| A     | .10       | K01-K10 (.10)        | 192.168.1.10      |
| B     | .20       | K01-K10 (.20)        | 192.168.1.20      |
| C     | .30       | K01-K10 (.30)        | 192.168.1.30      |
| D     | .40       | K01-K10 (.40)        | 192.168.1.40      |

**Pattern:** 192.168.[kelompok_number].[offset]
- Kelompok K01 → .1, K02 → .2, dst
- Kelas A: offset .10, B: .20, C: .30, D: .40

---

## Contoh Konfigurasi per Kelas

### Contoh Kelas A Kelompok 01 (a01.corp.pens.lab)

**VM IP:** 192.168.1.10  
**Subdomain:** a01.corp.pens.lab  
**NS Hostname:** ns1.a01.corp.pens.lab  
**Zone File:** /etc/bind/db.a01.corp.pens.lab

**named.conf.local:**
```
zone "a01.corp.pens.lab" {
    type master;
    file "/etc/bind/db.a01.corp.pens.lab";
    allow-transfer { none; };
};
```

**db.a01.corp.pens.lab (isi):**
```
$TTL    86400
@       IN      SOA     ns1.a01.corp.pens.lab. admin.a01.corp.pens.lab. (
                        2026022101 3600 1800 604800 86400 )
@       IN      NS      ns1.a01.corp.pens.lab.
ns1     IN      A       192.168.1.10
www     IN      A       192.168.1.11
ftp     IN      A       192.168.1.12
mail    IN      A       192.168.1.13
@       IN      MX 10   mail.a01.corp.pens.lab.
*       IN      A       192.168.1.10
```

**Di HO (10.252.108.10) /etc/bind/db.corp.pens.lab tambah:**
```
; Delegation Kelas A Kelompok 01
a01             IN      NS      ns1.a01.corp.pens.lab.
ns1.a01         IN      A       192.168.1.10
```

---

### Contoh Kelas B Kelompok 05 (b05.corp.pens.lab)

**VM IP:** 192.168.5.20  
**Subdomain:** b05.corp.pens.lab  
**NS Hostname:** ns1.b05.corp.pens.lab  
**Zone File:** /etc/bind/db.b05.corp.pens.lab

**named.conf.local:**
```
zone "b05.corp.pens.lab" {
    type master;
    file "/etc/bind/db.b05.corp.pens.lab";
    allow-transfer { none; };
};
```

**db.b05.corp.pens.lab (isi):**
```
$TTL    86400
@       IN      SOA     ns1.b05.corp.pens.lab. admin.b05.corp.pens.lab. (
                        2026022101 3600 1800 604800 86400 )
@       IN      NS      ns1.b05.corp.pens.lab.
ns1     IN      A       192.168.5.20
www     IN      A       192.168.5.21
ftp     IN      A       192.168.5.22
mail    IN      A       192.168.5.23
@       IN      MX 10   mail.b05.corp.pens.lab.
*       IN      A       192.168.5.20
```

**Di HO (10.252.108.10) /etc/bind/db.corp.pens.lab tambah:**
```
; Delegation Kelas B Kelompok 05
b05             IN      NS      ns1.b05.corp.pens.lab.
ns1.b05         IN      A       192.168.5.20
```

---

### Contoh Kelas C Kelompok 08 (c08.corp.pens.lab)

**VM IP:** 192.168.8.20  
**Subdomain:** c08.corp.pens.lab  
**NS Hostname:** ns1.c08.corp.pens.lab  
**Zone File:** /etc/bind/db.c08.corp.pens.lab

**named.conf.local:**
```
zone "c08.corp.pens.lab" {
    type master;
    file "/etc/bind/db.c08.corp.pens.lab";
    allow-transfer { none; };
};
```

**db.c08.corp.pens.lab (isi):**
```
$TTL    86400
@       IN      SOA     ns1.c08.corp.pens.lab. admin.c08.corp.pens.lab. (
                        2026022101 3600 1800 604800 86400 )
@       IN      NS      ns1.c08.corp.pens.lab.
ns1     IN      A       192.168.8.20
www     IN      A       192.168.8.21
ftp     IN      A       192.168.8.22
mail    IN      A       192.168.8.23
@       IN      MX 10   mail.c08.corp.pens.lab.
*       IN      A       192.168.8.20
```

**Di HO (10.252.108.10) /etc/bind/db.corp.pens.lab tambah:**
```
; Delegation Kelas C Kelompok 08
c08             IN      NS      ns1.c08.corp.pens.lab.
ns1.c08         IN      A       192.168.8.20
```

---

### Contoh Kelas D Kelompok 10 (d10.corp.pens.lab)

**VM IP:** 192.168.10.10  
**Subdomain:** d10.corp.pens.lab  
**NS Hostname:** ns1.d10.corp.pens.lab  
**Zone File:** /etc/bind/db.d10.corp.pens.lab

**named.conf.local:**
```
zone "d10.corp.pens.lab" {
    type master;
    file "/etc/bind/db.d10.corp.pens.lab";
    allow-transfer { none; };
};
```

**db.d10.corp.pens.lab (isi):**
```
$TTL    86400
@       IN      SOA     ns1.d10.corp.pens.lab. admin.d10.corp.pens.lab. (
                        2026022101 3600 1800 604800 86400 )
@       IN      NS      ns1.d10.corp.pens.lab.
ns1     IN      A       192.168.10.10
www     IN      A       192.168.10.11
ftp     IN      A       192.168.10.12
mail    IN      A       192.168.10.13
@       IN      MX 10   mail.d10.corp.pens.lab.
*       IN      A       192.168.10.10
```

**Di HO (10.252.108.10) /etc/bind/db.corp.pens.lab tambah:**
```
; Delegation Kelas D Kelompok 10
d10             IN      NS      ns1.d10.corp.pens.lab.
ns1.d10         IN      A       192.168.10.10
```

---

## Catatan untuk Asisten Lab

**Pre-Lab Setup (HO DNS 10.252.108.10):**

1. Edit /etc/bind/db.corp.pens.lab
2. Tambahkan 40 delegation entries (NS + glue A) untuk semua subdomain di tabel
3. Increment serial number SOA
4. `sudo named-checkzone corp.pens.lab /etc/bind/db.corp.pens.lab`
5. `sudo rndc reload corp.pens.lab`
6. Test delegation: `dig @10.252.108.10 a01.corp.pens.lab NS` (harus reply ns1.a01 + glue A)

**Format delegation di db.corp.pens.lab:**
```
; === KELAS A DELEGATIONS ===
a01             IN      NS      ns1.a01.corp.pens.lab.
ns1.a01         IN      A       192.168.1.10
a02             IN      NS      ns1.a02.corp.pens.lab.
ns1.a02         IN      A       192.168.2.20
; ... (total 10 entries Kelas A)

; === KELAS B DELEGATIONS ===
b01             IN      NS      ns1.b01.corp.pens.lab.
ns1.b01         IN      A       192.168.1.20
; ... (total 10 entries Kelas B)

; === KELAS C DELEGATIONS ===
; ... (total 10 entries Kelas C)

; === KELAS D DELEGATIONS ===
; ... (total 10 entries Kelas D)
```

**Verifikasi semua 40 subdomain:**
```bash
for subdomain in a{01..10} b{01..10} c{01..10} d{01..10}; do
    echo "Testing $subdomain.corp.pens.lab"
    dig @10.252.108.10 $subdomain.corp.pens.lab NS +short
done
```


