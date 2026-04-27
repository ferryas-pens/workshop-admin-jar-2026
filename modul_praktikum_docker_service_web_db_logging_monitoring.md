# Modul Praktikum Docker Intro

**Disesuaikan dengan repository:** `ferryas-pens/docker-intro`  
**Konteks:** Workshop administrasi jaringan, containerization, service deployment, database, centralized logging, dan monitoring resource  
**Platform utama:** Ubuntu 22.04  
**Platform pendukung:** Windows 10 atau 11 dengan Docker Desktop dan WSL2 backend  
**Direktori kerja standar:** `~/docker-lab`

---

## Struktur Modul

| Modul | Topik | Fokus Praktikum | Durasi |
|---|---|---|---:|
| 1 | Docker dan Instalasi | Arsitektur Docker, instalasi, image, container, Dockerfile | 120 menit |
| 2 | Docker Service, Volume, dan Mount Point | Network, volume, bind mount, tmpfs, Docker Compose | 120 menit |
| 3 | Web Service Docker | Apache, Nginx, virtual host, SSL, reverse proxy, backend API | 120 menit |
| 4 | Database PostgreSQL | PostgreSQL, pgAdmin4, init script, CRUD, backup, restore | 120 menit |
| 5 | Logging Service dengan PostgreSQL | Fluent Bit, Docker logging driver, PostgreSQL log storage, SQL analysis | 120 menit |
| 6 | Grafana Monitoring Resource | cAdvisor, Prometheus, Grafana dashboard | 120 menit |

> Modul 1 sampai 5 mengikuti struktur repository `docker-intro`. Modul 6 ditambahkan sebagai ekstensi karena kebutuhan awal mencakup monitoring resource dengan Grafana.

---

## Konvensi Umum Praktikum

Gunakan direktori kerja:

```bash
mkdir -p ~/docker-lab
cd ~/docker-lab
```

Gunakan Docker Compose v2:

```bash
docker compose up -d
docker compose ps
docker compose logs -f
docker compose down
```

Gunakan perintah reset total hanya jika data boleh dihapus:

```bash
docker compose down -v
```

Image yang digunakan dalam modul:

```text
nginx:alpine
nginx:1.26-alpine
httpd:2.4-alpine
postgres:16-alpine
python:3.11-slim
python:3.11-alpine
fluent/fluent-bit:latest
dpage/pgadmin4:latest
prom/prometheus:latest
grafana/grafana:latest
gcr.io/cadvisor/cadvisor:latest
```

---

# Modul 1 — Docker dan Instalasi

## Tujuan Pembelajaran

Mahasiswa mampu:

1. Menjelaskan perbedaan Virtual Machine dan container.
2. Menjelaskan Docker Client, Docker Daemon, Docker Registry, image, container, network, volume, `containerd`, dan `runc`.
3. Menginstal Docker Engine pada Ubuntu 22.04.
4. Menginstal Docker Desktop pada Windows dengan WSL2 backend.
5. Menjalankan container `hello-world`, `nginx`, dan `ubuntu`.
6. Menggunakan perintah dasar Docker.
7. Membuat custom image sederhana menggunakan Dockerfile.

## Dasar Teori

| Aspek | Virtual Machine | Container |
|---|---|---|
| Isolasi | Full OS per instance | Shared kernel dan isolated userspace |
| Ukuran | Besar karena membawa guest OS | Lebih ringan |
| Startup | Relatif lambat | Cepat |
| Overhead | Hypervisor dan guest OS | Langsung di atas host kernel |
| Use case | Multi-OS dan strong isolation | Microservices, CI/CD, scaling |

Arsitektur Docker secara sederhana:

```text
Docker CLI atau Docker Desktop
        │
        ▼
Docker Daemon atau dockerd
        │
        ├─ Images
        ├─ Containers
        ├─ Networks
        ├─ Volumes
        └─ containerd dan runc
        │
        ▼
Host OS Kernel dengan namespaces, cgroups, dan union filesystem
```

Docker Desktop pada Windows memakai WSL2 agar container Linux berjalan dengan kernel Linux di lingkungan Windows.

## Langkah Praktikum

### 1. Persiapan Linux

```bash
ping -c 3 google.com
sudo apt update && sudo apt upgrade -y
```

### 2. Instalasi Docker Engine Ubuntu 22.04

```bash
sudo apt remove -y docker docker-engine docker.io containerd runc
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
```

Verifikasi:

```bash
docker version
docker info
sudo systemctl status docker --no-pager
docker run hello-world
```

### 3. Instalasi Docker Desktop Windows

Buka PowerShell sebagai Administrator:

```powershell
wsl --install
wsl --set-default-version 2
wsl --list --verbose
```

Lanjutkan dengan instalasi Docker Desktop, aktifkan WSL2 backend, lalu verifikasi:

```powershell
docker version
docker run hello-world
```

### 4. Operasi Dasar Docker Image

```bash
docker pull nginx
docker pull nginx:1.26
docker pull ubuntu:22.04
docker pull alpine:3.20
docker images
docker image inspect nginx
docker image history nginx
```

### 5. Menjalankan dan Mengelola Container

```bash
docker run -d --name web-server nginx
docker run -d --name web-public -p 8080:80 nginx
docker ps
docker logs web-server
docker stats
docker inspect web-server
```

Akses dari browser:

```text
http://localhost:8080
```

Container interaktif:

```bash
docker run -it --name ubuntu-test ubuntu:22.04 /bin/bash
```

Di dalam container:

```bash
cat /etc/os-release
apt update && apt install -y curl
exit
```

Lifecycle container:

```bash
docker stop web-server
docker start web-server
docker restart web-server
docker rm -f web-server web-public ubuntu-test
docker container prune
```

### 6. Membuat Custom Image Dockerfile

```bash
mkdir -p ~/docker-lab/custom-web
cd ~/docker-lab/custom-web
```

