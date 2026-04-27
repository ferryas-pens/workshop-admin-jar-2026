# Modul Praktikum: Docker, Service, Web Server, Database, Logging, dan Monitoring Resource

## Identitas Modul

**Mata kuliah / workshop:** Administrasi Jaringan, Sistem Terdistribusi, DevOps Dasar, atau Keamanan Infrastruktur  
**Topik:** Docker untuk deployment service berbasis container  
**Target peserta:** Mahasiswa yang sudah memahami dasar sistem operasi, TCP/IP, terminal Linux/PowerShell, dan konsep client-server  
**Durasi total yang disarankan:** 4–6 pertemuan praktikum, masing-masing 2–3 jam  
**Platform:** Windows 10/11 dengan Docker Desktop + WSL 2, atau Linux Ubuntu/Debian/Fedora/RHEL-compatible  
**Mode kerja:** Individu atau kelompok kecil 2 orang

---

## Capaian Pembelajaran Praktikum

Setelah menyelesaikan modul ini, mahasiswa mampu:

1. Menjelaskan fungsi Docker Engine, image, container, volume, bind mount, network, dan Docker Compose.
2. Menginstal dan memverifikasi Docker pada Windows dan Linux.
3. Menjalankan service sederhana di Docker serta mengelola lifecycle container.
4. Menggunakan mount point untuk persistent storage dan file sharing antara host dan container.
5. Menjalankan web service Apache HTTP Server dan Nginx di container.
6. Menjalankan PostgreSQL di Docker dengan persistent volume.
7. Membangun pipeline logging sederhana dari service container ke PostgreSQL.
8. Menjalankan Grafana, Prometheus, dan cAdvisor untuk monitoring resource container.
9. Menganalisis log, status container, penggunaan CPU, memori, I/O, dan network.
10. Menerapkan praktik dasar keamanan Docker untuk lingkungan praktikum.

---

## Peta Praktikum

| Praktikum | Topik | Output Utama |
|---|---|---|
| 1 | Instalasi Docker di Windows dan Linux | Docker aktif dan tervalidasi dengan `hello-world` |
| 2 | Service Docker dan mount point | Container aktif, volume dan bind mount berfungsi |
| 3 | Web service Apache dan Nginx | Dua web server berjalan di port berbeda |
| 4 | PostgreSQL service di Docker | Database persisten dan dapat diakses dengan `psql` |
| 5 | Logging service Docker dengan PostgreSQL | Log aplikasi masuk ke tabel PostgreSQL |
| 6 | Grafana Docker untuk monitoring resource | Dashboard Grafana membaca metrik dari Prometheus/cAdvisor |

---

## Standar Penamaan Praktikum

Agar hasil praktikum rapi, gunakan satu direktori kerja:

```bash
mkdir docker-praktikum
cd docker-praktikum
```

Struktur akhir yang akan dibuat:

```text
docker-praktikum/
├── 01-web/
│   ├── apache-html/
│   │   └── index.html
│   ├── nginx-html/
│   │   └── index.html
│   └── compose.yaml
├── 02-postgres/
│   └── compose.yaml
├── 03-logging-postgres/
│   ├── app.py
│   ├── compose.yaml
│   ├── collector/
│   │   ├── Dockerfile
│   │   └── collector.py
│   └── db/
│       └── init.sql
└── 04-monitoring/
    ├── compose.yaml
    ├── prometheus/
    │   └── prometheus.yml
    └── grafana/
        └── provisioning/
            └── datasources/
                └── datasource.yml
```

---

# Praktikum 1 — Docker dan Instalasinya di Windows dan Linux

## 1.1 Tujuan

Mahasiswa mampu menginstal Docker, menjalankan container uji, dan memahami komponen dasar Docker.

## 1.2 Teori Singkat

Docker adalah platform untuk menjalankan aplikasi dalam unit terisolasi bernama **container**. Container menggunakan image sebagai template. Docker membantu aplikasi berjalan konsisten di berbagai lingkungan karena dependensi, runtime, dan konfigurasi dapat dikemas bersama.

Komponen penting:

- **Docker Engine:** runtime untuk membangun dan menjalankan container.
- **Docker CLI:** perintah `docker` yang digunakan dari terminal.
- **Docker Desktop:** paket lengkap untuk Windows, macOS, dan Linux desktop.
- **Image:** template read-only untuk membuat container.
- **Container:** instance berjalan dari image.
- **Registry:** repositori image, misalnya Docker Hub.
- **Docker Compose:** alat untuk menjalankan aplikasi multi-container menggunakan file YAML.

