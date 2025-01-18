# Ubuntu 22.0+ Server Setup Provisioning Script - Automated Package Installer

## _Overview_
This script automates the installation of various tools and packages for a fresh Ubuntu production server using Bash.

The script is organized into sections, each responsible for installing and configuring a specific application. It is intended to be executed using the Bash interpreter. The shebang at the beginning (`#!/usr/bin/env bash`) ensures that the script is interpreted using Bash.

## _Installed Tools & Packages_

The following tools and packages will be installed by the provided script:

```bash
   1. GitHub CLI (gh): Command-line tool for interacting with GitHub repositories.
   2. NVM: Manages Node.js versions; Node.js: JavaScript runtime; npm: Package manager for Node.js.
   3. MongoDB Shell (mongosh): Interactive shell for MongoDB.
   4. MongoDB Server: NoSQL database.
   5. PM2: Process manager for Node.js applications.
   6. Nginx: Web server for HTTP content.
   7. UFW: Firewall management tool.
```

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
- Administrative privileges (`sudo` access) required.
- Ensure that the script is tested in a staging environment before deploying it to production.
- The script installs the latest versions of the tools and packages available at the time of execution by using official repositories or package managers.
- Ensure logging mechanisms are implemented in the script to capture installation steps and errors.
- If an installation step fails, users may need to troubleshoot or manually complete the installation process.
- Always check the official documentation for each tool for the most up-to-date information.
```

## _Setting Up Environment Variables_

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
1. `set -o allexport`: The environment variables defined in the `production.env` file are automatically exported ).
2. These variables are immediately available for use by the shell or any child processes.
3. `set +o allexport`: Automatic exporting is disabled after loading the environment variables, preventing unintentional exports of future variables.
