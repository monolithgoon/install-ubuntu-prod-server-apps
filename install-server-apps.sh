# This script is written in Bash and will be executed using the Bash interpreter.
#!/usr/bin/env bash

# box_text() {
#     local text="$1"
#     local length=${#text}
#     local width=40  # Adjust this value based on your desired width

#     # Calculate padding for centering
#     local padding=$(( (width - length) / 2 ))

#     # Draw the box
#     echo "┌────────────────────────────────────────┐"
#     printf "│%*s%s%*s│\n" "$padding" "" "$text" "$padding" ""
#     echo "└────────────────────────────────────────┘"
# }

box_text() {
    local text="$1"
    local length=${#text}
    local width=40  # Adjust this value based on your desired width

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

box_text "SETUP `~/.profile` FOR ENV VAR "

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


box_text "GITHUB SHELL" 

# Script to install GitHub CLI (gh) on Ubuntu

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh


box_text "Node Version Manager (NVM) & NPM"

# Install Node Version Manager (NVM)

# This command will clone the NVM repo from Github to the ~/.nvm directory
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# Set the environment variable that specifies the directory where NVM stores its configuration and version-related information
export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# Check the NVM version
nvm --version

# install nodejs and npm
nvm install node


box_text "MONGODB SHELL"

# Import the public key used by the package management system
# The command writes the GPG key to your system's /etc/apt/trusted.gpg.d folder and prints the key to your terminal. You do not need to copy or save the key that is printed to the terminal.

wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-7.0.asc

# Create a list file for MongoDB
# This command adds a new software source entry for MongoDB to the package manager's list of repositories on a system running Ubuntu with the codename "Jammy" and architecture support for both amd64 and arm64.

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Reload the local package database

# REMOVE -> ALREADY UPDATED + SEEMS TO BE CAUSING PROBLEMS
# sudo apt-get update

# Install the `mongosh` package

sudo apt-get install -y mongodb-mongosh

# Confirm that `mongosh` installed successfully

mongosh --version


box_text "MONGODB" 

# import mongodb 4.0 public gpg key
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

# create the /etc/apt/sources.list.d/mongodb-org-4.0.list file for mongodb
# echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

# 1. Reload local package database

# REMOVE -> ALREADY UPDATED + SEEMS TO BE CAUSING PROBLEMS
# sudo apt-get update

# 2. Install the latest version of mongodb

sudo apt-get install -y mongodb-org

# 3. Start mongodb

sudo systemctl start mongod

# 4. Set mongodb to start automatically on system startup

sudo systemctl enable mongod


box_text "PM2"

# 1. Install pm2 with npm

sudo npm install -g pm2

# 2. Set pm2 to start automatically on system startup

sudo pm2 startup systemd


# box_text "NGINX"

# Install nginx

# sudo apt-get install -y nginx

# To start nginx, run

# sudo systemctl start nginx


box_text "htop"
sudo apt-get install htop


box_text "UFW (FIREWALL)"

# allow ssh connections through firewall
# sudo ufw allow OpenSSH

#Allow HTTP and HTTPS Directly
sudo ufw allow 80
sudo ufw allow 443

# allow http & https through firewall
# sudo ufw allow 'Nginx Full'

# enable firewall
sudo ufw --force enable


box_text "INSTALLED APPLICATIONS & UFW STATE"

nginx -v
gh --version
mongod --version
mongosh --version
node -v
npm -v
sudo ufw status verbose


box_text "REBOOT SERVER"

read -p "Do you want to reboot server? (Y | N): " answer

if [ "$answer" == "y" ]; then
    echo "Rebooting..."
    sudo reboot
elif [ "$answer" == "n" ]; then
    echo "Reboot canceled."
else
    echo "Invalid response. Please enter 'yes' or 'no'."
fi