## 1.3 Instalasi di Windows

### Prasyarat Windows

Gunakan salah satu lingkungan berikut:

- Windows 10/11 64-bit.
- Virtualization aktif di BIOS/UEFI.
- WSL 2 aktif dan terpasang.
- Akun user memiliki hak instalasi aplikasi.

### Langkah Instalasi Windows

1. Aktifkan WSL 2 dari PowerShell Administrator:

```powershell
wsl --install
```

2. Restart Windows bila diminta.
3. Instal distribusi Linux, misalnya Ubuntu, dari Microsoft Store bila belum tersedia.
4. Unduh dan instal Docker Desktop for Windows.
5. Buka Docker Desktop.
6. Pastikan opsi **Use the WSL 2 based engine** aktif.
7. Buka PowerShell atau Windows Terminal, lalu jalankan:

```powershell
docker --version
docker compose version
docker run hello-world
```

### Output yang Diharapkan

Perintah `docker run hello-world` menampilkan pesan bahwa instalasi Docker bekerja dengan benar.

## 1.4 Instalasi di Linux Ubuntu/Debian

> Catatan: Perintah berikut cocok untuk Ubuntu/Debian modern. Untuk distribusi lain, sesuaikan package manager dan repository.

### Langkah Instalasi

1. Hapus paket lama bila ada:

```bash
sudo apt remove -y docker docker-engine docker.io containerd runc
```

2. Instal paket pendukung:

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
```

3. Tambahkan GPG key Docker:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

4. Tambahkan repository Docker:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5. Instal Docker Engine dan plugin Compose:

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

6. Aktifkan service Docker:

```bash
sudo systemctl enable --now docker
sudo systemctl status docker --no-pager
```

7. Jalankan verifikasi:

```bash
sudo docker run hello-world
```

8. Agar user biasa dapat menjalankan Docker tanpa `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

9. Uji ulang tanpa `sudo`:

```bash
docker run hello-world
```

## 1.5 Instalasi Ringkas di Fedora/RHEL-compatible

Untuk Fedora atau RHEL-compatible, gunakan pendekatan package manager `dnf`:

```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo docker run hello-world
```

Tambahkan user ke grup Docker bila diperlukan:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## 1.6 Pemeriksaan Awal

Jalankan:

```bash
docker version
docker info
docker compose version
docker image ls
docker container ls -a
```

Pertanyaan analisis:

1. Apa perbedaan `docker image ls` dan `docker container ls -a`?
2. Mengapa Docker Desktop di Windows membutuhkan WSL 2?
3. Apa risiko keamanan menambahkan user ke grup `docker`?

---

# Praktikum 2 — Service di Docker dan Mount Point

## 2.1 Tujuan

Mahasiswa mampu menjalankan service container, mengelola lifecycle container, serta memahami volume dan bind mount.

## 2.2 Teori Singkat

Service dalam konteks Docker dapat dipahami sebagai proses aplikasi yang berjalan di container, misalnya web server, database, queue, collector, atau monitoring agent.

Lifecycle container umum:

```text
image pull/build → container create → start → running → stop/restart → remove
```

Jenis mount yang digunakan pada praktikum:

1. **Named volume**  
   Dikelola oleh Docker. Cocok untuk data persisten seperti database.

2. **Bind mount**  
   Direktori/file host dipetakan langsung ke container. Cocok untuk source code, konfigurasi, atau konten web yang sering diedit.

## 2.3 Menjalankan Service Container Sederhana

Jalankan container Nginx:

```bash
docker run -d --name svc-nginx -p 8080:80 nginx:latest
```

Cek status:

```bash
docker ps
```

Akses dari browser:

```text
http://localhost:8080
```

Cek log:

```bash
docker logs svc-nginx
```

Masuk ke shell container:

```bash
docker exec -it svc-nginx /bin/sh
```

Keluar dari shell:

```bash
exit
```

Stop, start, dan hapus container:

```bash
docker stop svc-nginx
docker start svc-nginx
docker rm -f svc-nginx
```

## 2.4 Named Volume

Buat volume:

```bash
docker volume create labdata
```

Tulis file ke volume menggunakan container sementara:

```bash
docker run --rm \
  --mount source=labdata,target=/data \
  alpine sh -c "date > /data/hasil.txt && echo 'data praktikum' >> /data/hasil.txt"
```

Baca kembali data dari volume:

```bash
docker run --rm \
  --mount source=labdata,target=/data \
  alpine cat /data/hasil.txt
```

Inspeksi volume:

```bash
docker volume inspect labdata
```

Hapus volume bila tidak diperlukan:

