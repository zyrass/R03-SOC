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

# Définition du mode réseau (privé recommandé)
NETWORK_MODE = "private_network" # Peut être "public_network" si nécessaire

# Configuration des VMs
NODES = {
  'vm1' => {
    hostname: 'r03-vm1-siem',
    ip_public: '10.0.2.10',
    ip_private: '192.168.56.10',
    memory: 8192,
    cpus: 4,
    scripts: ['wazuh']
  },
  'vm2' => {
    hostname: 'r03-vm2-attaquant',
    ip_public: '10.0.2.20',
    ip_private: '192.168.56.20',
    memory: 2048,
    cpus: 2,
    scripts: []
  },
  'vm3' => {
    hostname: 'r03-vm3-cible',
    ip_public: '10.0.2.30',
    ip_private: '192.168.56.30',
    memory: 2048,
    cpus: 2,
    scripts: []
  }
}

Vagrant.configure("2") do |config|

  NODES.each do |node_name, node_config|
    config.vm.define node_name do |node|

      # Configuration de base
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = node_config[:hostname]

      # Configuration du provider VirtualBox
      node.vm.provider "virtualbox" do |vb|
        vb.name = "Homelab-vagrant-[R03]-[#{node_name}]"
        vb.memory = node_config[:memory]
        vb.cpus = node_config[:cpus]
      end

      # Configuration réseau (privé recommandé)
      if NETWORK_MODE == "public_network"
        node.vm.network "public_network", ip: node_config[:ip_public], auto_config: true, bridge: BRIDGE_INTERFACE
      else
        node.vm.network "private_network", ip: node_config[:ip_private], auto_config: true, bridge: BRIDGE_INTERFACE
      end

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
