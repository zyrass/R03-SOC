#!/usr/bin/env bash

# Chemin du marqueur
MARKER_FILE="/etc/homelab_assistant_wazuh_installed"

# Définir les couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifie si le script a déjà été exécuté
if [ -f "$MARKER_FILE" ]; then
  echo -e "\n ${RED}# ====================================================================================== ${NC}"
  echo -e "${RED} #                 RIEN A FAIRE, L'ASSISTANT WAZUH EST DEJA TELECHARGE !                  ${NC}"
  echo -e "${RED} # ====================================================================================== ${NC}"
  exit 0
fi

# Logo
echo -e "\n${BLUE}# ====================================================================================== ${NC}"
echo -e "${BLUE} #                            Téléchargement de Wazuh-install.sh                                        ${NC}"
echo -e "${BLUE} # ====================================================================================== ${NC}"

# Téléchargement de l'assistant d'installation de Wazuh
echo -e "\n\t${GREEN}[1/2] Téléchargement de l'assistant d'installation de Wazuh...${NC}"
sudo curl -sO https://packages.wazuh.com/4.11/wazuh-install.sh

# Créer un fichier temporaire pour indiquer que l'installation est terminée
echo -e "\n\t${GREEN}[2/2] Création du marqueur d'installation...${NC}"
sudo touch "$MARKER_FILE"
echo -e "\tMarqueur créé : ${YELLOW}$MARKER_FILE${NC}"

# Message final
echo -e "\n ${YELLOW}# ====================================================================================== ${NC}"
echo -e "${YELLOW} #               LE TELECHARGEMENT DE WAZUH-INSTALL.SH EST TERMINEE AVEC SUCCES !                       ${NC}"
echo -e "${YELLOW} # ====================================================================================== ${NC}\n"