```bash
docker volume rm labdata
```

## 2.5 Bind Mount

Buat direktori host:

```bash
mkdir -p bind-demo/html
cat > bind-demo/html/index.html <<'EOF'
<h1>Bind Mount Docker</h1>
<p>Konten ini berasal dari host.</p>
EOF
```

Jalankan Nginx dengan bind mount:

```bash
docker run -d --name bind-nginx \
  -p 8081:80 \
  --mount type=bind,source="$(pwd)/bind-demo/html",target=/usr/share/nginx/html,readonly \
  nginx:latest
```

Akses:

```text
http://localhost:8081
```

Ubah file di host:

```bash
cat > bind-demo/html/index.html <<'EOF'
<h1>Konten Berubah</h1>
<p>Perubahan dilakukan dari host dan langsung terlihat di container.</p>
EOF
```

Refresh browser.

Hapus container:

```bash
docker rm -f bind-nginx
```

## 2.6 Analisis

1. Apa perbedaan named volume dan bind mount?
2. Pada kasus database, mengapa named volume lebih disarankan?
3. Mengapa bind mount sebaiknya diberi opsi `readonly` jika container hanya perlu membaca file?
4. Apa yang terjadi bila direktori host yang di-bind mount kosong, tetapi direktori target container sudah berisi file?

---

# Praktikum 3 — Web Service di Docker: Apache dan Nginx

## 3.1 Tujuan

Mahasiswa mampu menjalankan dua web service berbeda, yaitu Apache HTTP Server dan Nginx, serta memahami port mapping dan Docker Compose.

## 3.2 Teori Singkat

Apache HTTP Server dan Nginx adalah web server yang banyak digunakan. Dalam Docker:

- Apache official image umumnya menggunakan nama image `httpd`.
- Nginx official image menggunakan nama image `nginx`.
- Port container biasanya `80`, lalu dipetakan ke port host berbeda agar tidak konflik.

Contoh port mapping:

```text
Host 8080 → Container Apache 80
Host 8081 → Container Nginx 80
```

## 3.3 Persiapan Direktori

```bash
mkdir -p 01-web/apache-html 01-web/nginx-html
cd 01-web
```

Buat halaman Apache:

```bash
cat > apache-html/index.html <<'EOF'
<!doctype html>
<html>
<head><title>Apache Docker</title></head>
<body>
  <h1>Apache HTTP Server di Docker</h1>
  <p>Service ini berjalan dari image httpd.</p>
</body>
</html>
EOF
```

Buat halaman Nginx:

```bash
cat > nginx-html/index.html <<'EOF'
<!doctype html>
<html>
<head><title>Nginx Docker</title></head>
<body>
  <h1>Nginx di Docker</h1>
  <p>Service ini berjalan dari image nginx.</p>
</body>
</html>
EOF
```

## 3.4 Menjalankan Apache dengan Docker CLI

```bash
docker run -d --name web-apache \
  -p 8080:80 \
  --mount type=bind,source="$(pwd)/apache-html",target=/usr/local/apache2/htdocs,readonly \
  httpd:latest
```

Akses:

```text
http://localhost:8080
```

Cek log:

```bash
docker logs web-apache
```

## 3.5 Menjalankan Nginx dengan Docker CLI

```bash
docker run -d --name web-nginx \
  -p 8081:80 \
  --mount type=bind,source="$(pwd)/nginx-html",target=/usr/share/nginx/html,readonly \
  nginx:latest
```

Akses:

```text
http://localhost:8081
```

Cek log:

```bash
docker logs web-nginx
```

Hapus container CLI sebelum masuk ke Compose:

```bash
docker rm -f web-apache web-nginx
```

## 3.6 Menjalankan Apache dan Nginx dengan Docker Compose

Buat file `compose.yaml`:

```bash
cat > compose.yaml <<'EOF'
services:
  apache:
    image: httpd:latest
    container_name: lab-apache
    ports:
      - "8080:80"
    volumes:
      - ./apache-html:/usr/local/apache2/htdocs:ro

  nginx:
    image: nginx:latest
    container_name: lab-nginx
    ports:
      - "8081:80"
    volumes:
      - ./nginx-html:/usr/share/nginx/html:ro
EOF
```

Jalankan:

```bash
docker compose up -d
```

Cek service:

```bash
docker compose ps
```

Lihat log:

```bash
docker compose logs -f
```

Akses:

```text
http://localhost:8080
http://localhost:8081
```

Stop dan hapus service:

```bash
docker compose down
```

## 3.7 Tugas Praktikum

