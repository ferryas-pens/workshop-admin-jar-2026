Berikut langkah-langkah ringkas yang bisa dijadikan panduan praktikum untuk membuat dan meng‑install VM Ubuntu Server di Proxmox sesuai parameter yang Anda berikan. [thomas-krenn](https://www.thomas-krenn.com/en/wiki/Creation_of_Proxmox_Ubuntu_24.04_server_VM)

***

## 1. Siapkan ISO Ubuntu Server

1. Unduh ISO Ubuntu Server (jika belum ada), misalnya Ubuntu Server 22.04 LTS. [kenbinlab](https://kenbinlab.com/how-to-install-ubuntu-server-on-proxmox/)
2. Buka Web UI Proxmox: `https://IP-Proxmox:8006` dan login. [support.us.ovhcloud](https://support.us.ovhcloud.com/hc/en-us/articles/360010916620-How-to-Create-a-VM-in-Proxmox-VE)
3. Pilih storage yang bertipe `ISO image` (mis. `local`), tab **Content → Upload → ISO image**, unggah file ISO Ubuntu Server. [virtualizationhowto](https://www.virtualizationhowto.com/2022/09/proxmox-create-iso-storage-location-disk-space-error/)

***

## 2. Buat VM Baru di Proxmox

1. Klik node Proxmox → tombol **Create VM**. [thomas-krenn](https://www.thomas-krenn.com/en/wiki/Creation_of_Proxmox_Ubuntu_24.04_server_VM)
2. Tab **General**:  
   - Node: pilih node Proxmox Anda.  
   - VM ID: biarkan default atau sesuaikan.  
   - Name: `D4TIB-K01` untuk kelompok 1 (K02, K03, dst untuk kelompok berikutnya).  
3. Tab **OS**:  
   - ISO image: pilih ISO Ubuntu Server yang sudah di‑upload.  
   - Guest OS type: Linux, version: 5.x/6.x kernel (sesuai versi Proxmox). [kenbinlab](https://kenbinlab.com/how-to-install-ubuntu-server-on-proxmox/)
4. Tab **System**:  
   - BIOS: default (OVMF/SeaBIOS sesuai kebijakan lab).  
   - Machine: `q35` atau default.  
5. Tab **Disks**:  
   - Bus/Device: `SCSI` (default).  
   - Disk size: `20` GB sesuai parameter.  
6. Tab **CPU**:  
   - Sockets: `2`.  
   - Cores: `2`.  
7. Tab **Memory**:  
   - Memory (MB): `4096`.  
8. Tab **Network**:  
   - Bridge: `vmbr0` (atau bridge yang terhubung ke jaringan praktikum).  
   - Model: `VirtIO` atau `E1000` sesuai standar lab. [thomas-krenn](https://www.thomas-krenn.com/en/wiki/Creation_of_Proxmox_Ubuntu_24.04_server_VM)
9. Klik **Finish** untuk membuat VM.

***

## 3. Instal Ubuntu Server di VM

1. Pilih VM `D4TIB-K01` → klik **Start**, lalu buka tab **Console**. [kenbinlab](https://kenbinlab.com/how-to-install-ubuntu-server-on-proxmox/)
2. Ikuti wizard instalasi Ubuntu Server: pilih bahasa dan layout keyboard. [youtube](https://www.youtube.com/watch?v=wMtSGAVxQ9o)
3. Network: untuk tahap instalasi bisa biarkan DHCP dulu (otomatis), atau langsung set manual nanti setelah sistem terpasang. [thomas-krenn](https://www.thomas-krenn.com/en/wiki/Creation_of_Proxmox_Ubuntu_24.04_server_VM)
4. Storage: pilih opsi **Use entire disk** pada disk 20 GB yang terlihat. [kenbinlab](https://kenbinlab.com/how-to-install-ubuntu-server-on-proxmox/)
5. User dan hostname:  
   - Your name: `student`.  
   - Server name (hostname): `D4TIB-K01`.  
   - Username: `student`.  
   - Password: `student`.  
6. Pilih untuk meng-install **OpenSSH server** agar dapat remote SSH ke server. [thomas-krenn](https://www.thomas-krenn.com/en/wiki/Creation_of_Proxmox_Ubuntu_24.04_server_VM)
7. Selesaikan instalasi, reboot, dan pastikan ISO tidak lagi di‑boot (bisa lewat Hardware → CD/DVD → “Do not use any media”). [forum.proxmox](https://forum.proxmox.com/threads/how-to-install-the-first-vm-from-iso-images.105206/)

***

## 4. Konfigurasi IP Statis di Ubuntu Server

Anggap interface misalnya bernama `ens18` (cek dengan `ip a` di dalam VM).

1. Login di console dengan user `student` / `student`.  
2. Masuk ke direktori netplan:  
   - `cd /etc/netplan` lalu `ls` untuk melihat file, biasanya `00-installer-config.yaml`. [linuxtechi](https://www.linuxtechi.com/static-ip-address-on-ubuntu-server/)
3. Edit file tersebut dengan `sudo nano 00-installer-config.yaml` dan ubah isinya kira‑kira menjadi:  

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:
      addresses:
        - 10.252.108.71/24
      gateway4: 10.252.108.1
      nameservers:
        addresses:
          - 202.9.85.3
      dhcp4: false
```

Struktur di atas mengikuti skema netplan untuk IP statis di Ubuntu Server 22.04. [netplan.readthedocs](https://netplan.readthedocs.io/en/stable/using-static-ip-addresses/)

4. Simpan file, lalu jalankan:  
   - `sudo netplan apply`  
5. Verifikasi:  
   - `ip a` untuk cek IP 10.252.108.71/24 sudah terpasang.  
   - `ip route` untuk cek default route ke 10.252.108.1. [rosehosting](https://www.rosehosting.com/blog/how-to-configure-static-ip-address-on-ubuntu-22-04/)
   - `ping 202.9.85.3` atau `ping kebo.pens.ac.id` untuk uji koneksi.  

Untuk kelompok lain, ganti alamat IP sesuai skema (mis. 10.252.108.72, 10.252.108.73, dst), hostname `D4TIB-K02`, `D4TIB-K03`, dan seterusnya.

***

## 5. Konfigurasi Repository ke kebo.pens.ac.id

Dengan asumsi repository lokal sudah menyediakan mirror Ubuntu di `https://kebo.pens.ac.id/ubuntu`:

1. Backup sources list default:  
   - `sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak`  
2. Edit `sources.list`:  
   - `sudo nano /etc/apt/sources.list`  
3. Isi dengan baris repository (sesuaikan codename, mis. `jammy` untuk 22.04):  

```text
deb https://kebo.pens.ac.id/ubuntu jammy main restricted universe multiverse
deb https://kebo.pens.ac.id/ubuntu jammy-updates main restricted universe multiverse
deb https://kebo.pens.ac.id/ubuntu jammy-security main restricted universe multiverse
```

Format ini mengikuti pola standar repository Ubuntu, hanya URL yang diarahkan ke mirror lokal. [proxmox](https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started)

4. Simpan, lalu jalankan:  
   - `sudo apt update`  
5. Pastikan tidak ada error dan paket dapat diunduh dari kebo.pens.ac.id.

***

Jika ini akan dipakai untuk modul praktikum, Anda ingin saya tambahkan template instruksi singkat untuk mahasiswa (misalnya format job sheet) atau cukup langkah teknis seperti di atas?  
