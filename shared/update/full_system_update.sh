#!/bin/bash

# Définir les couleurs pour les messages
GREEN='\033[0;32m'  # Vert
RED='\033[0;31m'    # Rouge
NC='\033[0m'        # Pas de couleur (No Color)

# Logo
echo -e "\n ${GREEN}# ====================================================================================== ${NC}"
echo -e "${GREEN} #                                       MAINTENANCE                                      ${NC}"
echo -e "${GREEN} # ====================================================================================== ${NC}"

# Mettre à jour le système
sudo apt-get update -y
sudo apt-get full-upgrade -y
sudo apt-get autoremove -y
sudo apt-get clean

# Logo
echo -e "\n ${RED}# ====================================================================================== ${NC}"
echo -e "${RED} #                                   MAINTENANCE TERMINE !                                ${NC}"
echo -e "${RED} # ====================================================================================== ${NC}"