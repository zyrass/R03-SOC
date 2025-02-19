#!/bin/bash

# Chemin du marqueur
MARKER_FILE="/etc/homelab_fr_installed"

# Définir les couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifie si le script a déjà été exécuté
if [ -f "$MARKER_FILE" ]; then
  echo -e "\n ${RED}# ====================================================================================== ${NC}"
  echo -e "${RED} #                      RIEN A FAIRE, LANGUE FR DEJA CONFIGURE !                          ${NC}"
  echo -e "${RED} # ====================================================================================== ${NC}"
  exit 0
fi

# Logo
echo -e "\n${BLUE}# ====================================================================================== ${NC}"
echo -e "${BLUE} #                            Changement de la langue du système                       ${NC}"
echo -e "${BLUE} # ====================================================================================== ${NC}"

# Mise à jour des paquets
echo -e "\n\t${GREEN}[1/6] Mise à jour des paquets système...${NC}"
sudo apt-get update -y

# Installation des paquets de langue
echo -e "\n\t${GREEN}[2/6] Installation des paquets de langue français...${NC}"
sudo apt-get install -y language-pack-fr language-pack-fr-base language-pack-gnome-fr language-pack-gnome-fr-base

# Configuration de la locale en français
echo -e "\n\t${GREEN}[3/6] Configuration de la locale en français...${NC}"
sudo locale-gen fr_FR.UTF-8
sudo update-locale LANG=fr_FR.UTF-8 LC_MESSAGES=fr_FR.UTF-8

# Activer la nouvelle locale dans la session courante
export LANG=fr_FR.UTF-8
export LC_MESSAGES=fr_FR.UTF-8

# Configuration du clavier en français
echo -e "\n\t${GREEN}[4/6] Configuration du clavier en français...${NC}"
sudo sed -i 's/XKBLAYOUT="us"/XKBLAYOUT="fr"/g' /etc/default/keyboard
sudo dpkg-reconfigure -f noninteractive keyboard-configuration

# Redémarrage du service clavier
echo -e "\n\t${GREEN}[5/6] Redémarrage du service clavier...${NC}"
sudo service keyboard-setup restart

# Configuration du fuseau horaire
echo -e "\n\t${GREEN}[6/6] Configuration du fuseau horaire en Europe/Paris...${NC}"
sudo timedatectl set-timezone Europe/Paris

# Création du marqueur pour éviter les reconfigurations
touch "$MARKER_FILE"

# Message final
echo -e "\n ${YELLOW}# ====================================================================================== ${NC}"
echo -e "${YELLOW} #               PASSAGE DE LA LANGUE EN FRANÇAIS TERMINE SANS REBOOT !                 ${NC}"
echo -e "${YELLOW} #    Si vous remarquez des anomalies, redémarrez manuellement pour tout appliquer.     ${NC}"
echo -e "${YELLOW} # ====================================================================================== ${NC}\n"
