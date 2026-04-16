# MINGGU 8: Web Server & Virtual Hosting

**Topik:** Apache2 & Nginx Web Server dengan Name-based dan IP-based Virtual Hosting  
**Durasi:** 120 menit  
**Prasyarat:** MINGGU_7 selesai (Centralized Logging aktif), DNS corp.pens.lab terkonfigurasi (MINGGU_3)

---

## 1. TUJUAN PEMBELAJARAN

Setelah praktikum ini, mahasiswa mampu:

1. Menginstal dan mengkonfigurasi Apache2 sebagai web server production-grade di Ubuntu 22.04
2. Menginstal dan mengkonfigurasi Nginx sebagai web server alternatif di VM berbeda
3. Membuat dan mengelola Name-based Virtual Hosting untuk multiple domain di satu IP
4. Membuat IP-based Virtual Hosting untuk domain yang terisolasi per IP
5. Mengkonfigurasi SSL/TLS dengan self-signed certificate pada virtual host HTTPS
6. Mengatur permission file, directory listing, dan access control per virtual host
7. Memahami struktur direktori `sites-available` / `sites-enabled` dan mekanisme symlink
8. Melakukan analisis access log dan error log per virtual host

---

## 2. DASAR TEORI

### 2.1 Web Server Overview

**Web Server** adalah software yang menerima request HTTP/HTTPS dari client (browser) dan mengembalikan response berupa halaman web, file, atau data API.

**Web Server Populer:**

| Software | Pangsa Pasar | Karakteristik |
|---|---|---|
| Apache2 (httpd) | ~31% | Modular, `.htaccess`, kompatibel luas |
| Nginx | ~34% | Event-driven, performa tinggi, low memory |
| Caddy | ~1% | Auto-HTTPS, config simple |
| LiteSpeed | ~13% | Kompatibel Apache, performa tinggi |

**Lab PENS:** Praktikum menggunakan **Apache2** (VM A) dan **Nginx** (VM B) secara berdampingan untuk perbandingan konfigurasi.

### 2.2 Cara Kerja Web Server

```
Client Browser                Web Server                  Filesystem
──────────────                ──────────                  ──────────
GET / HTTP/1.1       →        Listen :80                  /var/www/
Host: blog.pens.lab           Match VirtualHost            └─ blog/
                              blog.pens.lab                   └─ index.html
                    ←         HTTP/1.1 200 OK
                              Content-Type: text/html
                              <html>...</html>
```

**Request Processing Apache2:**
1. Terima TCP connection di port 80/443
2. Parse HTTP request headers (method, URI, Host)
3. Match `VirtualHost` berdasarkan Host header
4. Resolve DocumentRoot → filesystem path
5. Apply `.htaccess` rules (jika AllowOverride enabled)
6. Read file, generate response headers, send ke client
7. Write access log

**Request Processing Nginx:**
1. Terima event (non-blocking, epoll)
2. Parse HTTP request
3. Match `server` block berdasarkan `server_name`
4. Resolve `root` → filesystem path
5. Apply `location` rules
6. Send response, write log

### 2.3 Virtual Hosting

**Virtual Hosting** memungkinkan satu server melayani multiple website/domain dari satu instalasi web server.

**Tipe Virtual Hosting:**

#### A. Name-based Virtual Hosting (Paling Umum)
Satu IP address → multiple domain, dibedakan oleh **HTTP Host header**.

```
IP: 10.252.108.150
  ├─ Host: blog.corp.pens.lab    → /var/www/blog
  ├─ Host: portal.corp.pens.lab  → /var/www/portal
  └─ Host: api.corp.pens.lab     → /var/www/api
```

**Keunggulan:** Hemat IP address, mudah ditambah domain baru.  
**Kelemahan:** Bergantung pada SNI untuk HTTPS (legacy HTTP/1.0 tidak support).

#### B. IP-based Virtual Hosting
Setiap domain punya IP address sendiri (multiple NIC atau IP alias).

```
10.252.108.150 → blog.corp.pens.lab     → /var/www/blog
10.252.108.151 → portal.corp.pens.lab   → /var/www/portal
10.252.108.152 → api.corp.pens.lab      → /var/www/api
```

**Keunggulan:** Isolasi total, cocok untuk pre-SNI SSL.  
**Kelemahan:** Butuh banyak IP address (IPv4 scarcity).

#### C. Port-based Virtual Hosting
Satu IP, multiple port.

```
10.252.108.150:80  → main site
10.252.108.150:8080 → staging site
10.252.108.150:8443 → dev HTTPS
```

### 2.4 Struktur Direktori Apache2

```
/etc/apache2/
├─ apache2.conf          # Konfigurasi global utama
├─ ports.conf            # Port yang di-listen (Listen 80, Listen 443)
├─ conf-available/       # Konfigurasi tambahan (tersedia)
├─ conf-enabled/         # Symlink ke conf-available yang aktif
├─ mods-available/       # Modul Apache (tersedia)
├─ mods-enabled/         # Symlink ke modul yang aktif
├─ sites-available/      # Virtual host configs (tersedia)
│   ├─ 000-default.conf  # Default virtual host (HTTP)
│   └─ default-ssl.conf  # Default virtual host (HTTPS)
└─ sites-enabled/        # Symlink ke site yang aktif
    └─ 000-default.conf → ../sites-available/000-default.conf

/var/www/
├─ html/                 # DocumentRoot default
└─ (custom sites...)

/var/log/apache2/
├─ access.log            # Global access log
└─ error.log             # Global error log
```

**Apache2 Management Commands:**

```bash
a2ensite blog.conf      # Enable site (buat symlink)
a2dissite blog.conf     # Disable site (hapus symlink)
a2enmod rewrite         # Enable module
a2dismod rewrite        # Disable module
apachectl configtest    # Test syntax config
systemctl reload apache2 # Reload tanpa downtime
```

### 2.5 Struktur Direktori Nginx

```
/etc/nginx/
├─ nginx.conf            # Konfigurasi global utama
├─ conf.d/               # Include *.conf (alternatif sites-*)
├─ sites-available/      # Virtual host configs (tersedia)
│   └─ default           # Default server block
└─ sites-enabled/        # Symlink ke site yang aktif
    └─ default → ../sites-available/default

/var/www/
├─ html/                 # Root Nginx default
└─ (custom sites...)

/var/log/nginx/
├─ access.log            # Global access log
└─ error.log             # Global error log
```