Buat `index.html`:

```bash
cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <title>Docker Lab PENS</title>
</head>
<body>
  <h1>Docker Lab PENS</h1>
  <p>Container berhasil berjalan.</p>
  <p>Server: Nginx on Docker</p>
  <p>Praktikum: Modul 1 Docker dan Instalasi</p>
</body>
</html>
EOF
```

Buat `Dockerfile`:

```bash
cat > Dockerfile <<'EOF'
FROM nginx:1.26-alpine
LABEL maintainer="admin@pens.ac.id"
LABEL description="Custom Nginx untuk praktikum Docker PENS"
LABEL version="1.0"
RUN rm -rf /usr/share/nginx/html/*
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
```

Build dan jalankan:

```bash
docker build -t pens-web:1.0 .
docker images | grep pens-web
docker run -d --name pens-app -p 9090:80 pens-web:1.0
curl http://localhost:9090
```

Akses:

```text
http://localhost:9090
```

Cek layer:

```bash
docker image history nginx:1.26-alpine
docker image history pens-web:1.0
```

## Pertanyaan Modul 1

1. Sebutkan minimal tiga perbedaan VM dan container.
2. Apa fungsi `containerd` dan `runc`?
3. Mengapa Docker membutuhkan kernel Linux?
4. Jelaskan perbedaan `docker run` dan `docker exec`.
5. Apa perbedaan `EXPOSE` di Dockerfile dan flag `-p` pada `docker run`?

## Checklist Modul 1

- [ ] Docker Engine terinstal.
- [ ] Docker Daemon aktif.
- [ ] `docker run hello-world` berhasil.
- [ ] Nginx container dapat diakses pada port 8080.
- [ ] Custom image `pens-web:1.0` berhasil dibuat.
- [ ] Container `pens-app` dapat diakses pada port 9090.

---

# Modul 2 — Docker Service, Volume, dan Mount Point

## Tujuan Pembelajaran

Mahasiswa mampu:

1. Mengelola Docker network.
2. Menghubungkan container dalam user-defined bridge network.
3. Menjelaskan volume, bind mount, dan tmpfs.
4. Menggunakan Docker Compose untuk multi-container application.
5. Menggunakan `depends_on` dan `healthcheck`.

## Dasar Teori

| Jenis Mount | Lokasi | Persisten | Cocok untuk |
|---|---|---|---|
| Volume | Dikelola Docker | Ya | Database dan persistent data |
| Bind mount | Path host | Ya | Source code dan konfigurasi |
| tmpfs | RAM | Tidak | Cache dan data sementara |

User-defined bridge network mendukung DNS resolution antar container berdasarkan nama service atau nama container.

## Langkah Praktikum

### 1. Docker Network

```bash
docker network ls
docker network inspect bridge
docker network create --driver bridge --subnet 172.20.0.0/16 lab-net
docker network inspect lab-net
```

Uji DNS antar container:

```bash
docker run -d --name server-a --network lab-net nginx:alpine
docker run -d --name server-b --network lab-net nginx:alpine
docker exec server-a ping -c 3 server-b
docker exec server-b ping -c 3 server-a
docker rm -f server-a server-b
```

### 2. Docker Volume

```bash
docker volume create data-vol
docker volume ls
docker volume inspect data-vol
docker run -d --name writer -v data-vol:/app/data alpine:3.20 sh -c "while true; do date >> /app/data/log.txt; sleep 5; done"
sleep 15
docker run --rm -v data-vol:/data alpine:3.20 cat /data/log.txt
docker rm -f writer
docker run --rm -v data-vol:/data alpine:3.20 cat /data/log.txt
```

Backup volume:

```bash
docker run --rm -v data-vol:/source:ro -v $(pwd):/backup alpine:3.20 tar czf /backup/data-vol-backup.tar.gz -C /source .
```

Restore volume:

```bash
docker volume create data-vol-restored
docker run --rm -v data-vol-restored:/target -v $(pwd):/backup:ro alpine:3.20 tar xzf /backup/data-vol-backup.tar.gz -C /target
docker run --rm -v data-vol-restored:/data alpine:3.20 cat /data/log.txt
```

### 3. Bind Mount

```bash
mkdir -p ~/docker-lab/web-dev/html
cd ~/docker-lab/web-dev
cat > html/index.html <<'EOF'
<h1>Hello dari Bind Mount</h1>
<p>Timestamp: VERSI-1</p>
EOF

docker run -d --name dev-server -p 8080:80 -v $(pwd)/html:/usr/share/nginx/html:ro nginx:alpine
curl http://localhost:8080
sed -i 's/VERSI-1/VERSI-2 diedit live/' html/index.html
curl http://localhost:8080
docker rm -f dev-server
```

### 4. tmpfs Mount

```bash
docker run -d --name tmpfs-demo --tmpfs /app/cache:size=64m alpine:3.20 sh -c "echo secret-data > /app/cache/token.txt && sleep 3600"
docker exec tmpfs-demo cat /app/cache/token.txt
docker stop tmpfs-demo && docker start tmpfs-demo
docker exec tmpfs-demo ls /app/cache
docker rm -f tmpfs-demo
```

### 5. Docker Compose Multi-Container

Buat project:

```bash
mkdir -p ~/docker-lab/compose-app/html ~/docker-lab/compose-app/app
cd ~/docker-lab/compose-app
```

Buat `html/index.html`:

```bash
cat > html/index.html <<'EOF'
<h1>Docker Compose Lab</h1>
<p>Nginx ke Flask ke PostgreSQL</p>
<p>Endpoint backend: /api/health</p>
EOF
```

Buat Flask app:

```bash
cat > app/requirements.txt <<'EOF'
flask==3.1.*
psycopg2-binary==2.9.*
EOF

cat > app/app.py <<'EOF'
import os, socket, datetime
from flask import Flask, jsonify
import psycopg2
app = Flask(__name__)
@app.route("/api/health")
def health():
    result = {"status":"ok", "hostname":socket.gethostname(), "timestamp":datetime.datetime.now().isoformat()}
    try:
        conn = psycopg2.connect(host=os.environ.get("DB_HOST","db"), dbname=os.environ.get("DB_NAME","labdb"), user=os.environ.get("DB_USER","labuser"), password=os.environ.get("DB_PASS","labpass123"))
        cur = conn.cursor()
        cur.execute("SELECT version();")
        result["database"] = cur.fetchone()[0]
        result["db_status"] = "connected"
        cur.close()
        conn.close()
    except Exception as e:
        result["db_status"] = str(e)
    return jsonify(result)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

cat > app/Dockerfile <<'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
EOF
```

Buat `nginx.conf`:

```bash
cat > nginx.conf <<'EOF'
server {
  listen 80;
  location / {
    root /usr/share/nginx/html;
    index index.html;
  }
  location /api/ {
    proxy_pass http://app:5000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
}
EOF
```

Buat `docker-compose.yml`:

```bash
cat > docker-compose.yml <<'EOF'
services:
  web:
    image: nginx:alpine
    container_name: lab-web
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    networks:
      - frontend
    depends_on:
      - app
    restart: unless-stopped
  app:
    build: ./app
    container_name: lab-app
    environment:
      - DB_HOST=db
      - DB_NAME=labdb
      - DB_USER=labuser
      - DB_PASS=labpass123
    networks:
      - frontend
      - backend
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
  db:
    image: postgres:16-alpine
    container_name: lab-db
    environment:
      POSTGRES_DB: labdb
      POSTGRES_USER: labuser
      POSTGRES_PASSWORD: labpass123
    volumes:
      - pg-data:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U labuser -d labdb"]
      interval: 5s
      timeout: 5s
      retries: 5
    restart: unless-stopped
volumes:
  pg-data:
networks:
  frontend:
  backend:
EOF
```

Jalankan:

```bash
docker compose up --build -d
docker compose ps
curl http://localhost:8080
curl http://localhost:8080/api/health
docker compose logs --tail 30
```

## Pertanyaan Modul 2

1. Apa perbedaan default bridge dan user-defined bridge?
2. Kapan menggunakan volume, bind mount, dan tmpfs?
3. Apa fungsi `depends_on` dan `healthcheck`?
4. Jelaskan alur request browser ke Nginx ke Flask ke PostgreSQL.
5. Apa efek `docker compose down -v`?

## Checklist Modul 2

- [ ] User-defined bridge berhasil dibuat.
- [ ] Container dapat resolve nama container lain.
- [ ] Named volume tetap menyimpan data setelah container dihapus.
- [ ] Bind mount menampilkan perubahan file host secara langsung.
- [ ] tmpfs hilang setelah restart container.
- [ ] Stack Compose tiga service berjalan.
- [ ] Endpoint `/api/health` menampilkan database connected.

---

# Modul 3 — Web Service Docker: Apache dan Nginx

## Tujuan Pembelajaran

Mahasiswa mampu:

1. Menjalankan Apache `httpd` dengan virtual host.
2. Menjalankan Nginx sebagai reverse proxy dan SSL termination.
3. Membuat self-signed certificate.
4. Menghubungkan Nginx, Apache, Flask, dan PostgreSQL dalam Docker Compose.
5. Memisahkan log per-site.

## Topologi

```text
Browser atau curl
  │
  ├─ http://site1.lab:8080
  └─ https://site1.lab:8443
        │
        ▼
Nginx reverse proxy
        ├─ site1.lab ke Apache site1
        ├─ site2.lab ke Apache site2
        └─ app.lab ke Flask API dan PostgreSQL
```

## Langkah Praktikum

### 1. Persiapan Project

```bash
mkdir -p ~/docker-lab/web-service/apache/sites ~/docker-lab/web-service/apache/html-site1 ~/docker-lab/web-service/apache/html-site2 ~/docker-lab/web-service/nginx ~/docker-lab/web-service/flask ~/docker-lab/web-service/certs ~/docker-lab/web-service/logs
cd ~/docker-lab/web-service
echo "127.0.0.1 site1.lab site2.lab app.lab" | sudo tee -a /etc/hosts
```

### 2. Apache Virtual Host

```bash
cat > apache/html-site1/index.html <<'EOF'
<h1>Site 1 Company Profile</h1>
<p>Virtual Host: site1.lab</p>
<p>Server: Apache httpd di Docker</p>
EOF

cat > apache/html-site2/index.html <<'EOF'
<h1>Site 2 Blog</h1>
<p>Virtual Host: site2.lab</p>
<p>Server: Apache httpd di Docker</p>
EOF
```

Buat `apache/sites/vhosts.conf`:

```bash
cat > apache/sites/vhosts.conf <<'EOF'
<VirtualHost *:80>
  ServerName site1.lab
  DocumentRoot /usr/local/apache2/htdocs/site1
  <Directory "/usr/local/apache2/htdocs/site1">
    AllowOverride None
    Require all granted
  </Directory>
  ErrorLog /var/log/apache2/site1-error.log
  CustomLog /var/log/apache2/site1-access.log combined
</VirtualHost>
<VirtualHost *:80>
  ServerName site2.lab
  DocumentRoot /usr/local/apache2/htdocs/site2
  <Directory "/usr/local/apache2/htdocs/site2">
    AllowOverride None
    Require all granted
  </Directory>
  ErrorLog /var/log/apache2/site2-error.log
  CustomLog /var/log/apache2/site2-access.log combined
</VirtualHost>
EOF
```

Buat `apache/Dockerfile`:

