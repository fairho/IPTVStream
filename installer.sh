#!/bin/sh
# Script d'installation pour IPTVStream Plugin
# Version 1.0.0 - Final
# Compatible avec toutes les images Enigma2
# Support : wget, curl, opkg

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
PLUGIN_NAME="IPTVStream"
PLUGIN_VERSION="1.0.0"
GITHUB_USER="fairho"
GITHUB_REPO="IPTVStream"
GITHUB_BRANCH="main"
GITHUB_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/refs/heads/${GITHUB_BRANCH}.zip"
PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/IPTVStream"
TMP_DIR="/tmp/IPTVStream_install"
LOG_FILE="/tmp/IPTVStream_install.log"

# Initialisation du log
echo "=== IPTVStream Installation Log ===" > ${LOG_FILE}
echo "Date: $(date)" >> ${LOG_FILE}
echo "Version: ${PLUGIN_VERSION}" >> ${LOG_FILE}
echo "==================================" >> ${LOG_FILE}

# Fonctions
log() {
    echo "[$(date '+%H:%M:%S')] $1" >> ${LOG_FILE}
}

print_msg() {
    echo -e "${BLUE}[${PLUGIN_NAME}]${NC} $1"
    log "$1"
}

print_ok() {
    echo -e "${GREEN}[✓]${NC} $1"
    log "OK: $1"
}

print_err() {
    echo -e "${RED}[✗]${NC} $1"
    log "ERREUR: $1"
}

print_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
    log "ATTENTION: $1"
}

# Vérification des droits root
check_root() {
    if [ "$(id -u)" != "0" ]; then
        print_err "Ce script doit être exécuté en tant que root"
        echo ""
        echo "Utilisation:"
        echo "  sudo sh installer.sh"
        echo "  ou"
        echo "  sh installer.sh"
        echo ""
        exit 1
    fi
    print_ok "Permissions root vérifiées"
}

# Vérification du système
check_system() {
    print_msg "Vérification du système..."
    
    # Vérifier Enigma2
    if [ -d "/usr/lib/enigma2" ]; then
        print_ok "Enigma2 détecté dans /usr/lib/enigma2"
    elif [ -f "/usr/bin/enigma2" ]; then
        print_ok "Enigma2 détecté dans /usr/bin"
    else
        print_warn "Enigma2 non détecté"
        print_msg "Installation quand même... (vérifiez votre système)"
    fi
    
    # Vérifier Python
    if command -v python3 >/dev/null 2>&1; then
        print_ok "Python 3 détecté"
    elif command -v python >/dev/null 2>&1; then
        print_ok "Python détecté"
    else
        print_warn "Python non détecté, installation..."
        opkg update >/dev/null 2>&1 || true
        opkg install python3 >/dev/null 2>&1 || true
    fi
    
    # Vérifier wget
    if command -v wget >/dev/null 2>&1; then
        print_ok "wget détecté"
    else
        print_warn "wget non détecté, installation..."
        opkg install wget >/dev/null 2>&1 || true
    fi
    
    # Vérifier unzip
    if command -v unzip >/dev/null 2>&1; then
        print_ok "unzip détecté"
    else
        print_warn "unzip non détecté, installation..."
        opkg install unzip >/dev/null 2>&1 || true
    fi



   
     