1. Ubah konten `apache-html/index.html` dan `nginx-html/index.html`.
2. Tambahkan file `info.html` pada kedua service.
3. Akses:

```text
http://localhost:8080/info.html
http://localhost:8081/info.html
```

4. Bandingkan format log Apache dan Nginx.
5. Dokumentasikan perbedaan lokasi document root Apache dan Nginx di container.

---

# Praktikum 4 — Database Service di Docker: PostgreSQL

## 4.1 Tujuan

Mahasiswa mampu menjalankan PostgreSQL sebagai service container, menggunakan persistent volume, dan melakukan operasi database dasar.

## 4.2 Teori Singkat

Database container membutuhkan persistent storage. Jika container dihapus tanpa volume, data database ikut hilang. Oleh karena itu, PostgreSQL di Docker harus memakai named volume atau storage eksternal.

Variabel lingkungan penting pada image PostgreSQL:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`

Data utama PostgreSQL di container official image berada di:

```text
/var/lib/postgresql/data
```

## 4.3 Persiapan Direktori

```bash
cd ../
mkdir -p 02-postgres
cd 02-postgres
```

## 4.4 Menjalankan PostgreSQL dengan Docker CLI

```bash
docker volume create pgdata
```

```bash
docker run -d --name lab-postgres \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin123 \
  -e POSTGRES_DB=kampus \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:latest
```

Cek log:

```bash
docker logs lab-postgres
```

Masuk ke `psql`:

```bash
docker exec -it lab-postgres psql -U admin -d kampus
```

Jalankan SQL:

```sql
CREATE TABLE mahasiswa (
  nrp VARCHAR(20) PRIMARY KEY,
  nama TEXT NOT NULL,
  kelas TEXT NOT NULL
);

INSERT INTO mahasiswa (nrp, nama, kelas) VALUES
('31240001', 'Andi', 'TI-1A'),
('31240002', 'Budi', 'TI-1A');

SELECT * FROM mahasiswa;
```

Keluar dari `psql`:

```sql
\q
```

Uji persistensi:

```bash
docker rm -f lab-postgres
```

Jalankan ulang dengan volume yang sama:

```bash
docker run -d --name lab-postgres \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin123 \
  -e POSTGRES_DB=kampus \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:latest
```

Cek data:

```bash
docker exec -it lab-postgres psql -U admin -d kampus -c "SELECT * FROM mahasiswa;"
```

Hapus container sebelum Compose:

```bash
docker rm -f lab-postgres
```

## 4.5 Menjalankan PostgreSQL dengan Docker Compose

Buat `compose.yaml`:

```bash
cat > compose.yaml <<'EOF'
services:
  postgres:
    image: postgres:latest
    container_name: lab-postgres-compose
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin123
      POSTGRES_DB: kampus
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
EOF
```

Jalankan:

```bash
docker compose up -d
```

Cek service:

```bash
docker compose ps
```

Akses database:

```bash
docker compose exec postgres psql -U admin -d kampus
```

## 4.6 Backup dan Restore Sederhana

Backup:

```bash
docker compose exec postgres pg_dump -U admin kampus > backup-kampus.sql
```

Restore ke database yang sama atau database baru:

```bash
cat backup-kampus.sql | docker compose exec -T postgres psql -U admin -d kampus
```

Stop service:

```bash
docker compose down
```

Hapus juga volume bila ingin reset total:

```bash
docker compose down -v
```

## 4.7 Tugas Praktikum

1. Buat tabel `aset_it` dengan kolom:
   - `id`
   - `hostname`
   - `ip_address`
   - `lokasi`
   - `status`
2. Masukkan minimal 5 data.
3. Tampilkan aset dengan status `aktif`.
4. Lakukan backup database.
5. Hapus container, jalankan ulang, lalu buktikan data masih tersedia.

---

# Praktikum 5 — Logging Service Docker dengan PostgreSQL

## 5.1 Tujuan

Mahasiswa mampu membangun pipeline logging sederhana menggunakan beberapa service Docker:

```text
log-generator container → shared volume log file → log-collector container → PostgreSQL container
```

## 5.2 Catatan Desain

Docker memiliki logging system bawaan melalui `docker logs` dan logging driver. Namun Docker tidak menyediakan logging driver bawaan langsung ke PostgreSQL. Karena itu, praktikum ini menggunakan pendekatan edukatif:

1. Service aplikasi menghasilkan log JSON.
2. Log ditulis ke file pada shared volume.
3. Service collector membaca log tersebut.
4. Collector memasukkan log ke tabel PostgreSQL.

Dengan pendekatan ini, mahasiswa mempelajari konsep:

- multi-service container,
- shared volume,
- log format JSON,
- ingestion pipeline,
- penyimpanan log terstruktur di database.

## 5.3 Persiapan Direktori

```bash
cd ../
mkdir -p 03-logging-postgres/collector 03-logging-postgres/db
cd 03-logging-postgres
```

## 5.4 Membuat Tabel Log

Buat file `db/init.sql`:

```bash
cat > db/init.sql <<'EOF'
CREATE TABLE IF NOT EXISTS container_logs (
  id BIGSERIAL PRIMARY KEY,
  event_time TIMESTAMPTZ NOT NULL,
  service_name TEXT NOT NULL,
  level TEXT NOT NULL,
  message TEXT NOT NULL,
  raw JSONB NOT NULL,
  inserted_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_container_logs_event_time
ON container_logs(event_time);

CREATE INDEX IF NOT EXISTS idx_container_logs_level
ON container_logs(level);
EOF
```

## 5.5 Membuat Aplikasi Penghasil Log

Buat file `app.py`:

```bash
cat > app.py <<'EOF'
import json
import os
import random
import time
from datetime import datetime, timezone

LOG_PATH = os.getenv("LOG_PATH", "/logs/app.log")
SERVICE_NAME = os.getenv("SERVICE_NAME", "log-generator")

levels = ["INFO", "INFO", "INFO", "WARNING", "ERROR"]
messages = [
    "request processed",
    "user login simulated",
    "database query simulated",
    "high latency simulated",
    "temporary error simulated"
]

os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)