**Nginx Management Commands:**

```bash
nginx -t                 # Test syntax config
systemctl reload nginx   # Reload tanpa downtime
ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/blog
```

### 2.6 Direktif Penting Apache2 Virtual Host

```apache
<VirtualHost *:80>
    ServerName blog.corp.pens.lab          # Domain utama
    ServerAlias www.blog.corp.pens.lab     # Alias domain
    DocumentRoot /var/www/blog             # Root filesystem
    
    # Directory permissions
    <Directory /var/www/blog>
        Options Indexes FollowSymLinks     # Indexes: tampilkan listing jika no index
        AllowOverride All                  # Izinkan .htaccess override
        Require all granted               # Allow semua akses
    </Directory>
    
    # Per-virtualhost logging
    ErrorLog ${APACHE_LOG_DIR}/blog_error.log
    CustomLog ${APACHE_LOG_DIR}/blog_access.log combined
</VirtualHost>
```

### 2.7 Direktif Penting Nginx Server Block

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name blog.corp.pens.lab www.blog.corp.pens.lab;
    root /var/www/blog;
    index index.html index.php;

    # Location block
    location / {
        try_files $uri $uri/ =404;    # Cari file, directory, atau 404
    }

    # Directory listing (aktifkan jika perlu)
    # autoindex on;

    # Per-virtualhost logging
    access_log /var/log/nginx/blog_access.log;
    error_log /var/log/nginx/blog_error.log;
}
```

---

## 3. TOPOLOGI LAB

```
flowchart TB
  C["Client Browser<br/>10.252.108.x"] --> SW["CSS326 Switch<br/>10.252.108.4"]
  DNS["BIND9 DNS HO<br/>10.252.108.10<br/>corp.pens.lab"] --> SW
  
  SW --> A["VM Apache2<br/>10.252.108.150<br/>Port 80 / 443<br/>Name-based VHost"]
  SW --> B["VM Nginx<br/>10.252.108.151<br/>Port 80 / 443<br/>Name-based VHost"]
  
  subgraph Apache["Apache2 Virtual Hosts (10.252.108.150)"]
    direction LR
    A1["blog.corp.pens.lab<br/>/var/www/blog"]
    A2["portal.corp.pens.lab<br/>/var/www/portal"]
    A3["docs.corp.pens.lab<br/>/var/www/docs"]
  end

  subgraph NginxVH["Nginx Virtual Hosts (10.252.108.151)"]
    direction LR
    N1["app.corp.pens.lab<br/>/var/www/app"]
    N2["static.corp.pens.lab<br/>/var/www/static"]
  end

  A --> A1
  A --> A2
  A --> A3
  B --> N1
  B --> N2

  classDef server fill:#ddeeff,stroke:#336,stroke-width:1px;
  classDef vhost fill:#fff8dd,stroke:#aa6,stroke-width:1px;
  classDef dns fill:#dfffdf,stroke:#363,stroke-width:1px;

  class A,B server;
  class A1,A2,A3,N1,N2 vhost;
  class DNS dns;
```

**Domain Mapping:**

| Domain | IP | Web Server | DocumentRoot |
|---|---|---|---|
| `blog.corp.pens.lab` | 10.252.108.150 | Apache2 | /var/www/blog |
| `portal.corp.pens.lab` | 10.252.108.150 | Apache2 | /var/www/portal |
| `docs.corp.pens.lab` | 10.252.108.150 | Apache2 | /var/www/docs |
| `app.corp.pens.lab` | 10.252.108.151 | Nginx | /var/www/app |
| `static.corp.pens.lab` | 10.252.108.151 | Nginx | /var/www/static |

> **Catatan:** Sesuaikan IP dengan nomor kelompok. Lihat `TABEL_KELOMPOK_WEBSERVER.md`.

---

## 4. LANGKAH PRAKTIKUM

### Step 1: Persiapan VM dan Instalasi

#### A. VM Apache2 (10.252.108.150)

```bash
# Login ke VM Apache
ssh user@10.252.108.150

# Update package index
sudo apt update

# Install Apache2
sudo apt install apache2 -y

# Cek versi
apache2 -v
# Expected: Server version: Apache/2.4.xx (Ubuntu)

# Cek status
sudo systemctl status apache2
# Expected: active (running)

# Aktifkan firewall rules
sudo ufw allow 'Apache Full'   # port 80 dan 443
sudo ufw status

# Test akses default page
curl -I http://localhost
# Expected: HTTP/1.1 200 OK + Server: Apache/2.4.x
```

**Test dari browser:** Buka `http://10.252.108.150` → tampil Apache2 Ubuntu Default Page.

#### B. VM Nginx (10.252.108.151)

```bash
# Login ke VM Nginx
ssh user@10.252.108.151

# Update dan install Nginx
sudo apt update
sudo apt install nginx -y

# Cek versi
nginx -v
# Expected: nginx version: nginx/1.18.x

# Cek status
sudo systemctl status nginx

# Firewall
sudo ufw allow 'Nginx Full'
sudo ufw status

# Test
curl -I http://localhost
# Expected: HTTP/1.1 200 OK + Server: nginx/1.18.x
```

**Screenshot 1 untuk laporan:** Output `systemctl status apache2` dan `nginx` aktif di masing-masing VM.

---

### Step 2: Konfigurasi DNS (di VM DNS HO - 10.252.108.10)

Tambahkan A record semua domain ke zona `corp.pens.lab`:

```bash
# SSH ke DNS server
ssh user@10.252.108.10

# Edit zone file
sudo nano /etc/bind/db.corp.pens.lab
```

Tambahkan di bagian bawah zone file (setelah record yang sudah ada):

```dns
; Web Server Records - MINGGU 8
; Apache2 VM
blog            IN      A       10.252.108.150
portal          IN      A       10.252.108.150
docs            IN      A       10.252.108.150

; Nginx VM
app             IN      A       10.252.108.151
static          IN      A       10.252.108.151
```

Update serial number di SOA record (increment 1 digit):

```dns
@       IN      SOA     ns.corp.pens.lab. admin.corp.pens.lab. (
                        2026041602  ; Serial (format: YYYYMMDDnn)
                        ...
```

