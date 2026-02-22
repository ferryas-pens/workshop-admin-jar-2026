# Tabel Kelompok Nginx Upstream - MINGGU 5
## Workshop Administrasi Sistem & Jaringan - PENS

**Topik:** Nginx Reverse Proxy Upstream Backend Mapping  
**Nginx Proxy:** 10.252.108.30 (Load Balancer HO)  
**Backend Pool:** 10.252.108.151-190 (DHCP reservations dari MINGGU_4)

---

## Mapping Lengkap 40 Upstream Backends

Gunakan tabel ini untuk konfigurasi Nginx upstream block:
- **VM Hostname** untuk identifikasi backend
- **Backend IP** (DHCP reservation dari MINGGU_4)
- **Listen Port** (default 80 HTTP, backend tidak perlu SSL)
- **Web Server** software (Apache atau Nginx)
- **Weight** recommendation (berdasarkan hardware/load capacity)
- **Max Fails** dan **Fail Timeout** untuk health check

| Kelas | Kelompok | VM Hostname   | Backend IP       | Port | Web Server | Weight | Max Fails | Fail Timeout |
|-------|----------|---------------|------------------|------|------------|--------|-----------|--------------|
| **A** | K01      | srv-ho-a01   | 10.252.108.151  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K02      | srv-ho-a02   | 10.252.108.152  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K03      | srv-ho-a03   | 10.252.108.153  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K04      | srv-ho-a04   | 10.252.108.154  | 80   | Nginx      | 2      | 3         | 30s          |
| A     | K05      | srv-ho-a05   | 10.252.108.155  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K06      | srv-ho-a06   | 10.252.108.156  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K07      | srv-ho-a07   | 10.252.108.157  | 80   | Nginx      | 2      | 3         | 30s          |
| A     | K08      | srv-ho-a08   | 10.252.108.158  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K09      | srv-ho-a09   | 10.252.108.159  | 80   | Apache     | 1      | 3         | 30s          |
| A     | K10      | srv-ho-a10   | 10.252.108.160  | 80   | Apache     | 1      | 3         | 30s          |
| **B** | K01      | srv-ho-b01   | 10.252.108.161  | 80   | Nginx      | 2      | 3         | 30s          |
| B     | K02      | srv-ho-b02   | 10.252.108.162  | 80   | Apache     | 1      | 3         | 30s          |
| B     | K03      | srv-ho-b03   | 10.252.108.163  | 80   | Apache     | 1      | 3         | 30s          |
| B     | K04      | srv-ho-b04   | 10.252.108.164  | 80   | Nginx      | 2      | 3         | 30s          |
| B     | K05      | srv-ho-b05   | 10.252.108.165  | 80   | Apache     | 1      | 3         | 30s          |
| B     | K06      | srv-ho-b06   | 10.252.108.166  | 80   | Apache     | 1      | 3         | 30s          |
| B     | K07      | srv-ho-b07   | 10.252.108.167  | 80   | Nginx      | 2      | 3         | 30s          |
| B     | K08      | srv-ho-b08   | 10.252.108.168  | 80   | Apache     | 1      | 3         | 30s          |
| B     | K09      | srv-ho-b09   | 10.252.108.169  | 80   | Apache     | 1      | 3         | 30s          |
| B     | K10      | srv-ho-b10   | 10.252.108.170  | 80   | Apache     | 1      | 3         | 30s          |
| **C** | K01      | srv-ho-c01   | 10.252.108.171  | 80   | Apache     | 1      | 3         | 30s          |
| C     | K02      | srv-ho-c02   | 10.252.108.172  | 80   | Nginx      | 2      | 3         | 30s          |
| C     | K03      | srv-ho-c03   | 10.252.108.173  | 80   | Apache     | 1      | 3         | 30s          |
| C     | K04      | srv-ho-c04   | 10.252.108.174  | 80   | Apache     | 1      | 3         | 30s          |
| C     | K05      | srv-ho-c05   | 10.252.108.175  | 80   | Nginx      | 2      | 3         | 30s          |
| C     | K06      | srv-ho-c06   | 10.252.108.176  | 80   | Apache     | 1      | 3         | 30s          |
| C     | K07      | srv-ho-c07   | 10.252.108.177  | 80   | Apache     | 1      | 3         | 30s          |
| C     | K08      | srv-ho-c08   | 10.252.108.178  | 80   | Nginx      | 2      | 3         | 30s          |
| C     | K09      | srv-ho-c09   | 10.252.108.179  | 80   | Apache     | 1      | 3         | 30s          |
| C     | K10      | srv-ho-c10   | 10.252.108.180  | 80   | Apache     | 1      | 3         | 30s          |
| **D** | K01      | srv-ho-d01   | 10.252.108.181  | 80   | Apache     | 1      | 3         | 30s          |
| D     | K02      | srv-ho-d02   | 10.252.108.182  | 80   | Nginx      | 2      | 3         | 30s          |
| D     | K03      | srv-ho-d03   | 10.252.108.183  | 80   | Apache     | 1      | 3         | 30s          |
| D     | K04      | srv-ho-d04   | 10.252.108.184  | 80   | Apache     | 1      | 3         | 30s          |
| D     | K05      | srv-ho-d05   | 10.252.108.185  | 80   | Nginx      | 2      | 3         | 30s          |
| D     | K06      | srv-ho-d06   | 10.252.108.186  | 80   | Apache     | 1      | 3         | 30s          |
| D     | K07      | srv-ho-d07   | 10.252.108.187  | 80   | Apache     | 1      | 3         | 30s          |
| D     | K08      | srv-ho-d08   | 10.252.108.188  | 80   | Nginx      | 2      | 3         | 30s          |
| D     | K09      | srv-ho-d09   | 10.252.108.189  | 80   | Apache     | 1      | 3         | 30s          |
| D     | K10      | srv-ho-d10   | 10.252.108.190  | 80   | Apache     | 1      | 3         | 30s          |