counter = 0
while True:
    counter += 1
    event = {
        "event_time": datetime.now(timezone.utc).isoformat(),
        "service_name": SERVICE_NAME,
        "level": random.choice(levels),
        "message": random.choice(messages),
        "sequence": counter
    }

    line = json.dumps(event, ensure_ascii=False)
    print(line, flush=True)

    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(line + "\n")
        f.flush()

    time.sleep(2)
EOF
```

## 5.6 Membuat Collector

Buat file `collector/Dockerfile`:

```bash
cat > collector/Dockerfile <<'EOF'
FROM python:3.12-slim

WORKDIR /app
RUN pip install --no-cache-dir "psycopg[binary]"
COPY collector.py /app/collector.py

CMD ["python", "/app/collector.py"]
EOF
```

Buat file `collector/collector.py`:

```bash
cat > collector/collector.py <<'EOF'
import json
import os
import time
from datetime import datetime

import psycopg

LOG_PATH = os.getenv("LOG_PATH", "/logs/app.log")
DB_HOST = os.getenv("DB_HOST", "postgres")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "logsdb")
DB_USER = os.getenv("DB_USER", "logger")
DB_PASSWORD = os.getenv("DB_PASSWORD", "logger123")


def connect_with_retry():
    dsn = f"host={DB_HOST} port={DB_PORT} dbname={DB_NAME} user={DB_USER} password={DB_PASSWORD}"
    while True:
        try:
            conn = psycopg.connect(dsn)
            conn.autocommit = True
            print("collector: connected to PostgreSQL", flush=True)
            return conn
        except Exception as exc:
            print(f"collector: waiting for PostgreSQL: {exc}", flush=True)
            time.sleep(2)