```bash
# Cek syntax zone file
sudo named-checkzone corp.pens.lab /etc/bind/db.corp.pens.lab
# Expected: zone corp.pens.lab/IN: loaded serial ...

# Reload zone
sudo rndc reload corp.pens.lab

# Test resolusi dari DNS server sendiri
dig blog.corp.pens.lab @localhost
dig app.corp.pens.lab @localhost

# Expected ANSWER SECTION: A record sesuai IP
```

**Test dari VM Apache/Nginx:**

```bash
# Dari VM Apache
host blog.corp.pens.lab 10.252.108.10
# Expected: blog.corp.pens.lab has address 10.252.108.150

host app.corp.pens.lab 10.252.108.10
# Expected: app.corp.pens.lab has address 10.252.108.151
```

**Screenshot 2 untuk laporan:** Output `dig blog.corp.pens.lab` dan `dig app.corp.pens.lab` menunjukkan A record.

---

### Step 3: Apache2 — Name-based Virtual Hosting (HTTP)

#### A. Buat Struktur Direktori dan Konten Web

```bash
# Di VM Apache (10.252.108.150)

# Buat direktori untuk setiap site
sudo mkdir -p /var/www/blog
sudo mkdir -p /var/www/portal
sudo mkdir -p /var/www/docs

# Set ownership ke www-data (Apache user)
sudo chown -R www-data:www-data /var/www/blog /var/www/portal /var/www/docs
sudo chmod -R 755 /var/www/blog /var/www/portal /var/www/docs

# Buat halaman index untuk masing-masing site
```

**Buat index untuk blog:**

```bash
sudo nano /var/www/blog/index.html
```

```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Blog PENS - Workshop Jaringan</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: #f0f4f8; }
        .header { background: #2c3e50; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; font-size: 1.8em; }
        .header p { margin: 5px 0 0; opacity: 0.8; }
        .content { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 25px; margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,.1); }
        .badge { display: inline-block; background: #3498db; color: white;
                 padding: 3px 10px; border-radius: 12px; font-size: .8em; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 8px; border-bottom: 1px solid #eee; }
        td:first-child { font-weight: bold; color: #555; width: 180px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📝 Blog Workshop Jaringan</h1>
        <p>Politeknik Elektronika Negeri Surabaya</p>
    </div>
    <div class="content">
        <div class="card">
            <h2>Server Information <span class="badge">Apache2</span></h2>
            <table>
                <tr><td>Virtual Host</td><td>blog.corp.pens.lab</td></tr>
                <tr><td>IP Server</td><td>10.252.108.150</td></tr>
                <tr><td>Web Server</td><td>Apache/2.4 (Ubuntu 22.04)</td></tr>
                <tr><td>DocumentRoot</td><td>/var/www/blog</td></tr>
                <tr><td>Hosting Type</td><td>Name-based Virtual Hosting</td></tr>
            </table>
        </div>
        <div class="card">
            <h2>Selamat Datang!</h2>
            <p>Ini adalah halaman <strong>blog.corp.pens.lab</strong>, virtual host pertama
            yang dikonfigurasi menggunakan Name-based Virtual Hosting di Apache2.</p>
            <p>Virtual hosting memungkinkan satu server melayani banyak domain berbeda
            menggunakan HTTP <code>Host</code> header sebagai pembeda.</p>
        </div>
    </div>
</body>
</html>
```

**Buat index untuk portal:**

```bash
sudo nano /var/www/portal/index.html
```

```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Portal PENS</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: #f5f0ff; }
        .header { background: #6c3483; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; }
        .content { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 25px; margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,.1); }
        .badge { display: inline-block; background: #6c3483; color: white;
                 padding: 3px 10px; border-radius: 12px; font-size: .8em; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 8px; border-bottom: 1px solid #eee; }
        td:first-child { font-weight: bold; color: #555; width: 180px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🌐 Portal PENS</h1>
        <p>Sistem Informasi Workshop Administrasi Jaringan</p>
    </div>
    <div class="content">
        <div class="card">
            <h2>Server Information <span class="badge">Apache2</span></h2>
            <table>
                <tr><td>Virtual Host</td><td>portal.corp.pens.lab</td></tr>
                <tr><td>IP Server</td><td>10.252.108.150</td></tr>
                <tr><td>Web Server</td><td>Apache/2.4 (Ubuntu 22.04)</td></tr>
                <tr><td>DocumentRoot</td><td>/var/www/portal</td></tr>
                <tr><td>Hosting Type</td><td>Name-based Virtual Hosting</td></tr>
            </table>
        </div>
        <div class="card">
            <h2>Portal Mahasiswa</h2>
            <p>Virtual host kedua: <strong>portal.corp.pens.lab</strong>.
            Meskipun berbagi IP yang sama dengan <em>blog.corp.pens.lab</em>,
            server ini menyajikan konten berbeda berdasarkan HTTP Host header.</p>
        </div>
    </div>
</body>
</html>
```

**Buat index untuk docs (dengan directory listing):**

```bash
sudo mkdir -p /var/www/docs/manuals /var/www/docs/configs
echo "Panduan Apache2 Virtual Hosting" | sudo tee /var/www/docs/manuals/apache2-guide.txt
echo "Contoh konfigurasi VHost" | sudo tee /var/www/docs/configs/vhost-example.conf
sudo chown -R www-data:www-data /var/www/docs
```

#### B. Buat File Konfigurasi Virtual Host

**VHost 1: blog.corp.pens.lab**

```bash
sudo nano /etc/apache2/sites-available/blog.conf
```

```apache
<VirtualHost *:80>
    # Primary domain
    ServerName blog.corp.pens.lab
    ServerAlias www.blog.corp.pens.lab

    # Document root
    DocumentRoot /var/www/blog

    # Directory configuration
    <Directory /var/www/blog>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Per-site logging
    ErrorLog ${APACHE_LOG_DIR}/blog_error.log
    CustomLog ${APACHE_LOG_DIR}/blog_access.log combined

    # Custom error pages (optional)
    ErrorDocument 404 /404.html
</VirtualHost>
```

**VHost 2: portal.corp.pens.lab**

```bash
sudo nano /etc/apache2/sites-available/portal.conf
```

