#!/bin/bash

show_menu() {
    echo "1. Generate SSH key pair"
    echo "2. Install Docker"
    echo "3. Install Zsh"
    echo "4. Install OpenVPN"
    echo "5. Add user OpenVPN"
    echo "6. Install Samba"
    echo "9. Exit"
}

generate_ssh_key() {
    # Check if ssh key already exists
    if [ -f ~/.ssh/id_rsa ]; then
        echo "SSH key already exists."
        return
    fi

    # Generate SSH key pair
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa

    # Check if key generation was successful
    if [ $? -eq 0 ]; then
        echo "SSH key pair generated successfully."
    else
        echo "Failed to generate SSH key pair."
    fi
}

install_docker() {
    echo "Install docker..."
	sudo apt update
    sudo apt install docker.io -y && sudo apt install docker-compose -y
	sudo usermod -aG docker $USER
    echo "Docker installed successfully."
}
install_zsh() {
    echo "Installing Zsh..."
	sudo apt update
    sudo apt install zsh -y
	chsh -s $(which zsh)
    echo "Zsh installed successfully."
    echo "Configuring Zsh with plugins..."
    # Clone zsh-autosuggestions and zsh-syntax-highlighting repositories
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting    
    # Add plugins to Zsh configuration
    echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
    echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
    # Activate changes
    source ~/.zshrc
    echo "Zsh configured with plugins successfully."
}
install_openvpn() {
	sudo apt update	
	wget https://git.io/vpn -O openvpn-ubuntu-install.sh
	chmod -v +x openvpn-ubuntu-install.sh
	bash openvpn-ubuntu-install.sh
}
add_user_openvpn() {
	bash openvpn-ubuntu-install.sh
}
install_smb() {
	sudo apt update
	sudo apt install samba -y
	sudo systemctl start smbd.service nmbd.service
	sudo systemctl enable smbd.service nmbd.service
	file_config="/etc/samba/smb.conf"
	share_directory="/home/${USER}/smb_share"

	if [ ! -d "$share_directory" ]; then
		mkdir -p "$share_directory"
	fi

	cat >> "$file_config" <<EOF
[smb_share]
	comment = File Server
	path = $share_directory
	browsable = yes
	guest ok = yes
	read only = no
	create mask = 0755
EOF
	echo "=========================================================================="
    echo "| Samba installed successfully. Path to share directory: $share_directory |"
	echo "=========================================================================="

}

# Main loop
while true; do
    show_menu

    read -p "Enter your choice: " choice

    case $choice in
        1)
            generate_ssh_key
            ;;
        2)
            install_docker
            ;;
        3)
            install_zsh
            ;;
        4)
            install_openvpn
            ;;
        5)
            add_user_openvpn
            ;;
        6)
            install_smb
            ;;
        9)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            ;;
    esac
done