---

## Skema Load Balancing Topology

```
                   Internet / Client Browser
                              ↓
                   ═══════════════════════════
                   ║ Nginx Reverse Proxy     ║
                   ║ 10.252.108.30           ║
                   ║ Listen: 80/443          ║
                   ║ Upstream: web_farm      ║
                   ═══════════════════════════
                              ↓
                proxy_pass http://web_farm
                              ↓
        ┌─────────────┬───────────┬───────────┬──────────────┐
        ↓             ↓           ↓           ↓              ↓
    Backend A01   Backend A02  Backend B01  Backend C01   ... +36 more
    .151:80       .152:80      .161:80      .171:80
    Apache        Apache       Nginx        Apache
    Weight=1      Weight=1     Weight=2     Weight=1
```

**Load Balancing:** least_conn algorithm → request dikirim ke backend dengan koneksi aktif paling sedikit.  
**Weight:** Nginx backends (weight=2) handle 2x traffic vs Apache backends (weight=1) karena lebih efficient.

---

## Template Nginx Upstream Config (4 Backends Demo)

Untuk lab demo dengan 4 backends (A01, A02, B01, B02), copy-paste ini ke `/etc/nginx/sites-available/proxy`:

```nginx
# Upstream block: define backend pool
upstream web_farm {
    # Load balancing method
    least_conn;  # Route ke server dengan koneksi paling sedikit

    # Backend servers (demo: 4 kelompok)
    server 10.252.108.151:80 weight=1 max_fails=3 fail_timeout=30s;  # srv-ho-a01 Apache
    server 10.252.108.152:80 weight=1 max_fails=3 fail_timeout=30s;  # srv-ho-a02 Apache
    server 10.252.108.161:80 weight=2 max_fails=3 fail_timeout=30s;  # srv-ho-b01 Nginx
    server 10.252.108.162:80 weight=1 max_fails=3 fail_timeout=30s;  # srv-ho-b02 Apache

    # Keepalive connections (performance optimization)
    keepalive 32;
}

# Server block HTTP
server {
    listen 80;
    server_name proxy.corp.pens.lab;

    location / {
        proxy_pass http://web_farm;
        
        # Proxy headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # HTTP keepalive
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        
        # Health check
        proxy_next_upstream error timeout http_502 http_503 http_504;
        proxy_next_upstream_tries 3;
        proxy_next_upstream_timeout 30s;
    }
}
```