```apache
<VirtualHost *:80>
    ServerName portal.corp.pens.lab
    ServerAlias www.portal.corp.pens.lab

    DocumentRoot /var/www/portal

    <Directory /var/www/portal>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Restrict akses hanya dari backbone 10.252.108.0/24 (optional hardening)
    # <Directory /var/www/portal>
    #     Require ip 10.252.108.0/24
    # </Directory>

    ErrorLog ${APACHE_LOG_DIR}/portal_error.log
    CustomLog ${APACHE_LOG_DIR}/portal_access.log combined
</VirtualHost>
```

**VHost 3: docs.corp.pens.lab (dengan directory listing)**

```bash
sudo nano /etc/apache2/sites-available/docs.conf
```

```apache
<VirtualHost *:80>
    ServerName docs.corp.pens.lab

    DocumentRoot /var/www/docs

    <Directory /var/www/docs>
        # Indexes: aktifkan directory listing (tampilkan file jika tidak ada index.html)
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted

        # Deskripsi file di listing (opsional)
        IndexOptions FancyIndexing NameWidth=* DescriptionWidth=*
        AddDescription "Text document" .txt
        AddDescription "Config file" .conf
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/docs_error.log
    CustomLog ${APACHE_LOG_DIR}/docs_access.log combined
</VirtualHost>
```

#### C. Enable Sites dan Reload

```bash
# Enable ketiga sites
sudo a2ensite blog.conf
sudo a2ensite portal.conf
sudo a2ensite docs.conf

# Disable default site (hindari konflik)
sudo a2dissite 000-default.conf

# Test syntax konfigurasi (WAJIB sebelum reload)
sudo apachectl configtest
# Expected: Syntax OK

# Reload Apache (tanpa downtime)
sudo systemctl reload apache2
sudo systemctl status apache2

# Verifikasi site aktif
ls -la /etc/apache2/sites-enabled/
# Expected: blog.conf, portal.conf, docs.conf (symlinks)
```

#### D. Testing Apache Virtual Hosts

```bash
# Test dari VM Apache sendiri (pakai Host header)
curl -H "Host: blog.corp.pens.lab" http://localhost | grep "Virtual Host"
curl -H "Host: portal.corp.pens.lab" http://localhost | grep "Virtual Host"
curl -H "Host: docs.corp.pens.lab" http://localhost

# Test via DNS dari client (pastikan DNS sudah dikonfigurasi di Step 2)
curl http://blog.corp.pens.lab
curl http://portal.corp.pens.lab
curl http://docs.corp.pens.lab

# Test directory listing (docs)
curl http://docs.corp.pens.lab/
# Expected: HTML listing berisi folder manuals/ dan configs/

# Verifikasi per-site logging
sudo tail /var/log/apache2/blog_access.log
sudo tail /var/log/apache2/portal_access.log
sudo tail /var/log/apache2/docs_access.log
```

**Screenshot 3 untuk laporan:** Browser menampilkan tiga halaman berbeda (`blog`, `portal`, `docs`) dari IP yang sama.

---

### Step 4: Apache2 — HTTPS Virtual Host (SSL Termination)

```bash
# Di VM Apache (10.252.108.150)

# Enable modul SSL
sudo a2enmod ssl
sudo a2enmod headers

# Buat direktori sertifikat
sudo mkdir -p /etc/apache2/ssl

# Generate self-signed certificate untuk blog.corp.pens.lab
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/blog.key \
  -out /etc/apache2/ssl/blog.crt \
  -subj "/C=ID/ST=East Java/L=Surabaya/O=PENS/OU=Workshop/CN=blog.corp.pens.lab"

# Generate untuk portal.corp.pens.lab
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/portal.key \
  -out /etc/apache2/ssl/portal.crt \
  -subj "/C=ID/ST=East Java/L=Surabaya/O=PENS/OU=Workshop/CN=portal.corp.pens.lab"

# Verifikasi
ls -lh /etc/apache2/ssl/
sudo chmod 600 /etc/apache2/ssl/*.key
sudo chmod 644 /etc/apache2/ssl/*.crt
```

**Tambahkan HTTPS VHost ke konfigurasi blog.conf:**

```bash
sudo nano /etc/apache2/sites-available/blog.conf
```

Tambahkan di bawah VirtualHost yang sudah ada:

```apache
<VirtualHost *:443>
    ServerName blog.corp.pens.lab
    ServerAlias www.blog.corp.pens.lab

    DocumentRoot /var/www/blog

    # SSL Engine
    SSLEngine on
    SSLCertificateFile      /etc/apache2/ssl/blog.crt
    SSLCertificateKeyFile   /etc/apache2/ssl/blog.key

    # SSL Protocols modern
    SSLProtocol             all -SSLv3 -TLSv1 -TLSv1.1
    SSLCipherSuite          ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256
    SSLHonorCipherOrder     off

    # Security Headers
    Header always set Strict-Transport-Security "max-age=63072000"
    Header always set X-Frame-Options DENY
    Header always set X-Content-Type-Options nosniff

    <Directory /var/www/blog>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/blog_ssl_error.log
    CustomLog ${APACHE_LOG_DIR}/blog_ssl_access.log combined
</VirtualHost>
```

Lakukan hal yang sama untuk `portal.conf`. Kemudian:

```bash
# Test dan reload
sudo apachectl configtest
# Expected: Syntax OK

sudo systemctl reload apache2

# Verifikasi port 443 listen
sudo ss -tlnp | grep apache2
# Expected: 0.0.0.0:80 dan 0.0.0.0:443

# Test HTTPS
curl -k https://blog.corp.pens.lab | grep "Virtual Host"
# -k = ignore self-signed cert warning

# Lihat detail sertifikat
openssl s_client -connect blog.corp.pens.lab:443 -servername blog.corp.pens.lab < /dev/null 2>/dev/null | openssl x509 -noout -subject -dates
# Expected: subject= /CN=blog.corp.pens.lab, notAfter=...
```

**Screenshot 4 untuk laporan:** Browser HTTPS dengan peringatan self-signed + halaman blog tampil. Output `openssl s_client` menampilkan CN dan tanggal expire sertifikat.

---

### Step 5: Nginx — Name-based Virtual Hosting

#### A. Buat Direktori dan Konten