def insert_log(conn, event):
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO container_logs (event_time, service_name, level, message, raw)
            VALUES (%s, %s, %s, %s, %s::jsonb)
            """,
            (
                event.get("event_time", datetime.utcnow().isoformat()),
                event.get("service_name", "unknown"),
                event.get("level", "INFO"),
                event.get("message", ""),
                json.dumps(event),
            ),
        )


def follow_file(path):
    print(f"collector: watching {path}", flush=True)
    while not os.path.exists(path):
        print("collector: log file not found yet", flush=True)
        time.sleep(1)

    with open(path, "r", encoding="utf-8") as f:
        f.seek(0, os.SEEK_END)
        while True:
            line = f.readline()
            if not line:
                time.sleep(1)
                continue
            yield line.strip()


def main():
    conn = connect_with_retry()
    for line in follow_file(LOG_PATH):
        if not line:
            continue
        try:
            event = json.loads(line)
            insert_log(conn, event)
            print(f"collector: inserted {event.get('level')} seq={event.get('sequence')}", flush=True)
        except Exception as exc:
            print(f"collector: failed to process line: {exc}; line={line}", flush=True)
            try:
                conn.close()
            except Exception:
                pass
            conn = connect_with_retry()


if __name__ == "__main__":
    main()
EOF
```

## 5.7 Membuat Docker Compose Logging

Buat file `compose.yaml`:

```bash
cat > compose.yaml <<'EOF'
services:
  postgres:
    image: postgres:latest
    container_name: logging-postgres
    environment:
      POSTGRES_USER: logger
      POSTGRES_PASSWORD: logger123
      POSTGRES_DB: logsdb
    ports:
      - "5433:5432"
    volumes:
      - pg_log_data:/var/lib/postgresql/data
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql:ro

  log-generator:
    image: python:3.12-slim
    container_name: log-generator
    working_dir: /app
    environment:
      SERVICE_NAME: web-simulation
      LOG_PATH: /logs/app.log
    volumes:
      - ./app.py:/app/app.py:ro
      - app_logs:/logs
    command: python /app/app.py
    depends_on:
      - postgres

  log-collector:
    build: ./collector
    container_name: log-collector
    environment:
      LOG_PATH: /logs/app.log
      DB_HOST: postgres
      DB_PORT: 5432
      DB_NAME: logsdb
      DB_USER: logger
      DB_PASSWORD: logger123
    volumes:
      - app_logs:/logs:ro
    depends_on:
      - postgres
      - log-generator

volumes:
  pg_log_data:
  app_logs:
EOF
```

Jalankan:

```bash
docker compose up -d --build
```

Cek status:

```bash
docker compose ps
```

Lihat log semua service:

```bash
docker compose logs -f
```

## 5.8 Query Log di PostgreSQL

Tampilkan 10 log terakhir:

```bash
docker compose exec postgres \
  psql -U logger -d logsdb \
  -c "SELECT id, event_time, service_name, level, message FROM container_logs ORDER BY id DESC LIMIT 10;"
```

Hitung log per level:

```bash
docker compose exec postgres \
  psql -U logger -d logsdb \
  -c "SELECT level, COUNT(*) FROM container_logs GROUP BY level ORDER BY level;"
```

Cari log `ERROR`:

```bash
docker compose exec postgres \
  psql -U logger -d logsdb \
  -c "SELECT event_time, service_name, message FROM container_logs WHERE level='ERROR' ORDER BY event_time DESC LIMIT 5;"
```

## 5.9 Observasi Docker Logs

Bandingkan log container dengan data PostgreSQL:

```bash
docker logs log-generator --tail 5
docker logs log-collector --tail 5
```

Pertanyaan:

1. Apakah semua log `log-generator` masuk ke PostgreSQL?
2. Apa yang terjadi jika `log-collector` dihentikan sementara?
3. Apakah desain ini cocok untuk produksi? Jelaskan keterbatasannya.
4. Apa alternatif produksi yang lebih umum untuk centralized logging?

## 5.10 Simulasi Gangguan

Stop collector:

```bash
docker compose stop log-collector
```

Biarkan `log-generator` berjalan selama 20 detik, lalu aktifkan kembali:

```bash
docker compose start log-collector
```

Amati apakah collector membaca log baru setelah aktif kembali.

Stop semua service:

```bash
docker compose down
```

Reset total termasuk volume:

```bash
docker compose down -v
```

---

# Praktikum 6 — Grafana Service Docker untuk Monitoring Resource

## 6.1 Tujuan

Mahasiswa mampu menjalankan stack monitoring berbasis Docker yang terdiri dari:

```text
cAdvisor → Prometheus → Grafana
```

## 6.2 Teori Singkat

- **cAdvisor** mengumpulkan metrik penggunaan resource container, seperti CPU, memori, network, dan filesystem.
- **Prometheus** mengambil metrik secara berkala dari endpoint HTTP `/metrics`.
- **Grafana** menampilkan metrik dalam bentuk dashboard.

Alur data:

```text
Docker container metrics → cAdvisor /metrics → Prometheus scrape → Grafana dashboard
```

> Catatan: Praktikum monitoring resource paling stabil dijalankan pada Linux host atau Linux VM. Pada Windows dengan Docker Desktop/WSL 2, hasil metrik dapat berbeda karena Docker berjalan di dalam VM/WSL backend.

## 6.3 Persiapan Direktori

```bash
cd ../
mkdir -p 04-monitoring/prometheus 04-monitoring/grafana/provisioning/datasources
cd 04-monitoring
```

## 6.4 Konfigurasi Prometheus

Buat file `prometheus/prometheus.yml`:

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

## 6.5 Provisioning Datasource Grafana

Buat file `grafana/provisioning/datasources/datasource.yml`:

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

## 6.6 Membuat Docker Compose Monitoring

Buat file `compose.yaml`:

```bash
cat > compose.yaml <<'EOF'
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
      - prometheus_data:/prometheus
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
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning:ro
    depends_on:
      - prometheus
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
EOF
```

Jalankan:

```bash
docker compose up -d
```

Cek container:

```bash
docker compose ps
```

## 6.7 Akses Service Monitoring

Akses cAdvisor:

```text
http://localhost:8082
```

Akses Prometheus:

```text
http://localhost:9090
```

Akses Grafana:

```text
http://localhost:3000
```

Login Grafana:

```text
Username: admin
Password: admin123
```

## 6.8 Uji Query Prometheus

Buka Prometheus, lalu coba query berikut:

```promql
up
```

```promql
container_memory_usage_bytes
```

```promql
rate(container_cpu_usage_seconds_total[1m])
```

```promql
rate(container_network_receive_bytes_total[1m])
```

## 6.9 Membuat Dashboard Grafana Manual

Di Grafana:

1. Masuk ke **Dashboards**.
2. Pilih **New Dashboard**.
3. Tambahkan panel CPU:

```promql
rate(container_cpu_usage_seconds_total{name!=""}[1m])
```

4. Tambahkan panel memori:

```promql
container_memory_usage_bytes{name!=""}
```

5. Tambahkan panel network receive:

```promql
rate(container_network_receive_bytes_total{name!=""}[1m])
```

6. Tambahkan panel filesystem read:

```promql
rate(container_fs_reads_bytes_total{name!=""}[1m])
```

7. Simpan dashboard dengan nama:

```text
Docker Resource Monitoring Lab
```

## 6.10 Membuat Beban Container untuk Diamati

Jalankan container penghasil beban CPU ringan:

```bash
docker run -d --name cpu-test alpine sh -c "while true; do :; done"
```

Amati perubahan CPU di Grafana.

Hentikan container:

```bash
docker rm -f cpu-test
```

Jalankan container penghasil traffic sederhana:

```bash
docker run -d --name web-load -p 8090:80 nginx:latest
```

Dari terminal lain:

```bash
for i in $(seq 1 100); do curl -s http://localhost:8090 > /dev/null; done
```

Hapus container:

```bash
docker rm -f web-load
```

## 6.11 Stop Monitoring Stack

```bash
docker compose down
```

Reset total:

```bash
docker compose down -v
```

## 6.12 Tugas Praktikum

1. Buat dashboard Grafana minimal 4 panel:
   - CPU usage
   - Memory usage
   - Network receive/transmit
   - Filesystem read/write
2. Jalankan minimal 3 container berbeda.
3. Dokumentasikan container mana yang paling banyak menggunakan CPU.
4. Dokumentasikan container mana yang paling banyak menggunakan memori.
5. Jelaskan hubungan cAdvisor, Prometheus, dan Grafana.

---

# Praktik Keamanan Dasar Docker

Terapkan prinsip berikut selama praktikum:

1. Jangan gunakan password default untuk lingkungan produksi.
2. Jangan commit file `.env` berisi password ke repository publik.
3. Gunakan named volume untuk data penting.
4. Gunakan bind mount read-only bila container hanya perlu membaca file.
5. Jangan mount `/var/run/docker.sock` ke container kecuali benar-benar diperlukan.
6. Batasi port yang dipublikasikan ke host.
7. Gunakan network internal Docker untuk komunikasi antar-service.
8. Pin versi image untuk produksi, misalnya `postgres:16` alih-alih `postgres:latest`.
9. Aktifkan log rotation agar disk tidak penuh.
10. Hapus container, image, network, dan volume yang tidak digunakan.

Perintah pembersihan:

```bash
docker container prune
docker image prune
docker network prune
docker volume prune
```

Gunakan dengan hati-hati karena perintah prune dapat menghapus resource yang tidak sedang digunakan.

---

# Troubleshooting Umum

## 1. Port sudah digunakan

Gejala:

```text
Bind for 0.0.0.0:8080 failed: port is already allocated
```

Solusi:

```bash
docker ps
```

Cari container yang memakai port tersebut, lalu stop:

```bash
docker rm -f nama-container
```

Atau ubah port host, misalnya dari `8080:80` menjadi `8180:80`.

## 2. Permission denied pada Linux

Gejala:

```text
permission denied while trying to connect to the Docker daemon socket
```

Solusi sementara:

```bash
sudo docker ps
```

Solusi permanen:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## 3. Container langsung berhenti

Cek log:

```bash
docker logs nama-container
```

Cek status exit code:

```bash
docker inspect nama-container --format '{{.State.ExitCode}}'
```

## 4. Docker Compose build gagal

Bersihkan build cache bila perlu:

```bash
docker compose build --no-cache
docker compose up -d
```

## 5. PostgreSQL tidak menerima koneksi

Cek log:

```bash
docker logs logging-postgres
```

Pastikan password, user, database, dan port benar. Jika database sudah pernah dibuat pada volume lama, perubahan environment variable tidak selalu mengubah database yang sudah ada. Reset volume bila memang diperlukan:

```bash
docker compose down -v
```

---

# Lembar Kerja Mahasiswa

## Identitas

- Nama:
- NRP/NIM:
- Kelas:
- Tanggal praktikum:
- Sistem operasi host:
- Versi Docker:
- Versi Docker Compose:

## Bukti Praktikum 1

Lampirkan screenshot atau output:

```bash
docker version
docker compose version
docker run hello-world
```

Jawaban analisis:

1. Jelaskan fungsi Docker Engine.
2. Jelaskan perbedaan image dan container.
3. Jelaskan peran WSL 2 pada Docker Desktop Windows.

## Bukti Praktikum 2

Lampirkan output:

```bash
docker ps
docker volume ls
docker volume inspect labdata
```

Jawaban analisis:

1. Jelaskan perbedaan volume dan bind mount.
2. Berikan contoh kasus penggunaan volume.
3. Berikan contoh kasus penggunaan bind mount.

## Bukti Praktikum 3

Lampirkan screenshot browser:

- Apache `http://localhost:8080`
- Nginx `http://localhost:8081`

Lampirkan output:

```bash
docker compose ps
docker compose logs --tail 20
```

Jawaban analisis:

1. Jelaskan port mapping pada Apache dan Nginx.
2. Jelaskan perbedaan document root Apache dan Nginx.
3. Bandingkan log Apache dan Nginx.

## Bukti Praktikum 4

Lampirkan output query PostgreSQL:

```sql
SELECT * FROM mahasiswa;
SELECT * FROM aset_it;
```

Jawaban analisis:

1. Mengapa PostgreSQL perlu persistent volume?
2. Apa risiko menjalankan database dengan password lemah?
3. Bagaimana cara backup database PostgreSQL dari container?

## Bukti Praktikum 5

Lampirkan output:

```sql
SELECT level, COUNT(*) FROM container_logs GROUP BY level;
SELECT * FROM container_logs ORDER BY id DESC LIMIT 5;
```

Jawaban analisis:

1. Jelaskan alur log dari aplikasi sampai PostgreSQL.
2. Apa kelemahan logging berbasis shared file?
3. Apa alternatif logging untuk skala produksi?

## Bukti Praktikum 6

Lampirkan screenshot:

- Prometheus target status
- Grafana dashboard
- cAdvisor container list

Jawaban analisis:

1. Jelaskan fungsi cAdvisor.
2. Jelaskan fungsi Prometheus.
3. Jelaskan fungsi Grafana.
4. Apa metrik paling penting untuk mendeteksi container bermasalah?

---

# Rubrik Penilaian

| Komponen | Bobot |
|---|---:|
| Instalasi dan verifikasi Docker berhasil | 10% |
| Pengelolaan container, service, log, dan lifecycle | 15% |
| Pemahaman volume dan bind mount | 15% |
| Web service Apache dan Nginx berjalan | 15% |
| PostgreSQL berjalan dengan persistent storage | 15% |
| Pipeline logging ke PostgreSQL berhasil | 15% |
| Grafana monitoring resource berhasil | 10% |
| Analisis, dokumentasi, dan kerapian laporan | 5% |

---

# Pertanyaan Pengayaan

1. Mengapa container bukan virtual machine penuh?
2. Apa dampak menjalankan container dengan user root?
3. Mengapa database container lebih cocok untuk development/lab dibanding deployment produksi tanpa orkestrasi?
4. Apa perbedaan `docker compose down` dan `docker compose down -v`?
5. Bagaimana cara membatasi penggunaan CPU dan memori container?
6. Apa perbedaan monitoring berbasis log dan monitoring berbasis metrik?
7. Mengapa Grafana membutuhkan datasource seperti Prometheus?
8. Bagaimana rancangan logging yang lebih baik untuk sistem banyak node?

---

# Penutup

Modul ini memperkenalkan Docker dari instalasi hingga observability dasar. Setelah menyelesaikan seluruh praktikum, mahasiswa diharapkan mampu menjalankan service berbasis container secara mandiri, memahami persistent storage, membangun service web dan database, membuat pipeline logging sederhana, serta memonitor penggunaan resource container dengan Grafana.

