#!/bin/bash

# Descripción: Instala y configura Plowshare en el sistema

# Instala las dependencias necesarias (git, build-essential, nodejs)
sudo apt install -y git build-essential nodejs && \

# Clona el repositorio de Plowshare desde GitHub
sudo git clone https://github.com/mcrapet/plowshare.git && \

# Ingresa al directorio recién clonado
cd plowshare && \

# Compila e instala Plowshare
sudo make install && \

# Regresa al directorio anterior
cd .. && \

# Elimina el directorio de Plowshare (opcional, para ahorrar espacio)
sudo rm -rf plowshare && \

# Ejecuta plowmod para realizar configuraciones adicionales e instalar módulos adicionales
sudo plowmod --install
