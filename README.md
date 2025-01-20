# Ubuntu 24.0+ Server Setup Provisioning Script - Automated Package Installer

## 👀 *Overview*

This script automates the installation of various tools and packages for a fresh Ubuntu production server using Bash.

It simplifies the process of setting up MongoDB, Node.js, and other commonly used tools to ensure your server is ready for development or production.

The script is organized into sections, each responsible for installing and configuring a specific application. It is intended to be executed using the Bash interpreter. The shebang at the beginning (#!/usr/bin/env bash) ensures that the script is interpreted using Bash.

- Ensures services like MongoDB and Nginx are enabled to start at boot.
- Provides verification steps for successful installation.

## 🌟 *Features*

- Installs and configures:
  - 🛠️ `build-essential`: For compiling software from source.
  - 🌀 `git`: Version control system.
  - 🌀 `github-cli`: Command-line tool for interacting with GitHub repositories.
  - 🌐 `curl` and `wget`: Command-line tools for file transfers.
  - ✏️ `vim`: Text editor.
  - 📊 `htop`: Process viewer.
  - 🌍 `net-tools`: Networking utilities.
  - 🔥 `ufw`: Firewall management.
  - 🛡️ `fail2ban`: Security tool to prevent brute-force attacks.
  - 🌐 `nginx`: Web server.
  - ⚙️ `node`: Using NVM (Node Version Manager).
  - ⚙️ `pm2`: Process manager for Node.js applications.
  - ⚙️ `MongoDB`: Server and Mongo Shell.

## 🚀 *Prerequisites*

- Root or `sudo` privileges.

This script works flawlessly on the following version of Ubuntu:

```bash
Distributor ID: Ubuntu
Description:    Ubuntu 24.04 LTS
Architecture:   x64 and ARM64
Release:        24.04
Codename:       lunar
```

## 📋 *How to Use*

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/monolithgoon/install-ubuntu-server-packages.git
   cd install-ubuntu-server-packages
   ```

2. **Run the Script**:
   ```bash
   chmod +x install_packages.sh
   ./install_packages.sh
   ```

3. **Follow On-Screen Prompts**:
   - During the Node.js installation, you can choose between installing a specific version or the latest LTS version.

## 📝 *Logging*

- All output is logged to `script.log` in the working directory.

## 🚨 *Error Handling*

- The script includes error handling to terminate if any command fails.
- Errors are logged with the line number for debugging.

## 🛠️ *Setting Up Environment Variables*

Before installing any packages, the script configures environment variables for production by adding the following line to the `.profile` file:

```bash
set -o allexport; source /home/ubuntu/production.env; set +o allexport
```

- **_Automatic Exporting_**
   - `set -o allexport` enables automatic exporting of all variables defined or modified in the current shell session. For example:

     ```bash
     set -o allexport
     MY_VAR="value"  # Automatically exported
     ```
   - This makes the variables available to child processes without explicitly using the `export` command.

- **_Loading Environment Variables_**
   - `source /home/ubuntu/production.env` loads the environment variables defined in the `production.env` file into the current shell session. These variables are then exported automatically because of `set -o allexport`.

- **_Disabling Automatic Exporting_**
   - `set +o allexport` disables automatic exporting of variables. Any variables defined or modified after this point will not be added to the environment automatically.

This setup ensures that every time a user logs in or starts a new shell session:
1. `set -o allexport`: The environment variables defined in the `production.env` file are automatically exported.
2. These variables are immediately available for use by the shell or any child processes.
3. `set +o allexport`: Automatic exporting is disabled after loading the environment variables, preventing unintentional exports of future variables.

## 📄 *License*

This script is licensed under the MIT License. Feel free to modify and distribute it as needed.
