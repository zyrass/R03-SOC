# -*- mode: ruby -*-
# vi: set ft=ruby :

# Définition des variables d'environnement
def get_first_bridge_interface
  # Obtenir la liste des interfaces
  bridges = `VBoxManage list bridgedifs`
  # Trouver la première interface qui n'est pas Hyper-V
  bridges.split("\n").each do |line|
    if line.start_with?("Name:") && !line.include?("Hyper-V")
      return line.split(":")[1].strip.gsub('"', '')
    end
  end
  nil
end

# Permet d'éviter toute intéraction avec l'utilisateur
# dans le choix de l'interface réseau
BRIDGE_INTERFACE = get_first_bridge_interface()

# Configuration des VMs
NODES = {
  'vm1' => {
    hostname: 'r03-vm1-siem',
    ip_public: '192.168.56.10',
    memory: 8192,
    cpus: 4,
    scripts: ['wazuh']
  },
  'vm2' => {
    hostname: 'r03-vm2-attaquant',
    ip_public: '192.168.56.20',
    memory: 1024,
    cpus: 1,
    scripts: []
  },
  'vm3' => {
    hostname: 'r03-vm3-cible',
    ip_public: '192.168.56.30',
    memory: 1024,
    cpus: 1,
    scripts: []
  }
}

Vagrant.configure("2") do |config|

  NODES.each do |node_name, node_config|
    config.vm.define node_name do |node|

      # Configuration de base
      node.vm.box = "bento/ubuntu-20.04"
      node.vm.hostname = node_config[:hostname]

      # Configuration du provider VirtualBox
      node.vm.provider "virtualbox" do |vb|
        vb.name = "Homelab-vagrant-[R03]-[#{node_name}]"
        vb.memory = node_config[:memory]
        vb.cpus = node_config[:cpus]
      end

      # Configuration réseau
      node.vm.network "public_network", ip: node_config[:ip_public], auto_config: true, bridge: BRIDGE_INTERFACE

      # Dossier partagé
      node.vm.synced_folder "shared", "/home/vagrant/shared"

      # Scripts de provisioning communs
      node.vm.provision "shell", path: "shared/config/configure_locale_fr.sh"
      node.vm.provision "shell", path: "shared/config/configure_vm.sh"

      # Scripts spécifiques pour installer ou télécharger des outils
      node_config[:scripts].each do |script|
        node.vm.provision "shell", path: "shared/scripts/install_#{script}.sh"
      end
    end
  end

end






# Vagrant.configure("2") do |config|

#   ####################################################################################################
#   # VM n° 1 - Machine virtuelle qui va exécuter un PING INTERDIT
#   ####################################################################################################
#   config.vm.define "vm1" do |vm1|
#     # Configuration de la box Ubuntu 20.04 Bento
#     vm1.vm.box = "bento/ubuntu-20.04"

#     # Configuration de la VM
#     vm1.vm.provider "virtualbox" do |vb|
#       vb.name = "Homelab-siem-[vm1]"
#       vb.memory = "2048"  # 2 GB de RAM
#       vb.cpus = 2         # 2 CPUs
#     end

#     # Définir le hostname de la machine virtuelle
#     vm1.vm.hostname = "siem-vm1"

#     # Interface NAT pour le réseau public (10.0.2.x)
#     vm1.vm.network "public_network", ip: "10.0.2.10", auto_config: true

#     # Interface host-only pour le réseau privé (192.168.56.x)
#     vm1.vm.network "private_network", ip: "192.168.56.10"
    
#     # Dossier partagé monté dans /home/vagrant/shared sur la VM
#     vm1.vm.synced_folder "../shared", "/home/vagrant/shared"

#     # Provisioning : Configurer le système en français
#     vm1.vm.provision "shell", path: "../shared/scripts/configure_locale_fr.sh"

#     # Provisioning : Maintenance globale du système
#     vm1.vm.provision "shell", path: "../shared/scripts/full_system_update.sh"

#     # Configurer Postfix en mode non interactif
#     vm1.vm.provision "shell", inline: <<-SHELL
#       sudo apt-get install -y debconf-utils
      
#       export DEBIAN_FRONTEND=noninteractive
#       echo "postfix postfix/mailname string example.com" | debconf-set-selections
#       echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

#       # Installer Postfix
#       sudo apt-get install -y postfix

#       # Terminer la configuration des paquets inachevés
#       sudo dpkg --configure -a

#       # Redémarrer Postfix pour appliquer les configurations
#       systemctl restart postfix
#     SHELL

#     # Provisioning : Exécuter le script d'installation de l'agent Wazuh
#     vm1.vm.provision "shell", path: "scripts/install_wazuh-agent.sh"
#   end

