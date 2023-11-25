


box_text "UPDATE PACKAGE LIST   "

sudo apt-get update





box_text "UPGRADE PACKAGES  "

sudo apt-get upgrade




box_text "GITHUB SHELL  " 

# Script to install GitHub CLI (gh) on Ubuntu

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
# REMOVE -> ALREADY CALLED ABOVE
# sudo apt update
# sudo apt install gh




box_text "Node Version Manager (NVM) & NPM  "

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
