#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Error handler
trap 'echo "Error occurred at line $LINENO. Exiting."; exit 1;' ERR

# Variables for versions and configurations
MONGO_VERSION="8.0"
NVM_VERSION="v0.39.3"
LOG_FILE="script.log"

# Redirect all output to log file
exec > >(tee -i "$LOG_FILE") 2>&1

# Function to display text inside a styled box
box_text() {
  local text="$1"
  local length=${#text}
  local width=40

  # Calculate padding
  local padding=$(( (width - length) / 2 ))

  # Print top border
  printf "\n"
  printf "╔"
  for ((i = 0; i < width; i++)); do printf "═"; done
  printf "╗\n"

  # Print text with padding
  printf "║"
  for ((i = 0; i < padding; i++)); do printf " "; done
  printf "%s" "$text"
  for ((i = 0; i < padding; i++)); do printf " "; done
  printf "║\n"

  # Print bottom border
  printf "╚"
  for ((i = 0; i < width; i++)); do printf "═"; done
  printf "╝\n"
  printf "\n"
}

# Function to label and execute a command
label_and_execute() {
    local label="$1"
    local command="$2"

    # Array of ANSI color codes
    local colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m")

    # Select a random color from the array
    local random_color=${colors[$((RANDOM % ${#colors[@]}))]}

    # echo -e "\n${random_color}--- $label ---\e[0m"
    echo -e "\n${random_color}$label\e[0m"
    eval "$command"
}


# Function to install the base packages
install_base_packages() {
  box_text "Installing Base Packages"

  # Update package list
  # Start by updating the package lists and upgrading the system packages to ensure everything is current
  sudo apt update
  
  # Upgrade package list
  # Upgrading the system ensures you start off with the latest software versions. This is recommended before installing any new software packages
  sudo apt upgrade

  # Install packages
  sudo apt install -y \
    build-essential \
    git \
    gnupg \
    curl \
    wget \
    vim \
    htop \
    net-tools \
    ufw \
    fail2ban

  # Verify installations
  git --version
  curl --version
  wget --version
  vim --version
  htop --version
  netstat -V
  ufw --version
  fail2ban-client --version
}

# Function to install Node.js using NVM and PM2
install_nodejs() {
  box_text "Installing Node.js and PM2 via NVM"

  # Install NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

  # Load NVM
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # Prompt user to choose Node.js version
  echo "Would you like to install a specific version of Node.js or the latest LTS version?"
  echo "1. Specific version"
  echo "2. Latest LTS version"
  read -rp "Enter your choice (1 or 2): " node_choice

  if [ "$node_choice" -eq 1 ]; then
    read -rp "Enter the Node.js version to install (e.g., 16.17.0): " node_version
    nvm install "$node_version"
  else
    nvm install --lts
  fi

  # Install PM2 globally using npm
  npm install -g pm2

  # Verify installation
  node -v
  npm -v
  pm2 -v
}

# Function to install Nginx
install_nginx() {
  box_text "Installing Nginx"

  # Update package list and install Nginx
  sudo apt update
  sudo apt install -y nginx

  # Start and enable Nginx service
  sudo systemctl start nginx
  sudo systemctl enable nginx

  # Verify installation
  nginx -v
  curl -I http://localhost | grep "200 OK" || { echo "Nginx installation verification failed."; exit 1; }
}

# Function to install MongoDB and Mongo Shell
install_mongodb() {
  box_text "Installing MongoDB $MONGO_VERSION"

  # Import the MongoDB public GPG key using curl
  # curl -fsSL https://pgp.mongodb.com/server-$MONGO_VERSION.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-org-$MONGO_VERSION.gpg
  curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor

  # Create the MongoDB source list file
  # echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-org-$MONGO_VERSION.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/$MONGO_VERSION multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VERSION.list
  echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
  
  # Update the package list
  sudo apt update

  # Install MongoDB and Mongo Shell
  # sudo apt install -y mongodb-org mongodb-mongosh
  sudo apt install -y mongodb-org

  # Start and enable MongoDB service
  sudo systemctl start mongod
  sudo systemctl enable mongod

  # Verify installation
  mongod --version
  mongosh --version
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

setup_environment_vars() {

  # Define the code to be added
  code_to_append="set -o allexport; source /home/ubuntu/production.env; set +o allexport"

  # Check if the code is already in the file
  if grep -qF "$code_to_append" ~/.profile; then
      echo "Code already present in ~/.profile. No changes made."
  else
      # Append the code to the end of the file
      echo "$code_to_append" >> ~/.profile
      echo "Code added to ~/.profile."
  fi
}

# Main script execution
box_text "Starting Installation Script"

setup_environment_vars
install_base_packages
install_nodejs
install_nginx
install_mongodb

box_text "Installation Script Completed Successfully"

# Execute commands with labels
label_and_execute "NGINX Version" "nginx -v"
label_and_execute "GitHub CLI Version" "gh --version"
label_and_execute "MongoDB Server Version" "mongod --version"
label_and_execute "MongoDB Shell Version" "mongosh --version"
label_and_execute "Node.js Version" "node -v"
label_and_execute "npm Version" "npm -v"
label_and_execute "PM2 Version" "pm2 --version"
label_and_execute "UFW Status" "sudo ufw status verbose"

# Prompt for server reboot
box_text "Reboot Server"
reboot_server
