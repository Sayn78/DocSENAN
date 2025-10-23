# Development Environment Setup Guide

A comprehensive guide for setting up multiple development environments on Linux/Debian-based systems. This repository provides step-by-step instructions for installing and configuring popular programming languages and frameworks.

## 📋 Table of Contents
- [About](#about)
- [Prerequisites](#prerequisites)
- [Installation Guides](#installation-guides)
  - [Node.js & NPM](#nodejs--npm)
  - [Python & Flask](#python--flask)
  - [Java & Maven](#java--maven)
  - [.NET](#net)
  - [PHP & Composer](#php--composer)
  - [Go](#go)
  - [Rust](#rust)
- [Verification](#verification)
- [Environment Variables](#environment-variables)
- [Troubleshooting](#troubleshooting)
- [Security Best Practices](#security-best-practices)
- [Contributing](#contributing)

---

## About

This guide is designed for developers who need to set up multiple development environments on the same machine. It covers installation, configuration, and basic usage of popular programming languages and frameworks.

**Supported Systems:**
- Ubuntu 20.04+
- Debian 11+
- Other Debian-based distributions

---

## Prerequisites

Before starting, ensure you have:

- **Operating System:** Linux (Debian/Ubuntu based)
- **User Privileges:** sudo/root access
- **Disk Space:** At least 5GB free space
- **Internet Connection:** Required for downloading packages
- **Basic Tools:** `curl`, `wget`, `git` installed

```bash
# Install basic tools if needed
sudo apt update
sudo apt install -y curl wget git build-essential
```

---

## Installation Guides

### Node.js & NPM

**Recommended Version:** LTS (Long Term Support)

```bash
# Install NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM
source ~/.bashrc

# Install latest LTS version of Node.js
nvm install --lts

# Update NPM to latest version
npm install -g npm
```

---

### Python & Flask

**Recommended Version:** Python 3.8+

```bash
# Ensure Python and pip are installed
sudo apt install -y python3 python3-pip python3-venv

# Create virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate

# Check your dependencies
cat requirements.txt

# Install all requirements
pip install -r requirements.txt
```

**Run Flask Application:**
```bash
flask --app hello run
```

---

### Java & Maven

**Recommended Version:** Java 11 or 17 (LTS versions)

```bash
# Install Java JDK
sudo apt install default-jdk

# Install Maven
sudo apt install maven
```

**Run Spring Boot Application:**
```bash
mvn spring-boot:run
```

---

### .NET

**Recommended Version:** .NET 9.0

```bash
# Download Microsoft package configuration
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Install package configuration
sudo dpkg -i packages-microsoft-prod.deb

# Clean up
rm packages-microsoft-prod.deb

# Update and install .NET SDK
sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-9.0
```

**Run .NET Application:**
```bash
# Restore dependencies
dotnet restore

# Run the application
dotnet run
```

---

### PHP & Composer

**Recommended Version:** PHP 8.2+

```bash
# Install PHP and extensions
sudo apt update && sudo apt install -y \
  php-common \
  libapache2-mod-php \
  php-cli \
  php8.2-zip \
  php8.2-xml \
  php8.2-curl \
  php8.2-mbstring \
  unzip \
  p7zip-full
```

**Install Composer:**
```bash
# Download Composer installer
curl -sS https://getcomposer.org/installer -o composer-setup.php

# Install Composer globally
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Clean up
rm composer-setup.php
```

**Setup Laravel Project:**
```bash
# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate
```

---

### Go

**Recommended Version:** Latest stable release

```bash
# Download Go
wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz

# Remove old installation (if exists)
sudo rm -rf /usr/local/go

# Extract and install
sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz

# Clean up
rm go1.25.0.linux-amd64.tar.gz

# Add Go to PATH (temporary)
export PATH=$PATH:/usr/local/go/bin
```

**Run Go Application:**
```bash
# Download dependencies
go mod tidy

# Run the application
go run main.go
```

---

### Rust

**Recommended Version:** Latest stable release

```bash
# Install Rust using rustup
curl https://sh.rustup.rs -sSf | sh

# Follow the prompts, then load Rust environment
source $HOME/.cargo/env
```

**Run Rust Application:**
```bash
cargo run
```

---

## Verification

After installation, verify each tool is properly installed:

```bash
# Node.js & NPM
node --version
npm --version

# Python & pip
python3 --version
pip3 --version

# Java & Maven
java -version
mvn --version

# .NET
dotnet --version

# PHP & Composer
php --version
composer --version

# Go
go version

# Rust
rustc --version
cargo --version
```

---

## Environment Variables

To make PATH changes permanent, add them to your shell configuration file:

### For Bash users (~/.bashrc):
```bash
# Go
export PATH=$PATH:/usr/local/go/bin

# Rust (usually added automatically)
export PATH=$HOME/.cargo/bin:$PATH

# Custom Go workspace (optional)
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

### For Zsh users (~/.zshrc):
Add the same lines as above to `~/.zshrc`

**Apply changes:**
```bash
source ~/.bashrc  # or source ~/.zshrc
```

---

## Troubleshooting

### Common Issues

**Permission Denied Errors:**
```bash
# If you get permission errors with npm
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

**NVM command not found:**
```bash
# Manually load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

**Port Already in Use:**
```bash
# Find process using port (e.g., 3000)
sudo lsof -i :3000

# Kill process
kill -9 <PID>
```

**Composer: memory limit errors:**
```bash
# Run with unlimited memory
php -d memory_limit=-1 /usr/local/bin/composer install
```

**Go: cannot find module:**
```bash
# Initialize go module if missing
go mod init <module-name>
go mod tidy
```

**Rust: linker errors:**
```bash
# Install required build tools
sudo apt install build-essential
```

---

## Security Best Practices

### Never Commit Sensitive Files
Add these to your `.gitignore`:
```
.env
.env.local
*.key
*.pem
config/secrets.yml
node_modules/
vendor/
__pycache__/
*.pyc
.venv/
venv/
target/
```

### Environment Variables
- Use `.env.example` as a template with dummy values
- Never hardcode credentials in source code
- Use secret management tools for production (Vault, AWS Secrets Manager, etc.)

### Dependencies
```bash
# Regularly update dependencies
npm audit fix          # Node.js
pip install --upgrade  # Python
composer update        # PHP
cargo update           # Rust
go get -u              # Go
```

---

## Project Structure

```
project-root/
├── node/                 # Node.js projects
│   ├── package.json
│   └── node_modules/
├── python/              # Python projects
│   ├── requirements.txt
│   └── venv/
├── java/                # Java projects
│   ├── pom.xml
│   └── src/
├── dotnet/              # .NET projects
│   ├── *.csproj
│   └── bin/
├── php/                 # PHP projects
│   ├── composer.json
│   └── vendor/
├── go/                  # Go projects
│   ├── go.mod
│   └── main.go
├── rust/                # Rust projects
│   ├── Cargo.toml
│   └── src/
└── README.md
```

---

## Useful Scripts

### Check All Installations
Create a script `check-versions.sh`:
```bash
#!/bin/bash
echo "=== Development Environment Versions ==="
echo "Node: $(node --version 2>/dev/null || echo 'Not installed')"
echo "NPM: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
echo "Java: $(java -version 2>&1 | head -n 1 || echo 'Not installed')"
echo ".NET: $(dotnet --version 2>/dev/null || echo 'Not installed')"
echo "PHP: $(php --version 2>/dev/null | head -n 1 || echo 'Not installed')"
echo "Go: $(go version 2>/dev/null || echo 'Not installed')"
echo "Rust: $(rustc --version 2>/dev/null || echo 'Not installed')"
```

Make it executable:
```bash
chmod +x check-versions.sh
./check-versions.sh
```

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/improvement`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Additional Resources

- [Node.js Documentation](https://nodejs.org/docs/)
- [Python Documentation](https://docs.python.org/)
- [Java Documentation](https://docs.oracle.com/en/java/)
- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [PHP Documentation](https://www.php.net/docs.php)
- [Go Documentation](https://go.dev/doc/)
- [Rust Documentation](https://doc.rust-lang.org/)

---

**Last Updated:** October 2025
