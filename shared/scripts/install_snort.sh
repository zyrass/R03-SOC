#!/usr/bin/env bash

# Chemin du marqueur
MARKER_FILE="/etc/homelab_snort_installed"

# Définir les couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifie si le script a déjà été exécuté
if [ -f "$MARKER_FILE" ]; then
  echo -e "\n ${RED}# ====================================================================================== ${NC}"
  echo -e "${RED} #                      RIEN A FAIRE, SNORT EST DEJA INSTALLE !                            ${NC}"
  echo -e "${RED} # ====================================================================================== ${NC}"
  exit 0
fi

# Logo
echo -e "\n${BLUE}# ====================================================================================== ${NC}"
echo -e "${BLUE} #                            Installation de Snort                                       ${NC}"
echo -e "${BLUE} # ====================================================================================== ${NC}"

# Installation de Snort
echo -e "\n\t${GREEN}[1/3] Installation de Snort...${NC}"
sudo apt-get install -y snort

# Vérification de la version de Snort
echo -e "\n\t${GREEN}[2/3] Vérification de la version de Snort...${NC}"
sudo snort --version

# Créer un fichier temporaire pour indiquer que l'installation est terminée
echo -e "\n\t${GREEN}[3/3] Création du marqueur d'installation...${NC}"
sudo touch "$MARKER_FILE"
echo -e "\tMarqueur créé : ${YELLOW}$MARKER_FILE${NC}"

# Message final
echo -e "\n ${YELLOW}# ====================================================================================== ${NC}"
echo -e "${YELLOW} #               L'INSTALLATION DE SNORT EST TERMINEE AVEC SUCCES !                       ${NC}"
echo -e "${YELLOW} # ====================================================================================== ${NC}\n"