```bash
# Di VM Nginx (10.252.108.151)

sudo mkdir -p /var/www/app /var/www/static
sudo chown -R www-data:www-data /var/www/app /var/www/static
sudo chmod -R 755 /var/www/app /var/www/static

# Index untuk app.corp.pens.lab
sudo nano /var/www/app/index.html
```

```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>App PENS - Nginx</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; background: #f0fff4; }
        .header { background: #1a7a4a; color: white; padding: 20px 40px; }
        .header h1 { margin: 0; }
        .content { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .card { background: white; border-radius: 8px; padding: 25px; margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,.1); }
        .badge { display: inline-block; background: #1a7a4a; color: white;
                 padding: 3px 10px; border-radius: 12px; font-size: .8em; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 8px; border-bottom: 1px solid #eee; }
        td:first-child { font-weight: bold; color: #555; width: 180px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>⚡ App Server PENS</h1>
        <p>Nginx Web Server - Workshop Administrasi Jaringan 2026</p>
    </div>
    <div class="content">
        <div class="card">
            <h2>Server Information <span class="badge">Nginx</span></h2>
            <table>
                <tr><td>Virtual Host</td><td>app.corp.pens.lab</td></tr>
                <tr><td>IP Server</td><td>10.252.108.151</td></tr>
                <tr><td>Web Server</td><td>Nginx/1.18 (Ubuntu 22.04)</td></tr>
                <tr><td>Root</td><td>/var/www/app</td></tr>
                <tr><td>Hosting Type</td><td>Name-based Virtual Hosting</td></tr>
            </table>
        </div>
        <div class="card">
            <h2>Tentang Nginx Server Block</h2>
            <p>Nginx menggunakan <code>server { }</code> block sebagai pengganti
            <code>&lt;VirtualHost&gt;</code> di Apache. Directive <code>server_name</code>
            menentukan domain yang ditangani oleh block ini.</p>
        </div>
    </div>
</body>
</html>
```

```bash
# Index untuk static.corp.pens.lab
sudo nano /var/www/static/index.html
```

```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Static Assets - Nginx</title>
    <style>
        body { font-family: monospace; margin: 0; background: #1e1e1e; color: #d4d4d4; }
        .header { background: #007acc; padding: 20px 40px; color: white; }
        .content { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .card { background: #252526; border-radius: 8px; padding: 25px; margin-bottom: 20px;
                border: 1px solid #333; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 8px; border-bottom: 1px solid #333; }
        td:first-child { color: #9cdcfe; width: 180px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📦 Static Content Server</h1>
        <p>Optimized for serving CSS, JS, images - Nginx</p>
    </div>
    <div class="content">
        <div class="card">
            <h2 style="color:#4ec9b0">Server Information</h2>
            <table>
                <tr><td>Virtual Host</td><td>static.corp.pens.lab</td></tr>
                <tr><td>IP Server</td><td>10.252.108.151</td></tr>
                <tr><td>Web Server</td><td>Nginx/1.18 (Ubuntu 22.04)</td></tr>
                <tr><td>Root</td><td>/var/www/static</td></tr>
                <tr><td>Optimasi</td><td>gzip, expires header, sendfile</td></tr>
            </table>
        </div>
    </div>
</body>
</html>
```

#### B. Buat File Konfigurasi Nginx

**Server block: app.corp.pens.lab**

```bash
sudo nano /etc/nginx/sites-available/app.conf
```

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name app.corp.pens.lab www.app.corp.pens.lab;

    root /var/www/app;
    index index.html index.htm;

    # Charset
    charset utf-8;

    location / {
        try_files $uri $uri/ =404;
    }

    # Custom 404
    error_page 404 /404.html;
    location = /404.html {
        internal;
    }

    # Logging per site
    access_log /var/log/nginx/app_access.log;
    error_log  /var/log/nginx/app_error.log;
}
```

**Server block: static.corp.pens.lab (dengan cache optimization)**

```bash
sudo nano /etc/nginx/sites-available/static.conf
```

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name static.corp.pens.lab;

    root /var/www/static;
    index index.html;

    # Gzip compression untuk static assets
    gzip on;
    gzip_types text/css application/javascript image/svg+xml;
    gzip_min_length 256;

    # Sendfile untuk performa
    sendfile on;
    tcp_nopush on;

    location / {
        try_files $uri $uri/ =404;
    }

    # Cache headers untuk static files
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff2?)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;    # Jangan log akses file static (kurangi I/O)
    }

    # Logging
    access_log /var/log/nginx/static_access.log;
    error_log  /var/log/nginx/static_error.log;
}
```

#### C. Enable Sites dan Reload Nginx

```bash
# Enable kedua sites (buat symlink)
sudo ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/static.conf /etc/nginx/sites-enabled/

# Disable default site
sudo rm /etc/nginx/sites-enabled/default

# Test syntax (WAJIB sebelum reload)
sudo nginx -t
# Expected: nginx: configuration file /etc/nginx/nginx.conf syntax is ok
#           nginx: configuration file /etc/nginx/nginx.conf test is successful

# Reload Nginx
sudo systemctl reload nginx
sudo systemctl status nginx

# Verifikasi site aktif
ls -la /etc/nginx/sites-enabled/
```

#### D. Testing Nginx Virtual Hosts

```bash
# Test dengan Host header
curl -H "Host: app.corp.pens.lab" http://localhost | grep "Virtual Host"
curl -H "Host: static.corp.pens.lab" http://localhost | grep "Virtual Host"

# Test via DNS
curl http://app.corp.pens.lab
curl http://static.corp.pens.lab

# Verifikasi server_name matching (wrong host → default atau 404)
curl -H "Host: unknown.corp.pens.lab" http://10.252.108.151 -I
# Expected: 404 Not Found (karena tidak ada matching server block)

# Cek access log
sudo tail /var/log/nginx/app_access.log
sudo tail /var/log/nginx/static_access.log
```

**Screenshot 5 untuk laporan:** Browser menampilkan halaman `app.corp.pens.lab` dan `static.corp.pens.lab` dari VM Nginx.

---

### Step 6: Nginx — HTTPS Virtual Host

```bash
# Di VM Nginx (10.252.108.151)

# Buat direktori SSL
sudo mkdir -p /etc/nginx/ssl

# Generate certificate untuk app.corp.pens.lab
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/app.key \
  -out /etc/nginx/ssl/app.crt \
  -subj "/C=ID/ST=East Java/L=Surabaya/O=PENS/OU=Workshop/CN=app.corp.pens.lab"

sudo chmod 600 /etc/nginx/ssl/app.key
sudo chmod 644 /etc/nginx/ssl/app.crt
```

