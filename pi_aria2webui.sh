#!/bin/bash
source lat_rel_git.sh

# Instalar paquetes necesarios
sudo apt install -y lighttpd aria2 screen

# Limpiar archivos de índice existentes en /var/www/html
sudo rm -f /var/www/html/index*.html

# Configurar lighttpd para habilitar el listado de directorios
echo 'dir-listing.activate = "enable" $HTTP["url"] =~ "^/*($|/)" { dir-listing.activate = "enable" }' | sudo tee -a /etc/lighttpd/lighttpd.conf
sudo systemctl restart lighttpd

# Descargar e instalar AriaNg
download_url=$(get_download_url "mayswind/AriaNg" "AllInOne" "zip")
curl -L -o "/tmp/AriaNg.zip" "$download_url"
sudo unzip "/tmp/AriaNg.zip" -d /var/www/html/aria2
rm "/tmp/AriaNg.zip"

# Configurar aria2
sudo mkdir -p "$HOME/.aria2" && sudo touch "$HOME/.aria2/aria2.conf"

# Configurar crontab para iniciar AriaRPC en el arranque
{ crontab -l; echo "@reboot screen -d -m -S AriaRPC bash -c 'aria2c --enable-rpc --rpc-listen-all --rpc-allow-origin-all=true'"; } | crontab -

# Reiniciar el sistema
sudo shutdown -r now