**Test syntax:**
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## Template Nginx Upstream Config (Full 40 Backends)

Untuk production setup dengan semua 40 VM kelompok, expand upstream block:

```nginx
upstream web_farm_full {
    least_conn;

    # Kelas A (10 backends)
    server 10.252.108.151:80 weight=1 max_fails=3 fail_timeout=30s;  # a01
    server 10.252.108.152:80 weight=1 max_fails=3 fail_timeout=30s;  # a02
    server 10.252.108.153:80 weight=1 max_fails=3 fail_timeout=30s;  # a03
    server 10.252.108.154:80 weight=2 max_fails=3 fail_timeout=30s;  # a04 Nginx
    server 10.252.108.155:80 weight=1 max_fails=3 fail_timeout=30s;  # a05
    server 10.252.108.156:80 weight=1 max_fails=3 fail_timeout=30s;  # a06
    server 10.252.108.157:80 weight=2 max_fails=3 fail_timeout=30s;  # a07 Nginx
    server 10.252.108.158:80 weight=1 max_fails=3 fail_timeout=30s;  # a08
    server 10.252.108.159:80 weight=1 max_fails=3 fail_timeout=30s;  # a09
    server 10.252.108.160:80 weight=1 max_fails=3 fail_timeout=30s;  # a10

    # Kelas B (10 backends)
    server 10.252.108.161:80 weight=2 max_fails=3 fail_timeout=30s;  # b01 Nginx
    server 10.252.108.162:80 weight=1 max_fails=3 fail_timeout=30s;  # b02
    server 10.252.108.163:80 weight=1 max_fails=3 fail_timeout=30s;  # b03
    server 10.252.108.164:80 weight=2 max_fails=3 fail_timeout=30s;  # b04 Nginx
    server 10.252.108.165:80 weight=1 max_fails=3 fail_timeout=30s;  # b05
    server 10.252.108.166:80 weight=1 max_fails=3 fail_timeout=30s;  # b06
    server 10.252.108.167:80 weight=2 max_fails=3 fail_timeout=30s;  # b07 Nginx
    server 10.252.108.168:80 weight=1 max_fails=3 fail_timeout=30s;  # b08
    server 10.252.108.169:80 weight=1 max_fails=3 fail_timeout=30s;  # b09
    server 10.252.108.170:80 weight=1 max_fails=3 fail_timeout=30s;  # b10

    # Kelas C (10 backends)
    server 10.252.108.171:80 weight=1 max_fails=3 fail_timeout=30s;  # c01
    server 10.252.108.172:80 weight=2 max_fails=3 fail_timeout=30s;  # c02 Nginx
    server 10.252.108.173:80 weight=1 max_fails=3 fail_timeout=30s;  # c03
    server 10.252.108.174:80 weight=1 max_fails=3 fail_timeout=30s;  # c04
    server 10.252.108.175:80 weight=2 max_fails=3 fail_timeout=30s;  # c05 Nginx
    server 10.252.108.176:80 weight=1 max_fails=3 fail_timeout=30s;  # c06
    server 10.252.108.177:80 weight=1 max_fails=3 fail_timeout=30s;  # c07
    server 10.252.108.178:80 weight=2 max_fails=3 fail_timeout=30s;  # c08 Nginx
    server 10.252.108.179:80 weight=1 max_fails=3 fail_timeout=30s;  # c09
    server 10.252.108.180:80 weight=1 max_fails=3 fail_timeout=30s;  # c10

    # Kelas D (10 backends)
    server 10.252.108.181:80 weight=1 max_fails=3 fail_timeout=30s;  # d01
    server 10.252.108.182:80 weight=2 max_fails=3 fail_timeout=30s;  # d02 Nginx
    server 10.252.108.183:80 weight=1 max_fails=3 fail_timeout=30s;  # d03
    server 10.252.108.184:80 weight=1 max_fails=3 fail_timeout=30s;  # d04
    server 10.252.108.185:80 weight=2 max_fails=3 fail_timeout=30s;  # d05 Nginx
    server 10.252.108.186:80 weight=1 max_fails=3 fail_timeout=30s;  # d06
    server 10.252.108.187:80 weight=1 max_fails=3 fail_timeout=30s;  # d07
    server 10.252.108.188:80 weight=2 max_fails=3 fail_timeout=30s;  # d08 Nginx
    server 10.252.108.189:80 weight=1 max_fails=3 fail_timeout=30s;  # d09
    server 10.252.108.190:80 weight=1 max_fails=3 fail_timeout=30s;  # d10

    keepalive 64;  # Increase untuk 40 backends
}
```