Edit `/etc/nginx/sites-available/app.conf`, tambahkan HTTPS server block:

```bash
sudo nano /etc/nginx/sites-available/app.conf
```

Tambahkan di bawah HTTP server block:

```nginx
# HTTPS Server Block
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name app.corp.pens.lab www.app.corp.pens.lab;

    root /var/www/app;
    index index.html;

    # SSL Certificates
    ssl_certificate     /etc/nginx/ssl/app.crt;
    ssl_certificate_key /etc/nginx/ssl/app.key;

    # SSL Protocols
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers off;

    # SSL Session cache
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security headers
    add_header Strict-Transport-Security "max-age=63072000" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/app_ssl_access.log;
    error_log  /var/log/nginx/app_ssl_error.log;
}
```

```bash
# Test dan reload
sudo nginx -t
sudo systemctl reload nginx

# Verifikasi port
sudo ss -tlnp | grep nginx
# Expected: 0.0.0.0:80 dan 0.0.0.0:443

# Test HTTPS
curl -k https://app.corp.pens.lab | grep "Virtual Host"

# Cek sertifikat
openssl s_client -connect app.corp.pens.lab:443 -servername app.corp.pens.lab < /dev/null 2>/dev/null \
  | openssl x509 -noout -subject -dates
```

**Screenshot 6 untuk laporan:** Browser HTTPS `app.corp.pens.lab` dengan sertifikat self-signed + halaman tampil.

---

### Step 7: IP-based Virtual Hosting (Apache2)

Tambahkan IP alias ke VM Apache untuk demonstrasi IP-based VHost:

```bash
# Di VM Apache (10.252.108.150)

# Cek interface yang aktif
ip addr show
# Catat nama interface (misal: ens18 atau eth0)

# Tambah IP alias sementara (hilang setelah reboot)
sudo ip addr add 10.252.108.155/24 dev ens18 label ens18:1

# Verifikasi
ip addr show ens18
# Expected: inet 10.252.108.150/24 dan inet 10.252.108.155/24 muncul keduanya
```

**Tambah DNS record (di VM DNS):**

```bash
sudo nano /etc/bind/db.corp.pens.lab
```

Tambahkan:

```dns
; IP-based VHost demo
secure          IN      A       10.252.108.155
```

Kemudian `sudo rndc reload corp.pens.lab`.

**Buat site baru (IP-based):**

```bash
# Di VM Apache
sudo mkdir -p /var/www/secure
sudo chown www-data:www-data /var/www/secure

sudo nano /var/www/secure/index.html
```

```html
<!DOCTYPE html>
<html>
<head><title>Secure Site - IP-based VHost</title>
<style>body{font-family:sans-serif;background:#fff3cd;padding:40px}
.card{background:white;padding:25px;border-radius:8px;max-width:600px;margin:auto;
border-left:5px solid #ffc107}</style></head>
<body>
<div class="card">
  <h1>🔒 Secure Site</h1>
  <p><strong>Domain:</strong> secure.corp.pens.lab</p>
  <p><strong>Dedicated IP:</strong> 10.252.108.155</p>
  <p><strong>Tipe:</strong> IP-based Virtual Hosting</p>
  <p><strong>Perbedaan:</strong> Site ini terikat pada IP spesifik 10.252.108.155,
  bukan pada semua IP server (*). IP-based VHost memberikan isolasi lebih kuat.</p>
</div>
</body></html>
```

```bash
sudo nano /etc/apache2/sites-available/secure.conf
```

```apache
# IP-based VirtualHost: bind ke IP spesifik (10.252.108.155)
<VirtualHost 10.252.108.155:80>
    ServerName secure.corp.pens.lab

    DocumentRoot /var/www/secure

    <Directory /var/www/secure>
        Options FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/secure_error.log
    CustomLog ${APACHE_LOG_DIR}/secure_access.log combined
</VirtualHost>
```

```bash
sudo a2ensite secure.conf
sudo apachectl configtest
sudo systemctl reload apache2

# Test: akses via IP alias
curl http://10.252.108.155
# Expected: Secure Site page

# Test: akses via hostname
curl http://secure.corp.pens.lab
# Expected: Secure Site page

# Test: akses IP utama TIDAK menyajikan secure site
curl http://10.252.108.150
# Expected: Default page (bukan secure site), karena VHost terikat ke .155
```

**Screenshot 7 untuk laporan:** Output `curl http://10.252.108.155` dan `curl http://10.252.108.150` menampilkan konten BERBEDA, membuktikan IP-based VHost.

---

### Step 8: Analisis Log dan Troubleshooting

#### A. Monitoring Real-time

```bash
# Watch log Apache semua site
sudo tail -f /var/log/apache2/blog_access.log \
             /var/log/apache2/portal_access.log \
             /var/log/apache2/docs_access.log

# Watch log Nginx
sudo tail -f /var/log/nginx/app_access.log \
             /var/log/nginx/static_access.log

# Generate traffic dari terminal lain
for site in blog portal docs; do
  curl -s http://${site}.corp.pens.lab -o /dev/null
done
```

#### B. Analisis Distribusi Traffic per VHost

```bash
# Hitung request per VHost Apache
echo "=== Apache VHost Traffic ==="
for site in blog portal docs; do
  count=$(sudo wc -l < /var/log/apache2/${site}_access.log 2>/dev/null || echo 0)
  echo "  ${site}.corp.pens.lab: ${count} requests"
done

# Hitung unique IP
echo "=== Unique Clients ==="
sudo awk '{print $1}' /var/log/apache2/blog_access.log | sort -u | wc -l
```

#### C. Common Troubleshooting Commands

```bash
# Apache: test config dan lihat virtual host yang aktif
sudo apachectl -S
# Expected: Listing semua VirtualHost dengan IP, port, dan priority

# Apache: cek error log realtime
sudo tail -f /var/log/apache2/error.log

# Nginx: tampilkan semua server block
sudo nginx -T | grep server_name

# Nginx: cek error log realtime
sudo tail -f /var/log/nginx/error.log

# Cek port listening
sudo ss -tlnp | grep -E 'apache2|nginx'

# Test resolusi DNS per domain
for domain in blog portal docs; do
  host ${domain}.corp.pens.lab 10.252.108.10
done
```

