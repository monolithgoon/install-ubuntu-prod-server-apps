#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Error handler
trap 'echo "Error occurred at line $LINENO. Exiting."; exit 1;' ERR

# Variables for versions and configurations
MONGO_VERSION="7.0"
NVM_VERSION="v0.39.3"
LOG_FILE="script.log"

# Redirect all output to log file
exec > >(tee -i "$LOG_FILE") 2>&1

# Function to display text inside a styled box
box_text() {
    local text="$1"
    local length=${#text}
    local width=40

    # Calculate padding for centering
    local padding=$(( (width - length) / 2 ))

    # Array of ANSI color codes
    local colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")

    # Select a random color from the array
    local random_color=${colors[$((RANDOM % ${#colors[@]}))]}

    # Draw the box with random color
    echo "┌────────────────────────────────────────┐"
    printf "${random_color}│%*s%s%*s│\e[0m\n" "$padding" "" "$text" "$padding" ""
    echo "└────────────────────────────────────────┘"
}

# Reboot server function
reboot_server() {
    read -p "Do you want to reboot the server now? (Y/N): " answer
    case "$answer" in
        [Yy]* ) echo "Rebooting..."; sudo reboot ;;
        [Nn]* ) echo "Reboot canceled." ;;
        * ) echo "Invalid input. Please enter Y or N."; reboot_server ;;
    esac
}

# Function to label and execute a command
label_and_execute() {
    local label="$1"
    local command="$2"

    local colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")
    local random_color=${colors[$((RANDOM % ${#colors[@]}))]}

    echo -e "\n${random_color}$label\e[0m"
    eval "$command"
}

# Ensure package list is updated only once
box_text "Updating Package List"
sudo apt-get update

# Setting up .profile for environment variables
box_text "Setting Up .profile for Environment Variables"
code_to_append="set -o allexport; source /home/ubuntu/production.env; set +o allexport"
if grep -qF "$code_to_append" ~/.profile; then
    echo "Code already present in ~/.profile. No changes made."
else
    echo "$code_to_append" >> ~/.profile
    echo "Code added to ~/.profile."
fi

# Upgrade installed packages
box_text "Upgrading Installed Packages"
sudo apt-get upgrade -y

# Install GitHub CLI
box_text "Installing GitHub CLI"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update
sudo apt-get install -y gh

# Install Node.js and NVM
box_text "Installing Node Version Manager (NVM) and Node.js"
if command -v nvm &> /dev/null; then
    echo "NVM is already installed."
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install node
fi

# Install MongoDB
box_text "Installing MongoDB"
wget -qO- https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc | sudo tee /usr/share/keyrings/mongodb-server-$MONGO_VERSION.gpg

echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-$MONGO_VERSION.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/$MONGO_VERSION multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VERSION.list
sudo apt-get update
sudo apt-get install -y mongodb-mongosh
mongosh --version

# Install PM2
box_text "Installing PM2"
sudo npm install -g pm2
sudo pm2 startup systemd

# Install htop
box_text "Installing htop"
sudo apt-get install -y htop

# Configure UFW Firewall
box_text "Configuring UFW Firewall"
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

# Display Installed Applications and UFW State
box_text "Checking Installed Applications and UFW State"
label_and_execute "GitHub CLI Version" "gh --version"
label_and_execute "MongoDB Shell Version" "mongosh --version"
label_and_execute "Node.js Version" "node -v"
label_and_execute "npm Version" "npm -v"
label_and_execute "PM2 Version" "pm2 --version"
label_and_execute "UFW Status" "sudo ufw status verbose"

# Prompt for server reboot
box_text "Reboot Server"
reboot_server
