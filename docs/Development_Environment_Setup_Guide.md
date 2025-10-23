# Development Environment Setup Guide

This guide provides installation and setup instructions for various development environments and frameworks.

## Table of Contents
- [Node.js & NPM](#nodejs--npm)
- [Python & Flask](#python--flask)
- [Java & Maven](#java--maven)
- [.NET](#net)
- [PHP & Composer](#php--composer)
- [Go](#go)
- [Rust](#rust)

---

## Node.js & NPM

### Install Node.js using NVM

```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM
source ~/.bashrc

# Install latest LTS version of Node.js
nvm install --lts
```

### Update NPM

```bash
npm install -g npm
```

---

## Python & Flask

### Install Dependencies

```bash
# Check your dependencies
cat requirements.txt

# Install all requirements
pip install -r requirements.txt
```

### Run Flask Application

```bash
flask --app hello run
```

---

## Java & Maven

### Install Java JDK

```bash
sudo apt install default-jdk
```

### Install Maven

```bash
sudo apt install maven
```

### Run Spring Boot Application

```bash
mvn spring-boot:run
```

---

## .NET

### Install .NET SDK 9.0

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

### Run .NET Application

```bash
# Restore dependencies
dotnet restore

# Run the application
dotnet run
```

---

## PHP & Composer

### Install PHP

```bash
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

### Install Composer

```bash
# Download Composer installer
curl -sS https://getcomposer.org/installer -o composer-setup.php

# Install Composer globally
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
```

### Setup Laravel Project

```bash
# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate
```

---

## Go

### Install Go

```bash
# Download Go
wget https://go.dev/dl/go1.25.0.linux-amd64.tar.gz

# Remove old installation (if exists)
sudo rm -rf /usr/local/go

# Extract and install
sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz

# Add Go to PATH
export PATH=$PATH:/usr/local/go/bin
```

**Note:** Add `export PATH=$PATH:/usr/local/go/bin` to your `~/.bashrc` or `~/.profile` to make it permanent.

### Run Go Application

```bash
# Download dependencies
go mod tidy

# Run the application
go run main.go
```

---

## Rust

### Install Rust

```bash
# Install Rust using rustup
curl https://sh.rustup.rs -sSf | sh

# Load Rust environment
source $HOME/.cargo/env
```

### Run Rust Application

```bash
cargo run
```

---

## Contributing

Feel free to submit issues or pull requests if you find any problems or have suggestions for improvements.

## License

[Add your license information here]