**Catatan:**
- Total 40 backends: 28 Apache (weight=1) + 12 Nginx (weight=2)
- Expected traffic distribution: ~40% Nginx backends, ~60% Apache backends (berdasarkan weight)
- Keepalive 64 connections optimal untuk 40 backends

---

## Weight Recommendation Guidelines

| Web Server | Default Weight | Reasoning                                   | Capacity Example |
|------------|----------------|---------------------------------------------|------------------|
| Apache     | 1              | Baseline (RAM 4GB, CPU 2 core)             | ~500 req/s       |
| Nginx      | 2              | 2x efficient (event-driven, low overhead)  | ~1000 req/s      |
| Custom     | 3-5            | High-spec server (RAM 8GB+, CPU 4+ core)   | ~1500+ req/s     |

**How to determine optimal weight:**

1. **Benchmark setiap backend dengan Apache Bench:**
   ```bash
   ab -n 10000 -c 100 http://10.252.108.151/
   # Output: Requests per second: 487.23 [#/sec]
   
   ab -n 10000 -c 100 http://10.252.108.161/
   # Output: Requests per second: 921.45 [#/sec]
   ```

2. **Calculate weight ratio:**
   ```
   Weight A01 = 487 / 487 = 1 (baseline)
   Weight B01 = 921 / 487 = 1.89 ≈ 2
   ```

3. **Update upstream config sesuai benchmark result.**

---

## Backend Web Server Setup Templates

### Template A: Apache Backend (srv-ho-a01)

```bash
# Install Apache
sudo apt update && sudo apt install apache2 php libapache2-mod-php -y

# Custom index.php (identifikasi backend)
sudo tee /var/www/html/index.php <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Backend A01</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; background: #e3f2fd; }
        h1 { color: #1976d2; }
        .info { background: white; padding: 20px; border-radius: 10px; display: inline-block; }
    </style>
</head>
<body>
    <div class="info">
        <h1>Backend Server: srv-ho-a01</h1>
        <p><strong>IP:</strong> 10.252.108.151</p>
        <p><strong>Hostname:</strong> <?php echo gethostname(); ?></p>
        <p><strong>Software:</strong> Apache <?php echo apache_get_version(); ?></p>
        <p><strong>Kelas:</strong> A | <strong>Kelompok:</strong> 01</p>
        <hr>
        <p><strong>Client IP:</strong> <?php echo \$_SERVER['HTTP_X_REAL_IP'] ?? \$_SERVER['REMOTE_ADDR']; ?></p>
        <p><strong>Protocol:</strong> <?php echo \$_SERVER['HTTP_X_FORWARDED_PROTO'] ?? 'http'; ?></p>
        <p><strong>Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
    </div>
</body>
</html>
EOF

# Restart Apache
sudo systemctl restart apache2

# Test
curl http://localhost
```

### Template B: Nginx Backend (srv-ho-b01)

```bash
# Install Nginx
sudo apt update && sudo apt install nginx php-fpm -y

# Configure Nginx untuk PHP
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    root /var/www/html;
    index index.php index.html;
    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }
}
EOF

# Custom index.php (sesuaikan identitas)
sudo tee /var/www/html/index.php <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Backend B01</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; background: #f3e5f5; }
        h1 { color: #7b1fa2; }
        .info { background: white; padding: 20px; border-radius: 10px; display: inline-block; }
    </style>
</head>
<body>
    <div class="info">
        <h1>Backend Server: srv-ho-b01</h1>
        <p><strong>IP:</strong> 10.252.108.161</p>
        <p><strong>Hostname:</strong> <?php echo gethostname(); ?></p>
        <p><strong>Software:</strong> Nginx + PHP-FPM</p>
        <p><strong>Kelas:</strong> B | <strong>Kelompok:</strong> 01</p>
        <hr>
        <p><strong>Client IP:</strong> <?php echo \$_SERVER['HTTP_X_REAL_IP'] ?? \$_SERVER['REMOTE_ADDR']; ?></p>
        <p><strong>Protocol:</strong> <?php echo \$_SERVER['HTTP_X_FORWARDED_PROTO'] ?? 'http'; ?></p>
        <p><strong>Time:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
    </div>
</body>
</html>
EOF

# Restart services
sudo systemctl restart nginx php*-fpm

# Test
curl http://localhost
```

