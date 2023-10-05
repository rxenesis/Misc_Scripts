#!/bin/bash

# Instala la versión más reciente de openjdk-jre
sudo apt install openjdk-$(apt-cache pkgnames | grep -oP '^openjdk-\d+-jre$' | grep -oP '\d+' | sort -nr | head -n1)-jre -y

# Solicita el directorio y elimina '/' al final si existe
read -p "Directorio donde se guardará la información (sin '/' al final): " jd_dirname
[[ $jd_dirname == */ ]] && jd_dirname=${jd_dirname%/}

# Descarga JDownloader.jar
wget -O "$jd_dirname/JDownloader.jar" http://installer.jdownloader.org/JDownloader.jar

# Pregunta si ya se solicitó el login de acceso
while true; do
    read -p "¿Ya fue solicitado el login de acceso? (si/no): " response
    case $response in
        [Ss][Ii])
            break
            ;;
        [Nn][Oo])
            java -Djava.awt.headless=true -jar "$jd_dirname/JDownloader.jar" -norestart
            break
            ;;
        *)
            echo "Por favor, responde 'si' o 'no'."
            ;;
    esac
done

# Ejecuta JDownloader.jar
#java -Djava.awt.headless=true -jar "$jd_dirname/JDownloader.jar"

# Descarga un archivo de servicio preconfigurado desde GitHub
sudo curl -L -o "/lib/systemd/system/jdownloader.service" \
  "https://raw.githubusercontent.com/rxenesis/Misc_Scripts/main/jdownloader.service"

# Utiliza sed para realizar tres sustituciones en el archivo de servicio.
# Estas sustituciones actualizan las rutas y nombres de usuario según la configuración del sistema.
sudo sed -i -e "s|^ExecStart=.*|ExecStart=$(command -v java) -jar $jd_dirname/JDownloader.jar|" \
              -e "s|^PIDFile=.*|PIDFile=$jd_dirname/JDownloader.pid|" \
              -e "s|^User=.*|User=$(whoami)|" \
              /lib/systemd/system/jdownloader.service

# Habilitar y verificar el estado del servicio jdownloader
sudo systemctl daemon-reload
sudo systemctl start jdownloader.service
pause 3
sudo systemctl is-active --quiet jdownloader.service && sudo systemctl enable jdownloader.service
#sudo systemctl status jdownloader.service | grep -q "Active: active (running)" | sudo systemctl enable jdownloader.service
