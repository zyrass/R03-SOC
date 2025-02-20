#!/usr/bin/env bash

# Chemin du marqueur
MARKER_FILE="/etc/homelab_ohmyzsh_installed"

# Définir les couleurs pour les messages
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifie si le script a déjà été exécuté
if [ -f "$MARKER_FILE" ]; then
  echo -e "\n ${RED}# ====================================================================================== ${NC}"
  echo -e "${RED} #                      RIEN A FAIRE, OH MY ZSH EST DEJA INSTALLE !                       ${NC}"
  echo -e "${RED} # ====================================================================================== ${NC}"
  exit 0
fi

# Logo
echo -e "\n${BLUE}# ====================================================================================== ${NC}"
echo -e "${BLUE} #                            Installation de Oh My Zsh                                    ${NC}"
echo -e "${BLUE} # ====================================================================================== ${NC}"

# Installation de Oh My Zsh
echo -e "\n\t${GREEN}[1/5] Installation de Oh My Zsh...${NC}"
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Vérification de l'installation de Oh My Zsh
echo -e "\n\t${GREEN}[2/5] Vérification de l'installation de Oh My Zsh...${NC}"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo -e "\t${YELLOW}Oh My Zsh a été installé avec succès.${NC}"
else
  echo -e "\t${RED}Erreur : Oh My Zsh n'a pas été installé correctement.${NC}"
  exit 1
fi

# Activation d'un thème par défaut
echo -e "\n\t${GREEN}[3/5] Activation du thème par défaut...${NC}"
THEME_NAME="agnoster "  # Vous pouvez changer cela pour un autre thème si vous le souhaitez
sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"$THEME_NAME\"/" "$HOME/.zshrc"

# Fixation du changement de thème
echo -e "\n\t${GREEN}[4/5] Fixation du changement de thème...${NC}"
source "$HOME/.zshrc"

# Changement du shell par défaut à zsh
echo -e "\n\t${GREEN}[5/5] Changement du shell par défaut à zsh...${NC}"
chsh -s $(which zsh)

# Créer un fichier temporaire pour indiquer que l'installation est terminée
echo -e "\n\t${GREEN}Création du marqueur d'installation...${NC}"
sudo touch "$MARKER_FILE"
echo -e "\tMarqueur créé : ${YELLOW}$MARKER_FILE${NC}"

# Message final
echo -e "\n ${YELLOW}# ====================================================================================== ${NC}"
echo -e "${YELLOW} #               L'INSTALLATION DE OH MY ZSH EST TERMINEE AVEC SUCCES !                   ${NC}"
echo -e "${YELLOW} # ====================================================================================== ${NC}\n"