---

## Catatan untuk Asisten Lab

**Pre-Lab Setup:**

1. **Deploy Nginx Proxy VM (10.252.108.30):**
   - Provisioning VM dedicated atau reuse existing HO VM
   - Install Nginx, generate SSL cert, configure upstream
   - Add DNS A record: `proxy.corp.pens.lab → 10.252.108.30`

2. **Koordinasi Backend Deployment (40 VM):**
   - Broadcast template setup (Apache atau Nginx) ke semua kelompok
   - Verify semua backend listening port 80: `nmap -p 80 10.252.108.151-190`
   - Collect backend index.php responses untuk verify identitas unik

3. **Load Testing Preparation:**
   - Install Apache Bench di proxy: `sudo apt install apache2-utils`
   - Prepare benchmark script untuk measure capacity setiap backend
   - Document hasil benchmark untuk weight tuning

4. **Monitoring Setup (optional):**
   - Install Grafana + Prometheus untuk real-time load balancing metrics
   - Setup Nginx stub_status module untuk monitoring upstream health
   - Create dashboard showing request distribution per backend

---

## Script Helper: Verify All Backends (Asisten)

Gunakan script ini untuk auto-verify 40 backends sebelum lab:

```bash
#!/bin/bash
# verify-backends.sh - Check health semua upstream backends

BACKENDS=(
  "10.252.108.151" "10.252.108.152" "10.252.108.153" # ... dst 40 IPs
)

echo "Backend,Status,ResponseTime,ServerHeader" > backend-health.csv

for ip in "${BACKENDS[@]}"; do
  echo "Checking $ip..."
  
  # Timeout 3s
  response=$(curl -s -o /dev/null -w "%{http_code},%{time_total}" --connect-timeout 3 http://$ip/)
  status=$(echo $response | cut -d, -f1)
  time=$(echo $response | cut -d, -f2)
  
  if [ "$status" == "200" ]; then
    server=$(curl -s -I http://$ip/ | grep -i "^server:" | cut -d: -f2 | xargs)
    echo "$ip,UP,$time,$server" >> backend-health.csv
  else
    echo "$ip,DOWN,N/A,N/A" >> backend-health.csv
  fi
done

echo "Done! Check backend-health.csv"
cat backend-health.csv
```

**Output CSV untuk review kapasitas dan status sebelum praktikum dimulai.**

---

## Load Balancing Method Comparison

| Method       | Config          | Traffic Distribution       | Session Support | Use Case                        |
|--------------|-----------------|----------------------------|-----------------|---------------------------------|
| Round-Robin  | (default)       | Sequential equal           | ❌              | Homogenous backends             |
| Least Conn   | `least_conn;`   | Based on active conn count | ❌              | Heterogenous load per request   |
| IP Hash      | `ip_hash;`      | Same client → same backend | ✅ (sticky IP)  | Session-based apps (no storage) |
| Weighted     | `weight=N;`     | Proportional to weight     | ❌              | Different backend capacities    |
| Hash (URI)   | `hash $uri;`    | Same URI → same backend    | ⚠️ (per URI)    | Cache efficiency                |

**Lab PENS:** Pakai `least_conn` dengan `weight` untuk optimal distribution ke 40 heterogenous backends.

---

**End of TABEL_KELOMPOK_NGINX.md**  
Siap distribusi ke 40 kelompok, 4 kelas paralel!  
Print tabel ini sebagai lampiran MINGGU_5_NGINX_PROXY.md
