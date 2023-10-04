#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

BLUE='\e[32m'
NC='\e[0m'

YOUTUBEDL_OUTPUT_FOLDER="${HOME}/storage/shared/Youtube/"
YOUTUBEDL_CONFIG_FOLDER="${HOME}/.config/youtube-dl/"
TERMUXURLOPENER_CONFIG_FOLDER="${HOME}/bin/"
PACKAGE_NAMES=("python" "ffmpeg")

echo -e "Hola, este script configurará lo necesario para poder descargar audio y videos de YT\n"
sleep 1

echo -e "${BLUE}Requisitos :${NC}\n"    
echo -e "1. Permiso de Termux para acceder al almacenamiento del teléfono"
echo -e "2. Una conexión a internet activa.\n"
read -p "Cuando estés listo, presiona Enter:"

# Basic setup
termux-setup-storage-info | grep -q "Permission granted" || termux-setup-storage
sleep 2

# Actualizar e instalar paquetes necesarios
pkg update
for package_name in "${PACKAGE_NAMES[@]}"; do
    command -v "$package_name" &> /dev/null || pkg install -y "$package_name"
done

# Checar si se ocupa wheels en una instalacion limpia de Termux
python3 -m pip install -U yt-dlp

# Crear directorios si no existen
mkdir -p "$YOUTUBEDL_OUTPUT_FOLDER" "${YOUTUBEDL_CONFIG_FOLDER}video" "${YOUTUBEDL_CONFIG_FOLDER}audio" "$TERMUXURLOPENER_CONFIG_FOLDER"

# Configurar archivos
conf_file_video="${YOUTUBEDL_CONFIG_FOLDER}video/youtube-dl.conf"
conf_file_audio="${YOUTUBEDL_CONFIG_FOLDER}audio/youtube-dl.conf"

cat > "$conf_file_video" <<EOF
--no-mtime
-o ${YOUTUBEDL_OUTPUT_FOLDER}%(title)s.%(ext)s
-f "best[height<=480]"
EOF

cat > "$conf_file_audio" <<EOF
--no-mtime
-o ${YOUTUBEDL_OUTPUT_FOLDER}%(title)s.%(ext)s
--extract-audio
--audio-format mp3
--audio-quality 0
EOF

# Configurar termux-url-opener
url_opener_script="${TERMUXURLOPENER_CONFIG_FOLDER}termux-url-opener"
cat > "$url_opener_script" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
url=\$1
echo "\$url"
read -p "(a)udio or (v)ideo? " choice

conf_location_video="${YOUTUBEDL_CONFIG_FOLDER}video/youtube-dl.conf"
conf_location_audio="${YOUTUBEDL_CONFIG_FOLDER}audio/youtube-dl.conf"

if [ "\$choice" = "a" ]; then
    yt-dlp --config-location "\$conf_location_audio" "\$url"
else
    yt-dlp --config-location "\$conf_location_video" "\$url"
fi
EOF

chmod +x "$url_opener_script"

echo "Configuración completa."