**Screenshot 8 untuk laporan:** Output `apachectl -S` menampilkan semua VirtualHost terdaftar. Output `sudo nginx -T | grep server_name` menampilkan semua server_name aktif.

---

## 5. PERTANYAAN PRE-LAB (Teori)

Jawab sebelum praktikum (tulis di laporan):

1. Jelaskan perbedaan **Name-based** vs **IP-based** Virtual Hosting. Berikan contoh skenario penggunaan yang tepat untuk masing-masing.
2. Apa fungsi **HTTP `Host` header** dalam proses Name-based Virtual Hosting? Apa yang terjadi jika request tidak menyertakan header Host?
3. Bandingkan arsitektur Apache2 (process-based MPM prefork/worker) vs Nginx (event-driven). Apa implikasi pada penggunaan memori dan concurrency?
4. Jelaskan mengapa **SNI (Server Name Indication)** diperlukan untuk Name-based Virtual Hosting dengan HTTPS, dan browser/OS apa yang tidak mendukungnya?
5. Apa perbedaan fungsi direktori `sites-available` dan `sites-enabled` di Apache2/Nginx? Mengapa praktik symlink ini lebih baik daripada menyimpan langsung di `sites-enabled`?

---

## 6. PERTANYAAN POST-LAB (Analisis)

Jawab setelah praktikum (tulis di laporan):

6. Dari hasil `apachectl -S`, jelaskan bagaimana Apache menentukan prioritas VirtualHost jika ada dua VHost yang match untuk satu request.
7. Analisis access log: bandingkan rata-rata waktu response (jika ada field waktu) antara Apache dan Nginx untuk request ke halaman yang sama. Jelaskan faktor-faktor yang memengaruhi perbedaan tersebut.
8. Jika `docs.corp.pens.lab` menampilkan **403 Forbidden** alih-alih directory listing, apa kemungkinan penyebabnya dan bagaimana cara memperbaikinya?
9. Bagaimana cara mengintegrasikan virtual host ini dengan **Centralized Logging rsyslog** dari MINGGU_7, agar semua access log dikirim ke log server terpusat?
10. Dalam konteks **Reverse Proxy** (MINGGU_5), jelaskan bagaimana virtual hosting di backend bekerja ketika Nginx Proxy mem-forward request dengan `proxy_set_header Host $host`.

---

## 7. FINAL CHECKLIST

Centang semua sebelum submit laporan:

- [ ] Apache2 terinstal dan aktif: `apache2 -v` + `systemctl status apache2`
- [ ] Nginx terinstal dan aktif: `nginx -v` + `systemctl status nginx`
- [ ] DNS records dibuat: `dig blog.corp.pens.lab`, `dig app.corp.pens.lab` menampilkan A record
- [ ] Apache VHost 1 (HTTP): `curl http://blog.corp.pens.lab` menampilkan halaman blog
- [ ] Apache VHost 2 (HTTP): `curl http://portal.corp.pens.lab` menampilkan halaman portal
- [ ] Apache VHost 3 (directory listing): `http://docs.corp.pens.lab` menampilkan listing folder
- [ ] Apache SSL: `curl -k https://blog.corp.pens.lab` berhasil + sertifikat terverifikasi
- [ ] Nginx VHost 1: `curl http://app.corp.pens.lab` menampilkan halaman app
- [ ] Nginx VHost 2: `curl http://static.corp.pens.lab` menampilkan halaman static
- [ ] Nginx SSL: `curl -k https://app.corp.pens.lab` berhasil
- [ ] IP-based VHost: `curl 10.252.108.155` ≠ `curl 10.252.108.150` (konten berbeda)
- [ ] Per-site logging aktif: log terpisah di `/var/log/apache2/` dan `/var/log/nginx/`
- [ ] `apachectl -S` menampilkan semua VHost terdaftar dengan benar
- [ ] 8 screenshot tersimpan (sesuai requirement di bawah)

---

## 8. TABEL TROUBLESHOOTING

| **Gejala** | **Kemungkinan Cause** | **Fix** |
|---|---|---|
| `apachectl configtest` error | Syntax salah, missing `</VirtualHost>` | Cek baris error, periksa tag buka/tutup |
| Browser tampilkan site salah / default | ServerName tidak cocok Host header | Pastikan `ServerName` = domain yang diakses, reload Apache |
| 403 Forbidden di directory listing | `Options Indexes` tidak aktif atau permission salah | Tambah `Options Indexes` di `<Directory>`, cek `chmod 755` |
| 404 Not Found padahal file ada | DocumentRoot path salah | Verifikasi path absolut, cek typo |
| `curl: (7) Failed to connect` | Apache/Nginx tidak listen di port | `ss -tlnp`, cek firewall `ufw status` |
| SSL `ERR_CERT_AUTHORITY_INVALID` | Self-signed cert tidak trusted | Normal untuk lab; browser → Advanced → Proceed |
| DNS NXDOMAIN | Record belum ditambah atau zone belum reload | Tambah A record, `rndc reload`, cek `named-checkzone` |
| IP-based VHost tidak terbaca | IP alias tidak aktif | `ip addr show`, tambah IP alias kembali |
| Nginx: `[emerg] bind() failed` | Port sudah dipakai proses lain (Apache?) | `ss -tlnp \| grep :80`, hentikan proses konflik |
| Log tidak tertulis per VHost | Path log salah atau direktori tidak ada | Pastikan direktori log ada, cek write permission |
| `a2ensite` tidak ada perintah | Apache tidak terinstal | `sudo apt install apache2` |
| HTTPS redirect tidak berfungsi | `mod_rewrite` belum aktif | `sudo a2enmod rewrite`, reload |

---

## 9. FORMAT LAPORAN

Submit via LMS dalam **satu file PDF (max 7 halaman)**:

**Halaman 1: Cover & Data Kelompok**
- Judul: Laporan Praktikum MINGGU 8 - Web Server & Virtual Hosting
- Nama/NRP anggota kelompok
- Kelas, Kelompok, IP VM Apache (150) dan Nginx (151)
- Tanggal praktikum