```bash
cat > apache/Dockerfile <<'EOF'
FROM httpd:2.4-alpine
RUN echo "Include conf/extra/vhosts.conf" >> /usr/local/apache2/conf/httpd.conf
RUN mkdir -p /var/log/apache2
COPY sites/vhosts.conf /usr/local/apache2/conf/extra/vhosts.conf
COPY html-site1/ /usr/local/apache2/htdocs/site1/
COPY html-site2/ /usr/local/apache2/htdocs/site2/
EXPOSE 80
EOF
```

### 3. SSL Certificate

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout certs/server.key -out certs/server.crt -subj "/C=ID/ST=Jawa Timur/L=Surabaya/O=PENS Lab/CN=*.lab" -addext "subjectAltName=DNS:*.lab,DNS:site1.lab,DNS:site2.lab,DNS:app.lab"
ls -la certs
```

### 4. Nginx Reverse Proxy

```bash
cat > nginx/default.conf <<'EOF'
upstream apache_backend { server apache-web:80; }
upstream flask_backend { server flask-app:5000; }
server {
  listen 80;
  server_name site1.lab site2.lab app.lab;
  return 301 https://$host$request_uri;
}
server {
  listen 443 ssl;
  server_name site1.lab;
  ssl_certificate /etc/nginx/certs/server.crt;
  ssl_certificate_key /etc/nginx/certs/server.key;
  location / {
    proxy_pass http://apache_backend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
  access_log /var/log/nginx/site1-access.log;
  error_log /var/log/nginx/site1-error.log;
}
server {
  listen 443 ssl;
  server_name site2.lab;
  ssl_certificate /etc/nginx/certs/server.crt;
  ssl_certificate_key /etc/nginx/certs/server.key;
  location / {
    proxy_pass http://apache_backend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
  access_log /var/log/nginx/site2-access.log;
  error_log /var/log/nginx/site2-error.log;
}
server {
  listen 443 ssl;
  server_name app.lab;
  ssl_certificate /etc/nginx/certs/server.crt;
  ssl_certificate_key /etc/nginx/certs/server.key;
  location / {
    proxy_pass http://flask_backend;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
  }
  access_log /var/log/nginx/app-access.log;
  error_log /var/log/nginx/app-error.log;
}
EOF
```

### 5. Flask Backend

```bash
cat > flask/requirements.txt <<'EOF'
flask==3.1.*
psycopg2-binary==2.9.*
EOF

cat > flask/app.py <<'EOF'
import os, socket, datetime
from flask import Flask, jsonify, request
import psycopg2
app = Flask(__name__)
def get_db():
    return psycopg2.connect(host=os.environ.get("DB_HOST","postgres-db"), dbname=os.environ.get("DB_NAME","labdb"), user=os.environ.get("DB_USER","labuser"), password=os.environ.get("DB_PASS","labpass123"))
@app.route("/")
def index():
    return jsonify({"service":"Flask Backend API", "hostname":socket.gethostname(), "timestamp":datetime.datetime.now().isoformat(), "client_ip":request.headers.get("X-Real-IP", request.remote_addr)})
@app.route("/api/health")
def health():
    result = {"status":"ok"}
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        result["database"] = cur.fetchone()[0]
        result["db_status"] = "connected"
        cur.close()
        conn.close()
    except Exception as e:
        result["db_status"] = str(e)
    return jsonify(result)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

cat > flask/Dockerfile <<'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
EOF
```

### 6. Docker Compose Web Stack

```bash
cat > docker-compose.yml <<'EOF'
services:
  nginx-proxy:
    image: nginx:alpine
    container_name: nginx-proxy
    ports:
      - "8080:80"
      - "8443:443"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
      - ./certs:/etc/nginx/certs:ro
      - ./logs/nginx:/var/log/nginx
    networks:
      - web-net
    depends_on:
      - apache-web
      - flask-app
  apache-web:
    build: ./apache
    container_name: apache-web
    volumes:
      - ./logs/apache:/var/log/apache2
    networks:
      - web-net
  flask-app:
    build: ./flask
    container_name: flask-app
    environment:
      DB_HOST: postgres-db
      DB_NAME: labdb
      DB_USER: labuser
      DB_PASS: labpass123
    networks:
      - web-net
      - db-net
    depends_on:
      postgres-db:
        condition: service_healthy
  postgres-db:
    image: postgres:16-alpine
    container_name: postgres-db
    environment:
      POSTGRES_DB: labdb
      POSTGRES_USER: labuser
      POSTGRES_PASSWORD: labpass123
    volumes:
      - pg-data:/var/lib/postgresql/data
    networks:
      - db-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U labuser -d labdb"]
      interval: 10s
      timeout: 5s
      retries: 5
volumes:
  pg-data:
networks:
  web-net:
  db-net:
EOF
```

Jalankan dan uji:

```bash
docker compose up --build -d
docker compose ps
curl -I http://site1.lab:8080
curl -k https://site1.lab:8443
curl -k https://site2.lab:8443
curl -k https://app.lab:8443/api/health
ls -la logs/nginx
ls -la logs/apache
```

## Pertanyaan Modul 3

1. Apa perbedaan document root Apache dan Nginx?
2. Mengapa reverse proxy memakai nama service container?
3. Apa fungsi self-signed certificate dalam praktikum ini?
4. Mengapa browser memberi warning pada self-signed certificate?
5. Jelaskan alur request ke `https://app.lab:8443/api/health`.

## Checklist Modul 3

- [ ] Hostname `site1.lab`, `site2.lab`, dan `app.lab` dikenali host.
- [ ] Certificate berhasil dibuat.
- [ ] Apache virtual host berjalan.
- [ ] Nginx reverse proxy berjalan pada port 8080 dan 8443.
- [ ] Endpoint app menampilkan database connected.
- [ ] Log per-site tersedia.

---

# Modul 4 — Database Service Docker: PostgreSQL

## Tujuan Pembelajaran

Mahasiswa mampu:

1. Menjalankan PostgreSQL 16 di Docker.
2. Menggunakan init script untuk membuat schema dan tabel.
3. Menggunakan Docker volume untuk persistent database.
4. Mengakses PostgreSQL melalui psql dan pgAdmin4.
5. Melakukan CRUD, backup, restore, dan monitoring dasar.

## Langkah Praktikum

### 1. Persiapan

```bash
mkdir -p ~/docker-lab/postgresql/init ~/docker-lab/postgresql/config ~/docker-lab/postgresql/backup
cd ~/docker-lab/postgresql
```

### 2. Init Script

```bash
cat > init/01-create-schema.sql <<'EOF'
CREATE SCHEMA IF NOT EXISTS app;
CREATE TABLE app.mahasiswa (
  id SERIAL PRIMARY KEY,
  nrp VARCHAR(15) UNIQUE NOT NULL,
  nama VARCHAR(100) NOT NULL,
  kelas CHAR(1),
  kelompok INTEGER,
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE app.matakuliah (
  id SERIAL PRIMARY KEY,
  kode VARCHAR(10) UNIQUE NOT NULL,
  nama VARCHAR(100) NOT NULL,
  sks INTEGER
);
CREATE TABLE app.nilai (
  id SERIAL PRIMARY KEY,
  mahasiswa_id INTEGER REFERENCES app.mahasiswa(id),
  matakuliah_id INTEGER REFERENCES app.matakuliah(id),
  nilai_angka NUMERIC(5,2),
  grade CHAR(2),
  semester VARCHAR(10)
);
CREATE TABLE app.activity_log (
  id BIGSERIAL PRIMARY KEY,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  level VARCHAR(10) DEFAULT 'INFO',
  source VARCHAR(50),
  message TEXT,
  metadata JSONB
);
CREATE INDEX idx_mahasiswa_kelas ON app.mahasiswa(kelas);
CREATE INDEX idx_activity_log_level ON app.activity_log(level);
CREATE INDEX idx_activity_log_metadata ON app.activity_log USING GIN(metadata);
INSERT INTO app.matakuliah (kode, nama, sks) VALUES ('JAR01','Administrasi Jaringan',3), ('SBD01','Sistem Basis Data',3), ('SO01','Sistem Operasi',2);
INSERT INTO app.mahasiswa (nrp, nama, kelas, kelompok, email) VALUES ('3122600001','Ahmad Fauzi','A',1,'ahmad@student.pens.ac.id'), ('3122600002','Budi Santoso','A',1,'budi@student.pens.ac.id'), ('3122600003','Citra Dewi','B',2,'citra@student.pens.ac.id');
INSERT INTO app.nilai (mahasiswa_id, matakuliah_id, nilai_angka, grade, semester) VALUES (1,1,85.50,'A','2025-1'), (2,1,92.00,'A','2025-1'), (3,2,70.25,'B','2025-1');
EOF
```

### 3. Custom PostgreSQL Config

```bash
cat > config/custom-postgresql.conf <<'EOF'
listen_addresses = '*'
max_connections = 50
shared_buffers = 128MB
work_mem = 4MB
logging_collector = on
log_directory = '/var/log/postgresql'
log_filename = 'postgresql-%Y-%m-%d.log'
log_statement = 'mod'
timezone = 'Asia/Jakarta'
log_timezone = 'Asia/Jakarta'
EOF
```

### 4. Compose PostgreSQL dan pgAdmin4

```bash
cat > docker-compose.yml <<'EOF'
services:
  db:
    image: postgres:16-alpine
    container_name: postgres-db
    environment:
      POSTGRES_DB: labdb
      POSTGRES_USER: labuser
      POSTGRES_PASSWORD: labpass123
      TZ: Asia/Jakarta
    ports:
      - "5432:5432"
    volumes:
      - pg-data:/var/lib/postgresql/data
      - ./init:/docker-entrypoint-initdb.d:ro
      - ./config/custom-postgresql.conf:/etc/postgresql/custom.conf:ro
      - ./backup:/backup
      - pg-logs:/var/log/postgresql
    command: postgres -c config_file=/etc/postgresql/custom.conf
    networks:
      - db-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U labuser -d labdb"]
      interval: 10s
      timeout: 5s
      retries: 5
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@pens.ac.id
      PGADMIN_DEFAULT_PASSWORD: admin123
      PGADMIN_LISTEN_PORT: 5050
    ports:
      - "5050:5050"
    volumes:
      - pgadmin-data:/var/lib/pgadmin
    networks:
      - db-net
    depends_on:
      db:
        condition: service_healthy
volumes:
  pg-data:
  pg-logs:
  pgadmin-data:
networks:
  db-net:
EOF
```

Deploy:

```bash
docker compose up -d
docker compose ps
docker compose logs db --tail 20
```

### 5. Verifikasi Database

```bash
sudo apt install -y postgresql-client
psql -h localhost -U labuser -d labdb
```

Query dari host atau `docker exec`:

```bash
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT * FROM app.mahasiswa;"
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT * FROM app.matakuliah;"
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT m.nrp, m.nama, mk.nama, n.nilai_angka FROM app.nilai n JOIN app.mahasiswa m ON n.mahasiswa_id = m.id JOIN app.matakuliah mk ON n.matakuliah_id = mk.id;"
```

Akses pgAdmin:

```text
URL: http://localhost:5050
Email: admin@pens.ac.id
Password: admin123
Host database saat Add Server: db
Port: 5432
Database: labdb
Username: labuser
Password: labpass123
```

### 6. CRUD dan JSONB

```bash
docker exec -it postgres-db psql -U labuser -d labdb -c "INSERT INTO app.mahasiswa (nrp, nama, kelas, kelompok, email) VALUES ('3122600010','Fajar Rizki','D',5,'fajar@student.pens.ac.id');"
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT * FROM app.mahasiswa WHERE kelas = 'A';"
docker exec -it postgres-db psql -U labuser -d labdb -c "UPDATE app.mahasiswa SET email = 'fajar.rizki@student.pens.ac.id' WHERE nrp = '3122600010';"
docker exec -it postgres-db psql -U labuser -d labdb -c "INSERT INTO app.activity_log (level, source, message, metadata) VALUES ('INFO','web-app','User login','{"user":"admin","ip":"192.168.1.10"}');"
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT * FROM app.activity_log;"
```

### 7. Backup dan Restore

```bash
docker exec postgres-db pg_dump -U labuser -d labdb -Fc -f /backup/labdb_backup.dump
docker exec postgres-db pg_dump -U labuser -d labdb -f /backup/labdb_backup.sql
ls -la backup
docker exec postgres-db psql -U labuser -d postgres -c "CREATE DATABASE labdb_restore;"
docker exec postgres-db pg_restore -U labuser -d labdb_restore /backup/labdb_backup.dump
docker exec postgres-db psql -U labuser -d labdb_restore -c "SELECT * FROM app.mahasiswa;"
```

### 8. Monitoring PostgreSQL

```bash
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size FROM pg_database;"
docker exec -it postgres-db psql -U labuser -d labdb -c "SELECT pid, usename, datname, client_addr, state, query FROM pg_stat_activity WHERE datname = 'labdb';"
docker exec postgres-db ls /var/log/postgresql
docker exec postgres-db sh -c 'ls -la /var/log/postgresql && tail -30 /var/log/postgresql/*.log'
```

## Pertanyaan Modul 4

1. Mengapa init script hanya berjalan saat volume data kosong?
2. Mengapa database membutuhkan volume?
3. Apa beda backup SQL plain text dan backup custom format?
4. Mengapa pgAdmin memakai host `db`, bukan `localhost`?
5. Apa manfaat index pada tabel log?

## Checklist Modul 4

- [ ] PostgreSQL running dan healthy.
- [ ] Schema `app` dan tabel tersedia.
- [ ] `psql` dari host dapat connect.
- [ ] pgAdmin4 dapat digunakan.
- [ ] CRUD berhasil.
- [ ] Backup dan restore berhasil.
- [ ] Data tetap ada setelah container dibuat ulang.

---

# Modul 5 — Logging Service Docker dengan PostgreSQL

## Tujuan Pembelajaran

Mahasiswa mampu:

1. Menjelaskan centralized logging.
2. Menjalankan Fluent Bit sebagai collector.
3. Menggunakan Docker logging driver `fluentd`.
4. Menyimpan log ke PostgreSQL.
5. Menganalisis log menggunakan SQL.

## Topologi

```text
Nginx, Flask, dan Log Generator
        │
        ▼
Docker logging driver fluentd
        │
        ▼
Fluent Bit port 24224
        │
        ▼
PostgreSQL schema logs
```

## Langkah Praktikum

### 1. Persiapan

```bash
mkdir -p ~/docker-lab/logging/fluent-bit ~/docker-lab/logging/generator ~/docker-lab/logging/init ~/docker-lab/logging/collector
cd ~/docker-lab/logging
```

### 2. Schema Logging

```bash
cat > init/01-logging-schema.sql <<'EOF'
CREATE SCHEMA IF NOT EXISTS logs;
CREATE TABLE logs.container_logs (
  id BIGSERIAL PRIMARY KEY,
  received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  timestamp TIMESTAMP,
  container_name VARCHAR(100),
  source VARCHAR(10),
  log_level VARCHAR(10),
  message TEXT,
  raw_log TEXT,
  metadata JSONB DEFAULT '{}'
);
CREATE INDEX idx_logs_timestamp ON logs.container_logs(timestamp);
CREATE INDEX idx_logs_container ON logs.container_logs(container_name);
CREATE INDEX idx_logs_level ON logs.container_logs(log_level);
CREATE INDEX idx_logs_metadata ON logs.container_logs USING GIN(metadata);
CREATE VIEW logs.recent_logs AS SELECT id, timestamp, container_name, log_level, message FROM logs.container_logs ORDER BY id DESC LIMIT 100;
CREATE VIEW logs.error_summary AS SELECT container_name, log_level, COUNT(*) AS total FROM logs.container_logs WHERE log_level IN ('ERROR','WARN','CRITICAL') GROUP BY container_name, log_level ORDER BY total DESC;
EOF
```

### 3. Fluent Bit Config

```bash
cat > fluent-bit/fluent-bit.conf <<'EOF'
[SERVICE]
    Flush        5
    Daemon       Off
    Log_Level    info
    Parsers_File parsers.conf
[INPUT]
    Name    forward
    Listen  0.0.0.0
    Port    24224
    Tag     docker.*
[FILTER]
    Name       parser
    Match      docker.*
    Key_Name   log
    Parser     docker_json
    Reserve_Data On
[OUTPUT]
    Name   stdout
    Match  docker.*
    Format json_lines
EOF

cat > fluent-bit/parsers.conf <<'EOF'
[PARSER]
    Name        docker_json
    Format      json
    Time_Key    time
    Time_Format %Y-%m-%dT%H:%M:%S.%L
    Time_Keep   On
EOF
```

### 4. Log Generator

```bash
cat > generator/generator.py <<'EOF'
import json, time, random, socket, datetime, os
hostname = socket.gethostname()
interval = float(os.environ.get("LOG_INTERVAL", "2"))
events = [
  ("INFO", "User login successful"),
  ("INFO", "Health check passed"),
  ("WARN", "Slow query detected"),
  ("ERROR", "Failed to connect to database"),
  ("CRITICAL", "Connection pool exhausted")
]
while True:
    level, message = random.choice(events)
    print(json.dumps({"timestamp":datetime.datetime.now().isoformat(), "level":level, "hostname":hostname, "service":"log-generator", "message":message}), flush=True)
    time.sleep(interval)
EOF

cat > generator/Dockerfile <<'EOF'
FROM python:3.11-alpine
WORKDIR /app
COPY generator.py .
CMD ["python", "generator.py"]
EOF
```

### 5. Collector Python ke PostgreSQL

```bash
cat > collector/collector.py <<'EOF'
import json, os, time
import psycopg2
log_file = os.getenv("LOG_FILE", "/logs/app.log")
def connect():
    while True:
        try:
            return psycopg2.connect(host=os.getenv("DB_HOST","postgres-db"), dbname=os.getenv("DB_NAME","labdb"), user=os.getenv("DB_USER","labuser"), password=os.getenv("DB_PASS","labpass123"))
        except Exception as e:
            print(e, flush=True)
            time.sleep(2)
def follow(path):
    while not os.path.exists(path):
        time.sleep(1)
    f = open(path, "r", encoding="utf-8")
    f.seek(0, os.SEEK_END)
    while True:
        line = f.readline()
        if line:
            yield line.strip()
        else:
            time.sleep(1)
conn = connect()
cur = conn.cursor()
for line in follow(log_file):
    try:
        event = json.loads(line)
        cur.execute("INSERT INTO logs.container_logs (timestamp, container_name, source, log_level, message, raw_log, metadata) VALUES (%s,%s,%s,%s,%s,%s,%s::jsonb)", (event.get("timestamp"), event.get("service"), "stdout", event.get("level"), event.get("message"), line, json.dumps(event)))
        conn.commit()
    except Exception as e:
        print(e, flush=True)
        conn.rollback()
EOF

cat > collector/Dockerfile <<'EOF'
FROM python:3.11-slim
WORKDIR /app
RUN pip install --no-cache-dir psycopg2-binary==2.9.*
COPY collector.py .
CMD ["python", "collector.py"]
EOF
```

### 6. Docker Compose Logging Stack

```bash
cat > docker-compose.yml <<'EOF'
services:
  postgres-db:
    image: postgres:16-alpine
    container_name: logging-postgres
    environment:
      POSTGRES_DB: labdb
      POSTGRES_USER: labuser
      POSTGRES_PASSWORD: labpass123
    ports:
      - "5433:5432"
    volumes:
      - pg-log-data:/var/lib/postgresql/data
      - ./init:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U labuser -d labdb"]
      interval: 5s
      timeout: 5s
      retries: 5
    networks:
      - log-net
  fluent-bit:
    image: fluent/fluent-bit:latest
    container_name: fluent-bit
    ports:
      - "24224:24224"
      - "24224:24224/udp"
    volumes:
      - ./fluent-bit/fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf:ro
      - ./fluent-bit/parsers.conf:/fluent-bit/etc/parsers.conf:ro
    networks:
      - log-net
  log-generator:
    build: ./generator
    container_name: log-generator
    environment:
      LOG_INTERVAL: 2
    volumes:
      - app-logs:/logs
    command: sh -c 'python generator.py | tee -a /logs/app.log'
    logging:
      driver: fluentd
      options:
        fluentd-address: localhost:24224
        tag: docker.log-generator
    depends_on:
      - fluent-bit
    networks:
      - log-net
  log-collector:
    build: ./collector
    container_name: log-collector
    environment:
      DB_HOST: postgres-db
      DB_NAME: labdb
      DB_USER: labuser
      DB_PASS: labpass123
      LOG_FILE: /logs/app.log
    volumes:
      - app-logs:/logs:ro
    depends_on:
      postgres-db:
        condition: service_healthy
      log-generator:
        condition: service_started
    networks:
      - log-net
volumes:
  pg-log-data:
  app-logs:
networks:
  log-net:
EOF
```

Jalankan dan analisis:

```bash
docker compose up --build -d
docker compose ps
docker compose logs fluent-bit --tail 30
docker compose logs log-collector --tail 30
docker exec -it logging-postgres psql -U labuser -d labdb -c "SELECT COUNT(*) FROM logs.container_logs;"
docker exec -it logging-postgres psql -U labuser -d labdb -c "SELECT log_level, COUNT(*) FROM logs.container_logs GROUP BY log_level ORDER BY COUNT(*) DESC;"
docker exec -it logging-postgres psql -U labuser -d labdb -c "SELECT * FROM logs.recent_logs LIMIT 10;"
docker exec -it logging-postgres psql -U labuser -d labdb -c "SELECT * FROM logs.error_summary;"
```

## Catatan Instruktur

Repository menggunakan konsep Fluent Bit dan PostgreSQL sebagai log storage. Pada beberapa image Fluent Bit, output plugin PostgreSQL belum tentu tersedia. Karena itu modul ini memakai dua jalur: Fluent Bit untuk memperlihatkan konsep Docker logging driver `fluentd`, dan collector Python untuk memastikan log benar-benar masuk ke PostgreSQL pada lingkungan lab.

## Pertanyaan Modul 5

1. Mengapa log container sebaiknya dikirim ke centralized logging?
2. Apa perbedaan `json-file` dan `fluentd` logging driver?
3. Mengapa log aplikasi container sebaiknya dikirim ke stdout?
4. Apa manfaat JSONB untuk metadata log?
5. Apa risiko menyimpan semua log tanpa retention policy?

## Checklist Modul 5

- [ ] PostgreSQL logging running.
- [ ] Schema `logs` tersedia.
- [ ] Fluent Bit menerima log.
- [ ] Log generator menghasilkan log multi-level.
- [ ] Log masuk ke PostgreSQL.
- [ ] Query distribusi log per level berhasil.
- [ ] View `recent_logs` dan `error_summary` berhasil.

---

# Modul 6 — Grafana Service Docker untuk Monitoring Resource

## Tujuan Pembelajaran

Mahasiswa mampu:

1. Menjelaskan perbedaan log dan metrik.
2. Menjalankan cAdvisor untuk membaca metrik container.
3. Menjalankan Prometheus sebagai time-series metrics storage.
4. Menjalankan Grafana sebagai dashboard.
5. Membuat dashboard CPU, memory, network, dan filesystem.

## Topologi

```text
Docker container metrics
        │
        ▼
cAdvisor metrics endpoint
        │
        ▼
Prometheus scrape
        │
        ▼
Grafana dashboard
```

## Langkah Praktikum

### 1. Persiapan

```bash
mkdir -p ~/docker-lab/monitoring/prometheus ~/docker-lab/monitoring/grafana/provisioning/datasources
cd ~/docker-lab/monitoring
```

### 2. Prometheus Config

```bash
cat > prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 5s
scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["prometheus:9090"]
  - job_name: "cadvisor"
    static_configs:
      - targets: ["cadvisor:8080"]
EOF
```

### 3. Grafana Datasource

```bash
cat > grafana/provisioning/datasources/datasource.yml <<'EOF'
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOF
```

### 4. Compose Monitoring Stack

```bash
cat > docker-compose.yml <<'EOF'
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: monitoring-cadvisor
    ports:
      - "8082:8080"
    privileged: true
    devices:
      - /dev/kmsg:/dev/kmsg
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    restart: unless-stopped
  prometheus:
    image: prom/prometheus:latest
    container_name: monitoring-prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
    restart: unless-stopped
  grafana:
    image: grafana/grafana:latest
    container_name: monitoring-grafana
    ports:
      - "3000:3000"
    environment:
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: admin123
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning:ro
    depends_on:
      - prometheus
    restart: unless-stopped
volumes:
  prometheus-data:
  grafana-data:
EOF
```

Jalankan:

```bash
docker compose up -d
docker compose ps
```

Akses:

```text
cAdvisor: http://localhost:8082
Prometheus: http://localhost:9090
Grafana: http://localhost:3000
Grafana login: admin / admin123
```

Query Prometheus:

```promql
up
container_memory_usage_bytes{name!=""}
rate(container_cpu_usage_seconds_total{name!=""}[1m])
rate(container_network_receive_bytes_total{name!=""}[1m])
```

Panel Grafana yang wajib dibuat:

```promql
rate(container_cpu_usage_seconds_total{name!=""}[1m])
container_memory_usage_bytes{name!=""}
rate(container_network_receive_bytes_total{name!=""}[1m])
rate(container_fs_reads_bytes_total{name!=""}[1m])
```

Workload test:

```bash
docker run -d --name cpu-test alpine sh -c "while true; do :; done"
docker rm -f cpu-test
docker run -d --name web-load -p 8090:80 nginx:alpine
for i in $(seq 1 100); do curl -s http://localhost:8090 > /dev/null; done
docker rm -f web-load
```

## Pertanyaan Modul 6

1. Apa perbedaan log dan metrik?
2. Apa fungsi cAdvisor?
3. Apa fungsi Prometheus?
4. Apa fungsi Grafana?
5. Metrik apa yang penting untuk mendeteksi container bermasalah?

## Checklist Modul 6

- [ ] cAdvisor dapat diakses.
- [ ] Prometheus dapat diakses.
- [ ] Grafana dapat diakses.
- [ ] Datasource Prometheus otomatis tersedia.
- [ ] Dashboard minimal empat panel berhasil dibuat.
- [ ] Workload CPU dan network terlihat pada dashboard.

---

# Troubleshooting Umum

| Gejala | Kemungkinan Penyebab | Solusi |
|---|---|---|
| `permission denied` saat `docker ps` | User belum masuk grup Docker | Tambahkan user ke grup `docker`, lalu login ulang |
| `Cannot connect to Docker daemon` | Service Docker belum aktif | Jalankan `sudo systemctl start docker` |
| `docker compose` tidak ditemukan | Compose plugin belum terinstal | Instal `docker-compose-plugin` |
| Port conflict | Port sudah dipakai service lain | Cek `docker ps`, ubah port mapping |
| Nginx 502 Bad Gateway | Backend belum running | Cek `docker compose logs` |
| PostgreSQL init script tidak berjalan | Volume lama sudah berisi data | Reset dengan `docker compose down -v` bila aman |
| pgAdmin tidak connect | Host database salah | Gunakan nama service `db` atau `postgres-db` |
| Log tidak masuk PostgreSQL | Collector belum berjalan | Cek `docker compose logs log-collector` |
| Grafana tidak membaca Prometheus | Datasource salah | Pastikan URL datasource `http://prometheus:9090` |
| cAdvisor bermasalah di Windows atau WSL | Mount host berbeda dari Linux native | Gunakan Linux host atau Linux VM |

---

# Format Laporan Praktikum

Setiap modul dikumpulkan sebagai PDF singkat berisi:

1. Cover: judul, nama, NRP, kelas, tanggal, OS host, versi Docker.
2. Screenshot perintah utama dan service yang berhasil diakses.
3. Hasil query atau dashboard.
4. Jawaban pertanyaan Post-Lab.
5. Kendala dan solusi.
6. Kesimpulan.

---

# Rubrik Penilaian

| Komponen | Bobot |
|---|---:|
| Instalasi dan verifikasi Docker | 10% |
| Docker CLI, image, container, lifecycle | 15% |
| Network, volume, bind mount, tmpfs, Compose | 15% |
| Apache, Nginx, SSL, reverse proxy | 15% |
| PostgreSQL, CRUD, backup, restore | 15% |
| Logging pipeline dan analisis SQL | 15% |
| Grafana monitoring resource | 10% |
| Dokumentasi dan analisis | 5% |

---

# Penutup

Modul ini mengikuti alur repository `docker-intro`: dimulai dari instalasi Docker, pengelolaan container, network dan mount point, deployment web service Apache dan Nginx, PostgreSQL sebagai database service, centralized logging dengan PostgreSQL, lalu monitoring resource dengan Grafana. Setelah menyelesaikan seluruh modul, mahasiswa diharapkan mampu membangun, menjalankan, mengamati, dan menganalisis service berbasis container secara sistematis.

