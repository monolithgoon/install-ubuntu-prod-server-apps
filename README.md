# Ubuntu 22.0+ Server Setup Provisioning Script - Automated Package Installer

## _Overview_
This script automates the installation of various tools and packages for a fresh Ubuntu production server using Bash.

The script is organized into sections, each responsible for installing and configuring a specific application. It is intended to be executed using the Bash interpreter. The shebang at the beginning (`#!/usr/bin/env bash`) ensures that the script is interpreted using Bash.

## _Supported Ubuntu Version_
This script works flawlessly on the following version of Ubuntu:

```bash
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.3 LTS
Architecture:   x64 and ARM64
Release:        22.04
Codename:       jammy
```
Other versions of Ubuntu 22.04.x LTS may also work but have not been explicitly tested.

## _Additional Notes_
```bash
- Ensure that the script is tested in a staging environment before deploying it to production.
- The script installs the latest versions of the tools and packages available at the time of execution by using official repositories or package managers.
- Ensure logging mechanisms are implemented in the script to capture installation steps and errors.
- If an installation step fails, users may need to troubleshoot or manually complete the installation process.
- Always check the official documentation for each tool for the most up-to-date information.
```

### _Prerequisites_
- Administrative privileges (`sudo` access).
- Internet connectivity to download and install packages.

### _Setting Up Environment Variables_
Before installing any packages, the script configures environment variables for production by updating the `.profile` file:

- Adds the following line to the `.profile` file to export environment variables:
   
   ```bash
   set -o allexport; source /home/ubuntu/production.env; set +o allexport
   ```
   - All variables defined or modified in the current shell session after   `set -o allexport` is enabled will be automatically exported to the environment, making them available to child processes. For example:
      ```bash
      set -o allexport
         MY_VAR="value"  # Automatically exported
      ```
   - `set +o allexport` disables the automatic exporting of variables in the current shell session. After this command, any variables you define or modify will no longer be automatically added to the environment.

## _Installed Tools and Packages_

The following tools and packages will be installed by the provided script:

### _1. GitHub CLI (gh)_
- GitHub CLI (gh) – Command-line tool for interacting with GitHub repositories.

### _2. Node Version Manager (NVM) & NPM_
- Node Version Manager (NVM) – Used to manage multiple versions of Node.js.
- Node.js – JavaScript runtime.
- npm (Node Package Manager) – Package manager for Node.js.

### _3. MongoDB Shell_
- MongoDB Shell (mongosh) – Interactive shell for MongoDB.

### _4. MongoDB_
- MongoDB Server – NoSQL database.

### _5. PM2_
- PM2 – Process Manager for Node.js applications.

### _6. Nginx_
- Nginx – Web server for serving HTTP content.

### _7. UFW (Uncomplicated Firewall)_
- UFW – Firewall management tool.
