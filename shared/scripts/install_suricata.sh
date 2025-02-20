#!/usr/bin/env bash

# Chemin du marqueur
MARKER_FILE="/etc/homelab_suricata_installed"

# Définir les couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifie si le script a déjà été exécuté
if [ -f "$MARKER_FILE" ]; then
  echo -e "\n ${RED}# ====================================================================================== ${NC}"
  echo -e "${RED} #                      RIEN A FAIRE, SURICATA EST DEJA INSTALLE !                            ${NC}"
  echo -e "${RED} # ====================================================================================== ${NC}"
  exit 0
fi

# Logo
echo -e "\n${BLUE}# ====================================================================================== ${NC}"
echo -e "${BLUE} #                            Installation de Suricata                                       ${NC}"
echo -e "${BLUE} # ====================================================================================== ${NC}"

# Installation des dépendances nécessaires
echo -e "\n\t${GREEN}[1/7] Installation des dépendances nécessaires...${NC}"
sudo apt-get install -y autoconf automake build-essential cargo cbindgen libjansson-dev libpcap-dev libpcre2-dev libtool libyaml-dev make pkg-config rustc zlib1g-dev

# Ajout du PPA de suricata
echo -e "\n\t${GREEN}[2/7] Installation du PPA suricata-stable...${NC}"
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:oisf/suricata-stable
sudo apt-get update -y

# Installation de suricata
echo -e "\n\t${GREEN}[3/7] Installation de suricata...${NC}"
sudo apt-get install -y suricata

# Démarre suricata
echo -e "\n\t${GREEN}[4/7] Démarre suricata...${NC}"
sudo systemctl start suricata

# Démarrer suricata au démarrage du système
echo -e "\n\t${GREEN}[5/7] Active le démarrage automatique au lancement du système...${NC}"
sudo systemctl enable suricata

# Démarrer suricata au démarrage du système
echo -e "\n\t${GREEN}[6/7] Contrôle le statut de Suricata...${NC}"
sudo systemctl status suricata

# Créer un fichier temporaire pour indiquer que l'installation est terminée
echo -e "\n\t${GREEN}[7/7] Création du marqueur d'installation...${NC}"
sudo touch "$MARKER_FILE"
echo -e "\tMarqueur créé : ${YELLOW}$MARKER_FILE${NC}"

# Message final
echo -e "\n ${YELLOW}# ====================================================================================== ${NC}"
echo -e "${YELLOW} #               L'INSTALLATION DE SURICATA EST TERMINEE AVEC SUCCES !                       ${NC}"
echo -e "${YELLOW} # ====================================================================================== ${NC}\n"
