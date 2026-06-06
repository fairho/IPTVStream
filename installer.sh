#!/bin/sh
# Script d'installation pour IPTVStream Plugin
# Compatible avec toutes les images Enigma2 (OpenPLi, OpenATV, OpenVision, etc.)

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PLUGIN_NAME="IPTVStream"
PLUGIN_VERSION="1.0.0"
PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/IPTVStream"
CONTROL_DIR="/CONTROL"
TMP_DIR="/tmp/IPTVStream"

# Fonctions
print_message() {
    echo -e "${BLUE}[${PLUGIN_NAME}]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

check_root() {
    if [ "$(id -u)" != "0" ]; then
        print_error "Ce script doit être exécuté en tant que root (sudo)"
        exit 1
    fi
}

check_enigma2() {
    if [ ! -d "/usr/lib/enigma2" ]; then
        print_error "Enigma2 n'est pas installé sur ce système"
        exit 1
    fi
    print_success "Enigma2 détecté"
}

create_directories() {
    print_message "Création des répertoires..."
    mkdir -p ${PLUGIN_DIR}
    mkdir -p ${TMP_DIR}
    print_success "Répertoires créés"
}

download_plugin() {
    print_message "Téléchargement du plugin depuis GitHub..."
    
    # Télécharger depuis GitHub
    if command -v wget >/dev/null 2>&1; then
        wget -q --no-check-certificate "https://github.com/fairho/IPTVStream/archive/main.zip" -O ${TMP_DIR}/plugin.zip
    elif command -v curl >/dev/null 2>&1; then
        curl -sL "https://github.com/fairho/IPTVStream/archive/main.zip" -o ${TMP_DIR}/plugin.zip
    else
        print_error "wget ou curl est requis pour le téléchargement"
        exit 1
    fi
    
    if [ -f "${TMP_DIR}/plugin.zip" ]; then
        print_success "Plugin téléchargé"
    else
        print_error "Échec du téléchargement"
        exit 1
    fi
}

extract_plugin() {
    print_message "Extraction du plugin..."
    
    if command -v unzip >/dev/null 2>&1; then
        unzip -q ${TMP_DIR}/plugin.zip -d ${TMP_DIR}
    else
        print_error "unzip est requis pour l'extraction"
        exit 1
    fi
    
    # Copier les fichiers
    cp -r ${TMP_DIR}/IPTVStream-main/usr/* /usr/
    print_success "Plugin extrait et copié"
}

install_dependencies() {
    print_message "Installation des dépendances..."
    
    # Vérifier les dépendances Python
    if [ -f "/usr/bin/python" ]; then
        print_success "Python détecté"
    else
        print_warning "Python non trouvé, tentative d'installation..."
        opkg update
        opkg install python3
    fi
    
    # Nettoyer le cache Python
    find ${PLUGIN_DIR} -name "*.pyc" -exec rm -f {} \;
    find ${PLUGIN_DIR} -name "__pycache__" -type d -exec rm -rf {} \;
    
    print_success "Dépendances installées"
}

set_permissions() {
    print_message "Configuration des permissions..."
    
    chmod -R 755 ${PLUGIN_DIR}
    chmod 644 ${PLUGIN_DIR}/*.py
    chmod 644 ${PLUGIN_DIR}/plugin.png
    
    print_success "Permissions