#   ####################################################################################################
#   # VM n° 2 - Machine victime, génère des logs et déclenche l'agent wazuh
#   ####################################################################################################
#   config.vm.define "vm2" do |vm2|
#     # Configuration de la box Ubuntu 20.04 Bento
#     vm2.vm.box = "bento/ubuntu-20.04"

#     # Configuration de la VM
#     vm2.vm.provider "virtualbox" do |vb|
#       vb.name = "Homelab-siem-[vm2]"
#       vb.memory = "2048"  # 2 GB de RAM
#       vb.cpus = 2         # 2 CPUs
#     end

#     # Définir le hostname de la machine virtuelle
#     vm2.vm.hostname = "siem-vm1"

#     # Interface NAT pour le réseau public (10.0.2.x)
#     vm2.vm.network "public_network", ip: "10.0.2.20", auto_config: true

#     # Interface host-only pour le réseau privé (192.168.56.x)
#     vm2.vm.network "private_network", ip: "192.168.56.20"
    
#     # Dossier partagé monté dans /home/vagrant/shared sur la VM
#     vm2.vm.synced_folder "../shared", "/home/vagrant/shared"

#     # Provisioning : Configurer le système en français
#     vm2.vm.provision "shell", path: "../shared/scripts/configure_locale_fr.sh"

#     # Provisioning : Maintenance globale du système
#     vm2.vm.provision "shell", path: "../shared/scripts/full_system_update.sh"

#     # Configurer Postfix en mode non interactif
#     vm2.vm.provision "shell", inline: <<-SHELL
#       sudo apt-get install -y debconf-utils
      
#       export DEBIAN_FRONTEND=noninteractive
#       echo "postfix postfix/mailname string example.com" | debconf-set-selections
#       echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

#       # Installer Postfix
#       sudo apt-get install -y postfix

#       # Terminer la configuration des paquets inachevés
#       sudo dpkg --configure -a

#       # Redémarrer Postfix pour appliquer les configurations
#       systemctl restart postfix
#     SHELL

#     # Provisioning : Exécuter le script d'installation de l'agent Wazuh
#     vm2.vm.provision "shell", path: "scripts/install_wazuh-agent.sh"
#   end

#   ####################################################################################################
#   # VM n° 3 - SIEM, Récupère les logs sur le server, les indexes et les affiches sur le dashboard
#   ####################################################################################################
#   config.vm.define "siem" do |siem|
#     # Configuration de la box Ubuntu 20.04 Bento
#     siem.vm.box = "bento/ubuntu-20.04"

#     # Configuration de la VM
#     siem.vm.provider "virtualbox" do |vb|
#       vb.name = "Homelab-siem-[vm3]"
#       vb.memory = "8192"  # 8 GB de RAM
#       vb.cpus = 4         # 4 CPUs
#     end

#     # Définir le hostname de la machine virtuelle
#     siem.vm.hostname = "siem-vm3"

#     # Interface NAT pour le réseau public (10.0.2.x)
#     siem.vm.network "public_network", ip: "10.0.2.30", auto_config: true

#     # Interface host-only pour le réseau privé (192.168.56.x)
#     siem.vm.network "private_network", ip: "192.168.56.30"
    
#     # Dossier partagé monté dans /home/vagrant/shared sur la VM
#     siem.vm.synced_folder "../shared", "/home/vagrant/shared"

#     # Provisioning : Configurer le système en français
#     siem.vm.provision "shell", path: "../shared/scripts/configure_locale_fr.sh"

#     # Provisioning : Maintenance globale du système
#     siem.vm.provision "shell", path: "../shared/scripts/full_system_update.sh"

#     # Configurer Postfix en mode non interactif
#     siem.vm.provision "shell", inline: <<-SHELL
#       sudo apt-get install -y debconf-utils
      
#       export DEBIAN_FRONTEND=noninteractive
#       echo "postfix postfix/mailname string example.com" | debconf-set-selections
#       echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

#       # Installer Postfix
#       sudo apt-get install -y postfix

#       # Terminer la configuration des paquets inachevés
#       sudo dpkg --configure -a

#       # Redémarrer Postfix pour appliquer les configurations
#       systemctl restart postfix
#     SHELL

#     # Provisioning : Exécuter le script d'installation du server Wazuh
#     siem.vm.provision "shell", path: "scripts/install_wazuh-server.sh"

#     # Provisioning : Exécuter le script d'installation de l'indexer Wazuh
#     siem.vm.provision "shell", path: "scripts/install_wazuh-indexer.sh"

#     # Provisioning : Exécuter le script d'installation du dashboard de Wazuh
#     siem.vm.provision "shell", path: "scripts/install_wazuh-dashboard.sh"
#   end

# end