**Halaman 2-5: Screenshot Testing (8 gambar wajib)**
1. `systemctl status apache2` aktif (VM 150) + `systemctl status nginx` aktif (VM 151)
2. `dig blog.corp.pens.lab` + `dig app.corp.pens.lab` → A record sesuai
3. Browser HTTP: blog, portal, docs (3 halaman berbeda dari IP 10.252.108.150)
4. Browser HTTPS: `https://blog.corp.pens.lab` dengan lock icon (self-signed warning)
5. Browser Nginx: `app.corp.pens.lab` + `static.corp.pens.lab` (2 halaman berbeda dari IP 10.252.108.151)
6. IP-based VHost: `curl 10.252.108.155` vs `curl 10.252.108.150` (konten berbeda)
7. `apachectl -S` menampilkan semua VirtualHost terdaftar
8. Per-site access log: `tail /var/log/apache2/blog_access.log` + `tail /var/log/nginx/app_access.log`

**Halaman 6: Jawaban Pertanyaan**
- Pre-Lab: soal 1-5 (Name-based vs IP-based, Host header, Apache vs Nginx arch, SNI, sites-available)
- Post-Lab: soal 6-10 (VHost priority, log analisis, 403 debug, rsyslog integrasi, reverse proxy)

**Halaman 7: Final Checklist & Kesimpulan**
- Centang semua 14 item checklist
- Kesimpulan praktikum (5-7 kalimat):
  - Keberhasilan Name-based VHost (5 domain dari 2 IP)
  - Perbandingan konfigurasi Apache2 vs Nginx
  - Manfaat per-site logging untuk monitoring
  - Integrasi dengan materi sebelumnya (DNS, Reverse Proxy, Logging)
- Troubleshoot yang dialami dan solusi

---

## 10. ADVANCED: EKSPLORASI TAMBAHAN (Opsional, Bonus Point)

### A. HTTP → HTTPS Redirect (301 Permanent)

Tambahkan di VHost HTTP Apache (port 80) untuk paksa redirect ke HTTPS:

```apache
<VirtualHost *:80>
    ServerName blog.corp.pens.lab
    # Redirect semua HTTP ke HTTPS
    Redirect permanent / https://blog.corp.pens.lab/
</VirtualHost>
```

Nginx equivalent:

```nginx
server {
    listen 80;
    server_name app.corp.pens.lab;
    return 301 https://$host$request_uri;
}
```

Test:

```bash
curl -I http://blog.corp.pens.lab
# Expected: HTTP/1.1 301 Moved Permanently
# Location: https://blog.corp.pens.lab/

curl -IL http://blog.corp.pens.lab
# Expected: 301 → 200 (follow redirect)
```

### B. Password-Protected Directory dengan .htaccess

```bash
# Di VM Apache
# Buat file password
sudo htpasswd -c /etc/apache2/.htpasswd adminpens
# Enter password saat diminta

# Edit VHost (portal) tambahkan proteksi direktori admin
sudo nano /etc/apache2/sites-available/portal.conf
```

Tambahkan di dalam `<VirtualHost>`:

```apache
<Directory /var/www/portal/admin>
    AuthType Basic
    AuthName "Admin Area - PENS Workshop"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
</Directory>
```

```bash
sudo mkdir -p /var/www/portal/admin
echo "<h1>Admin Area</h1>" | sudo tee /var/www/portal/admin/index.html
sudo chown www-data:www-data /var/www/portal/admin -R

sudo a2enmod auth_basic
sudo systemctl reload apache2

# Test
curl http://portal.corp.pens.lab/admin/
# Expected: HTTP 401 Unauthorized

curl -u adminpens:PASSWORD http://portal.corp.pens.lab/admin/
# Expected: 200 OK + Admin Area page
```

### C. Custom Log Format dengan Waktu Response

Tambahkan log format khusus di `/etc/apache2/apache2.conf`:

```apache
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %D" combined_time
```

Di VHost blog, ganti `CustomLog` directive:

```apache
CustomLog ${APACHE_LOG_DIR}/blog_access.log combined_time
```

`%D` = waktu request dalam microseconds. Gunakan untuk menganalisis slow request.

### D. Nginx: Rate Limiting per VHost

Tambahkan di `/etc/nginx/nginx.conf` (http block):

```nginx
limit_req_zone $binary_remote_addr zone=app_limit:10m rate=10r/s;
```

Di server block `app.conf`:

```nginx
location / {
    limit_req zone=app_limit burst=20 nodelay;
    try_files $uri $uri/ =404;
}
```

Test:

```bash
# Kirim 50 request cepat
ab -n 50 -c 50 http://app.corp.pens.lab/

# Cek log error Nginx
sudo tail /var/log/nginx/app_error.log
# Expected: "limiting requests, excess: ... by zone 'app_limit'"
```

---

## 11. REFERENSI

1. Apache Software Foundation. (2024). Apache HTTP Server Documentation - Virtual Hosts. https://httpd.apache.org/docs/2.4/vhosts/
2. Apache Software Foundation. (2024). Name-based Virtual Host Support. https://httpd.apache.org/docs/2.4/vhosts/name-based.html
3. NGINX, Inc. (2025). NGINX Documentation - Server Names. https://nginx.org/en/docs/http/server_names.html
4. NGINX, Inc. (2025). Configuring HTTPS Servers. https://nginx.org/en/docs/http/configuring_https_servers.html
5. DigitalOcean. (2025). How To Set Up Apache Virtual Hosts on Ubuntu 22.04. https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-22-04
6. DigitalOcean. (2025). How To Set Up Nginx Server Blocks on Ubuntu 22.04. https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-22-04
7. Eastlake, D., & Panitz, A. (1999). Reserved Top Level DNS Names (RFC 2606). IETF. https://www.rfc-editor.org/rfc/rfc2606
8. Ubuntu Documentation. (2025). Install and configure Apache2. Canonical Ltd. https://ubuntu.com/tutorials/install-and-configure-apache2

---

Durasi: 120 menit | Difficulty: Intermediate  
Previous: MINGGU_7 Centralized Logging (rsyslog)  
Next: MINGGU_9 Firewall & iptables / nftables

**Lihat file terpisah:** `TABEL_KELOMPOK_WEBSERVER.md` untuk mapping 40 VM kelompok dengan alokasi IP dan domain.
