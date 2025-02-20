#!/bin/bash

# Chemin du marqueur
MARKER_FILE="/etc/postfix_installed"

# Définir les couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifie si le script a déjà été exécuté
if [ -f "$MARKER_FILE" ]; then
  echo -e "\n ${RED}# ====================================================================================== ${NC}"
  echo -e "${RED} #                      RIEN A FAIRE, POSTFIX DEJA INSTALLE !                          ${NC}"
  echo -e "${RED} # ====================================================================================== ${NC}"
  exit 0
fi

# Logo
echo -e "\n${BLUE}# ====================================================================================== ${NC}"
echo -e "${BLUE} #                      Installation et Configuration de Postfix                        ${NC}"
echo -e "${BLUE} # ====================================================================================== ${NC}"

# Mise à jour des paquets
echo -e "\n\t${GREEN}[1/3] Mise à jour des paquets système...${NC}"
sudo apt-get update -y

# Installation de Postfix et de ses dépendances
echo -e "\n\t${GREEN}[2/3] Installation de Postfix et de ses dépendances...${NC}"
sudo apt-get install -y debconf-utils
export DEBIAN_FRONTEND=noninteractive
echo "postfix postfix/mailname string example.com" | sudo debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | sudo debconf-set-selections
sudo apt-get install -y postfix
sudo dpkg --configure -a

# Redémarrage du service Postfix
echo -e "\n\t${GREEN}[3/3] Redémarrage du service Postfix...${NC}"
sudo systemctl restart postfix
sudo systemctl enable postfix

# Création du marqueur pour éviter les réinstallations inutiles
touch "$MARKER_FILE"

# Message final
echo -e "\n ${YELLOW}# ====================================================================================== ${NC}"
echo -e "${YELLOW} #                INSTALLATION DE POSTFIX TERMINEE AVEC SUCCÈS !                        ${NC}"
echo -e "${YELLOW} # ====================================================================================== ${NC}\n"
