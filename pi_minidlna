#!/bin/bash

# Actualizar el sistema y instalar minidlna
sudo apt update && sudo apt upgrade -y
sudo apt install -y minidlna

# Configurar minidlna
sudo sed -i '/^media_dir=/ s/^/#/' /etc/minidlna.conf
read -p "Directorio donde se guardará la información: " dirname
[[ "$dirname" =~ ^/ ]] && mkdir -p "$dirname/music" "$dirname/pictures" "$dirname/videos"
sudo sed -i 's/^#\?inotify=.*/inotify=yes/' /etc/minidlna.conf
read -p "Ingresa el nombre del servidor: " fname
sudo sed -i "s/^#\?friendly_name=.*/friendly_name=$fname/" /etc/minidlna.conf
echo "65538" | sudo tee -a /proc/sys/fs/inotify/max_user_watches
sudo sed -i 's/#db_dir=/db_dir=/' /etc/minidlna.conf
sudo sed -i 's/#log_dir=/log_dir=/' /etc/minidlna.conf
sudo sed -i 's/^#\?port=.*/port=8200/' /etc/minidlna.conf
sudo sed -i 's/^#\?notify_interval=.*/notify_interval=60/' /etc/minidlna.conf

# Habilitar y verificar el estado del servicio minidlna
sudo service minidlna restart
pause 3
sudo service minidlna status | grep -q "Active: active (running)" && sudo service minidlna enable
