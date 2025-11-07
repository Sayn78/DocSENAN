# Guide de Configuration des Environnements de Développement

Un guide complet pour configurer plusieurs environnements de développement sur les systèmes Linux/Debian. Ce repository fournit des instructions étape par étape pour installer et configurer les langages de programmation et frameworks populaires.

## 📋 Table des Matières
- [À propos](#à-propos)
- [Prérequis](#prérequis)
- [Guides d'Installation](#guides-dinstallation)
  - [Node.js & NPM](#nodejs--npm)
  - [Python & Flask](#python--flask)
  - [Java & Maven](#java--maven)
  - [.NET](#net)
  - [PHP & Composer](#php--composer)
  - [Go](#go)
  - [Rust](#rust)
- [Vérification](#vérification)
- [Variables d'Environnement](#variables-denvironnement)
- [Dépannage](#dépannage)
- [Bonnes Pratiques de Sécurité](#bonnes-pratiques-de-sécurité)
- [Contribution](#contribution)

---

## À propos

Ce guide est conçu pour les développeurs qui doivent configurer plusieurs environnements de développement sur la même machine. Il couvre l'installation, la configuration et l'utilisation de base des langages de programmation et frameworks populaires.

**Systèmes Supportés :**
- Ubuntu 20.04+
- Debian 11+
- Autres distributions basées sur Debian

---

## Prérequis

Avant de commencer, assurez-vous d'avoir :

- **Système d'Exploitation :** Linux (basé sur Debian/Ubuntu)
- **Privilèges Utilisateur :** Accès sudo/root
- **Espace Disque :** Au moins 5 Go d'espace libre
- **Connexion Internet :** Requis pour télécharger les paquets
- **Outils de Base :** `curl`, `wget`, `git` installés

```bash
# Installer les outils de base si nécessaire
sudo apt update
sudo apt install -y curl wget git build-essential
```

---

## Guides d'Installation

### Node.js & NPM

**Version Recommandée :** LTS (Long Term Support)

```bash
# Installer NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Charger NVM
source ~/.bashrc

# Installer la dernière version LTS de Node.js
nvm install --lts

# Mettre à jour NPM vers la dernière version
npm install -g npm
```

**Vérification :**
```bash
node --version
npm --version
```

**Commandes Utiles :**
```bash
# Lister les versions installées
nvm list

# Installer une version spécifique
nvm install 18.17.0

# Utiliser une version spécifique
nvm use 18

# Définir une version par défaut
nvm alias default 18
```

---

### Python & Flask

**Version Recommandée :** Python 3.8+

```bash
# S'assurer que Python et pip sont installés
sudo apt install -y python3 python3-pip python3-venv

# Créer un environnement virtuel (recommandé)
python3 -m venv venv
source venv/bin/activate

# Vérifier vos dépendances
cat requirements.txt

# Installer toutes les dépendances
pip install -r requirements.txt
```

**Exemple de requirements.txt :**
```txt
Flask==3.0.0
Flask-SQLAlchemy==3.0.5
python-dotenv==1.0.0
```

**Exécuter une Application Flask :**
```bash
# Méthode 1
flask --app hello run

# Méthode 2
python app.py

# Avec debug mode
flask --app hello run --debug

# Sur un port spécifique
flask --app hello run --port 5001
```

**Désactiver l'environnement virtuel :**
```bash
deactivate
```

---

### Java & Maven

**Version Recommandée :** Java 11 ou 17 (versions LTS)

```bash
# Installer Java JDK
sudo apt install default-jdk

# Installer Maven
sudo apt install maven
```

**Vérification :**
```bash
java -version
javac -version
mvn --version
```

**Structure d'un projet Maven :**
```
projet-java/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
│       └── java/
```

**Exécuter une Application Spring Boot :**
```bash
# Compiler le projet
mvn clean compile

# Lancer les tests
mvn test

# Créer le package
mvn package

# Exécuter l'application
mvn spring-boot:run
```

**Commandes Maven Utiles :**
```bash
# Nettoyer le projet
mvn clean

# Installer dans le repository local
mvn install

# Afficher l'arbre de dépendances
mvn dependency:tree

# Mettre à jour les dépendances
mvn versions:display-dependency-updates
```

---

### .NET

**Version Recommandée :** .NET 9.0

```bash
# Télécharger la configuration du package Microsoft
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

# Installer la configuration du package
sudo dpkg -i packages-microsoft-prod.deb

# Nettoyer
rm packages-microsoft-prod.deb

# Mettre à jour et installer le SDK .NET
sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-9.0
```

**Vérification :**
```bash
dotnet --version
dotnet --list-sdks
dotnet --list-runtimes
```

**Créer un nouveau projet :**
```bash
# Application console
dotnet new console -n MonApp

# Application web
dotnet new web -n MonAppWeb

# API Web
dotnet new webapi -n MonAPI

# Application MVC
dotnet new mvc -n MonAppMVC
```

**Exécuter une Application .NET :**
```bash
# Restaurer les dépendances
dotnet restore

# Compiler l'application
dotnet build

# Exécuter l'application
dotnet run

# Exécuter en mode watch (rechargement automatique)
dotnet watch run
```

**Commandes .NET Utiles :**
```bash
# Publier pour la production
dotnet publish -c Release

# Ajouter un package NuGet
dotnet add package NomDuPackage

# Lister les packages
dotnet list package

# Mettre à jour les packages
dotnet restore --force
```

---

### PHP & Composer

**Version Recommandée :** PHP 8.2+

```bash
# Installer PHP et les extensions
sudo apt update && sudo apt install -y \
  php-common \
  libapache2-mod-php \
  php-cli \
  php8.2-zip \
  php8.2-xml \
  php8.2-curl \
  php8.2-mbstring \
  php8.2-mysql \
  php8.2-gd \
  unzip \
  p7zip-full
```

**Vérification :**
```bash
php --version
php -m  # Lister les modules installés
```

**Installer Composer :**
```bash
# Télécharger l'installeur Composer
curl -sS https://getcomposer.org/installer -o composer-setup.php

# Installer Composer globalement
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Nettoyer
rm composer-setup.php

# Vérifier l'installation
composer --version
```

**Configuration d'un Projet Laravel :**
```bash
# Créer un nouveau projet Laravel
composer create-project laravel/laravel mon-projet

# Ou installer les dépendances d'un projet existant
composer install

# Copier le fichier d'environnement
cp .env.example .env

# Générer la clé d'application
php artisan key:generate

# Lancer les migrations
php artisan migrate

# Lancer le serveur de développement
php artisan serve
```

**Commandes Laravel Utiles :**
```bash
# Créer un contrôleur
php artisan make:controller MonController

# Créer un modèle avec migration
php artisan make:model MonModele -m

# Vider le cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Optimiser pour la production
php artisan optimize
```

**Commandes Composer Utiles :**
```bash
# Ajouter un package
composer require vendor/package

# Mettre à jour les dépendances
composer update

# Mettre à jour Composer lui-même
composer self-update

# Afficher les packages installés
composer show

# Vérifier les problèmes
composer diagnose
```

---

### Go

**Version Recommandée :** Dernière version stable

```bash
# Télécharger Go (vérifier la dernière version sur https://go.dev/dl/)
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz

# Supprimer l'ancienne installation (si elle existe)
sudo rm -rf /usr/local/go

# Extraire et installer
sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz

# Nettoyer
rm go1.23.0.linux-amd64.tar.gz

# Ajouter Go au PATH (temporaire)
export PATH=$PATH:/usr/local/go/bin
```

**Configuration Permanente :**
```bash
# Ajouter à ~/.bashrc ou ~/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

# Recharger le fichier de configuration
source ~/.bashrc
```

**Vérification :**
```bash
go version
go env  # Afficher les variables d'environnement Go
```

**Créer un nouveau projet :**
```bash
# Créer le répertoire du projet
mkdir mon-projet-go
cd mon-projet-go

# Initialiser le module
go mod init github.com/username/mon-projet-go

# Créer le fichier main.go
cat > main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
EOF
```

**Exécuter une Application Go :**
```bash
# Télécharger les dépendances
go mod tidy

# Exécuter l'application
go run main.go

# Compiler l'application
go build

# Exécuter le binaire
./mon-projet-go
```

**Commandes Go Utiles :**
```bash
# Ajouter une dépendance
go get github.com/gin-gonic/gin

# Mettre à jour les dépendances
go get -u ./...

# Vérifier les modules
go mod verify

# Télécharger les modules
go mod download

# Nettoyer les modules inutilisés
go mod tidy

# Formater le code
go fmt ./...

# Lancer les tests
go test ./...

# Générer la documentation
go doc package.function
```

---

### Rust

**Version Recommandée :** Dernière version stable

```bash
# Installer Rust en utilisant rustup
curl https://sh.rustup.rs -sSf | sh

# Option 1 : Installation par défaut (recommandée)
# Appuyez sur 1 et Entrée

# Charger l'environnement Rust
source $HOME/.cargo/env
```

**Configuration Permanente (normalement automatique) :**
```bash
# Vérifier que ces lignes sont dans ~/.bashrc ou ~/.zshrc
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Vérification :**
```bash
rustc --version
cargo --version
rustup --version
```

**Créer un nouveau projet :**
```bash
# Créer un projet binaire
cargo new mon-projet-rust

# Créer une bibliothèque
cargo new --lib ma-lib-rust

cd mon-projet-rust
```

**Structure d'un projet Cargo :**
```
mon-projet-rust/
├── Cargo.toml        # Configuration et dépendances
├── Cargo.lock        # Versions verrouillées des dépendances
└── src/
    └── main.rs       # Code source principal
```

**Exécuter une Application Rust :**
```bash
# Compiler et exécuter
cargo run

# Compiler uniquement
cargo build

# Compiler en mode release (optimisé)
cargo build --release

# Exécuter le binaire release
./target/release/mon-projet-rust

# Vérifier le code sans compiler
cargo check
```

**Commandes Cargo Utiles :**
```bash
# Ajouter une dépendance
cargo add serde

# Mettre à jour les dépendances
cargo update

# Lancer les tests
cargo test

# Générer la documentation
cargo doc --open

# Formater le code
cargo fmt

# Linter le code
cargo clippy

# Nettoyer les fichiers de build
cargo clean

# Rechercher une crate
cargo search nom-de-la-crate
```

**Mettre à jour Rust :**
```bash
# Mettre à jour rustup et la toolchain
rustup update

# Afficher les versions installées
rustup show

# Installer une version spécifique
rustup install stable
rustup install nightly
rustup default stable
```

---

## Vérification

Après l'installation, vérifiez que chaque outil est correctement installé :

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

**Script de vérification automatique :**
```bash
#!/bin/bash
echo "=== Vérification des Environnements de Développement ==="
echo ""
echo "Node.js: $(node --version 2>/dev/null || echo '❌ Non installé')"
echo "NPM: $(npm --version 2>/dev/null || echo '❌ Non installé')"
echo ""
echo "Python: $(python3 --version 2>/dev/null || echo '❌ Non installé')"
echo "pip: $(pip3 --version 2>/dev/null | cut -d' ' -f2 || echo '❌ Non installé')"
echo ""
echo "Java: $(java -version 2>&1 | head -n 1 || echo '❌ Non installé')"
echo "Maven: $(mvn --version 2>/dev/null | head -n 1 || echo '❌ Non installé')"
echo ""
echo ".NET: $(dotnet --version 2>/dev/null || echo '❌ Non installé')"
echo ""
echo "PHP: $(php --version 2>/dev/null | head -n 1 || echo '❌ Non installé')"
echo "Composer: $(composer --version 2>/dev/null || echo '❌ Non installé')"
echo ""
echo "Go: $(go version 2>/dev/null || echo '❌ Non installé')"
echo ""
echo "Rust: $(rustc --version 2>/dev/null || echo '❌ Non installé')"
echo "Cargo: $(cargo --version 2>/dev/null || echo '❌ Non installé')"
```

Sauvegarder dans `verifier-environnements.sh`, rendre exécutable et lancer :
```bash
chmod +x verifier-environnements.sh
./verifier-environnements.sh
```

---

## Variables d'Environnement

Pour rendre les changements de PATH permanents, ajoutez-les à votre fichier de configuration shell :

### Pour les utilisateurs Bash (~/.bashrc) :
```bash
# Node.js (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Rust (ajouté automatiquement par rustup)
export PATH="$HOME/.cargo/bin:$PATH"

# NPM global packages (optionnel)
export PATH=~/.npm-global/bin:$PATH

# Python virtual environments (optionnel)
export WORKON_HOME=$HOME/.virtualenvs
```

### Pour les utilisateurs Zsh (~/.zshrc) :
Ajoutez les mêmes lignes que ci-dessus dans `~/.zshrc`

**Appliquer les changements :**
```bash
source ~/.bashrc  # ou source ~/.zshrc
```

---

## Dépannage

### Problèmes Courants

#### Node.js / NPM

**Erreurs de permissions :**
```bash
# Si vous obtenez des erreurs de permission avec npm
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH
```

**Commande NVM introuvable :**
```bash
# Charger manuellement NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Ou réinstaller NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
```

**Port déjà utilisé :**
```bash
# Trouver le processus utilisant un port (ex: 3000)
sudo lsof -i :3000

# Tuer le processus
kill -9 <PID>

# Ou utiliser un autre port
npm start -- --port 3001
```

#### Python

**pip : commande introuvable :**
```bash
# Installer pip
sudo apt install python3-pip

# Ou utiliser le module pip
python3 -m pip install package-name
```

**Erreur : externally-managed-environment :**
```bash
# Solution 1 : Utiliser un environnement virtuel (recommandé)
python3 -m venv venv
source venv/bin/activate
pip install package-name

# Solution 2 : Utiliser --break-system-packages (non recommandé)
pip install --break-system-packages package-name
```

**Module introuvable après installation :**
```bash
# Vérifier que le module est installé dans le bon environnement
pip list
which python
which pip

# Réinstaller dans l'environnement actif
pip install --force-reinstall package-name
```

#### Java / Maven

**JAVA_HOME non défini :**
```bash
# Trouver le chemin Java
readlink -f $(which java)

# Définir JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
```

**Maven : échec de téléchargement des dépendances :**
```bash
# Nettoyer le repository local
rm -rf ~/.m2/repository

# Forcer le téléchargement
mvn clean install -U
```

#### .NET

**SDK introuvable après installation :**
```bash
# Vérifier l'installation
dotnet --info

# Réinstaller si nécessaire
sudo apt-get remove dotnet-sdk-9.0
sudo apt-get install dotnet-sdk-9.0
```

#### PHP / Composer

**Erreurs de limite mémoire avec Composer :**
```bash
# Exécuter avec mémoire illimitée
php -d memory_limit=-1 /usr/local/bin/composer install

# Ou définir dans php.ini
sudo nano /etc/php/8.2/cli/php.ini
# Changer : memory_limit = 512M
```

**Extension PHP manquante :**
```bash
# Lister les extensions disponibles
apt search php8.2-

# Installer une extension
sudo apt install php8.2-extension-name

# Redémarrer le serveur web si nécessaire
sudo systemctl restart apache2  # ou nginx
```

#### Go

**go: cannot find module :**
```bash
# Initialiser le module si manquant
go mod init nom-du-module
go mod tidy

# Télécharger les modules
go mod download
```

**Permission denied lors de l'installation de packages :**
```bash
# Changer les permissions du répertoire Go
sudo chown -R $USER:$USER /usr/local/go
sudo chown -R $USER:$USER $HOME/go
```

#### Rust

**Erreurs du linker :**
```bash
# Installer les outils de build requis
sudo apt install build-essential

# Pour les projets utilisant OpenSSL
sudo apt install pkg-config libssl-dev
```

**Cargo : impossible de compiler :**
```bash
# Nettoyer et recompiler
cargo clean
cargo build

# Mettre à jour Rust
rustup update
```

### Problèmes Généraux

**Espace disque insuffisant :**
```bash
# Vérifier l'espace disque
df -h

# Nettoyer les packages inutilisés
sudo apt autoremove
sudo apt autoclean

# Nettoyer les caches spécifiques
npm cache clean --force
pip cache purge
composer clear-cache
cargo clean
go clean -modcache
```

**Connexion Internet lente ou timeouts :**
```bash
# Utiliser un miroir plus proche (APT)
sudo nano /etc/apt/sources.list

# Augmenter le timeout npm
npm config set fetch-retry-timeout 60000

# Augmenter le timeout pip
pip install --timeout 100 package-name
```

---

## Bonnes Pratiques de Sécurité

### Ne Jamais Commit les Fichiers Sensibles

Ajoutez ces fichiers à votre `.gitignore` :

```gitignore
# Fichiers d'environnement
.env
.env.local
.env.production
*.key
*.pem
config/secrets.yml

# Dépendances
node_modules/
vendor/
__pycache__/
*.pyc
.venv/
venv/
target/
Cargo.lock

# Fichiers de build
dist/
build/
*.exe
*.dll
*.so
*.dylib

# Fichiers IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Logs
*.log
logs/

# Fichiers système
.DS_Store
Thumbs.db

# Bases de données
*.sqlite
*.db
```

### Variables d'Environnement

**Créer un fichier .env.example :**
```bash
# .env.example
DATABASE_URL=postgresql://user:password@localhost/dbname
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here
PORT=3000
NODE_ENV=development
```

**Utilisation dans le code :**

**Node.js (avec dotenv) :**
```javascript
require('dotenv').config();

const dbUrl = process.env.DATABASE_URL;
const apiKey = process.env.API_KEY;
```

**Python (avec python-dotenv) :**
```python
from dotenv import load_dotenv
import os

load_dotenv()

db_url = os.getenv('DATABASE_URL')
api_key = os.getenv('API_KEY')
```

**PHP (avec vlucas/phpdotenv) :**
```php
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

$dbUrl = $_ENV['DATABASE_URL'];
$apiKey = $_ENV['API_KEY'];
```

### Mises à Jour de Sécurité

**Mettre à jour régulièrement les dépendances :**

```bash
# Node.js - Vérifier les vulnérabilités
npm audit
npm audit fix

# Mettre à jour les packages
npm update

# Python - Vérifier les vulnérabilités
pip check
pip install --upgrade pip

# Mettre à jour les packages
pip list --outdated
pip install --upgrade package-name

# PHP - Vérifier les vulnérabilités
composer audit
composer update

# Rust - Audit de sécurité
cargo install cargo-audit
cargo audit

# Go - Vérifier les vulnérabilités
go list -m all
go get -u ./...
```

### Gestion des Secrets en Production

**Ne jamais utiliser :**
- ❌ Secrets hardcodés dans le code
- ❌ Fichiers .env commités dans Git
- ❌ Secrets dans les variables d'environnement du système

**Utiliser plutôt :**
- ✅ Gestionnaires de secrets (Vault, AWS Secrets Manager, Azure Key Vault)
- ✅ Variables d'environnement injectées au runtime
- ✅ Fichiers de configuration chiffrés
- ✅ Services de gestion des clés

**Exemple avec Docker :**
```bash
# Passer les secrets via Docker secrets
docker run -e DATABASE_URL=$DATABASE_URL mon-app

# Ou utiliser un fichier de secrets
docker run --env-file .env.production mon-app
```

### Permissions des Fichiers

```bash
# Fichiers sensibles : lecture seule pour l'utilisateur
chmod 600 .env
chmod 600 *.key
chmod 600 *.pem

# Scripts exécutables
chmod 755 script.sh

# Répertoires
chmod 755 dossier/
```

---

## Structure de Projet Recommandée

```
racine-projet/
├── docs/                    # Documentation
│   ├── API.md
│   └── ARCHITECTURE.md
├── node/                    # Projets Node.js
│   ├── package.json
│   ├── package-lock.json
│   ├── .env.example
│   ├── src/
│   └── tests/
├── python/                  # Projets Python
│   ├── requirements.txt
│   ├── .env.example
│   ├── venv/
│   ├── src/
│   └── tests/
├── java/                    # Projets Java
│   ├── pom.xml
│   ├── src/
│   │   ├── main/
│   │   └── test/
│   └── target/
├── dotnet/                  # Projets .NET
│   ├── *.csproj
│   ├── *.sln
│   ├── src/
│   ├── tests/
│   └── bin/
├── php/                     # Projets PHP
│   ├── composer.json
│   ├── composer.lock
│   ├── .env.example
│   ├── src/
│   ├── vendor/
│   └── tests/
├── go/                      # Projets Go
│   ├── go.mod
│   ├── go.sum
│   ├── main.go
│   ├── cmd/
│   ├── internal/
│   └── pkg/
├── rust/                    # Projets Rust
│   ├── Cargo.toml
│   ├── Cargo.lock
│   ├── src/
│   └── target/
├── docker/                  # Fichiers Docker
│   ├── Dockerfile
│   └── docker-compose.yml
├── scripts/                 # Scripts utilitaires
│   ├── deploy.sh
│   └── backup.sh
├── .gitignore
├── .editorconfig
└── README.md
```

---

## Scripts Utiles

### Script de Vérification des Installations

Créez un script `verifier-environnements.sh` :

```bash
#!/bin/bash

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "  Vérification des Environnements"
echo "======================================"
echo ""

check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $2: $(command -v $1)"
        $3 2>&1 | head -n 1
    else
        echo -e "${RED}✗${NC} $2: Non installé"
    fi
    echo ""
}

# Node.js & NPM
check_command "node" "Node.js" "node --version"
check_command "npm" "NPM" "npm --version"

# Python & pip
check_command "python3" "Python" "python3 --version"
check_command "pip3" "pip" "pip3 --version"

# Java & Maven
check_command "java" "Java" "java -version"
check_command "mvn" "Maven" "mvn --version"

# .NET
check_command "dotnet" ".NET" "dotnet --version"

# PHP & Composer
check_command "php" "PHP" "php --version"
check_command "composer" "Composer" "composer --version"

# Go
check_command "go" "Go" "go version"

# Rust & Cargo
check_command "rustc" "Rust" "rustc --version"
check_command "cargo" "Cargo" "cargo --version"

echo "======================================"
echo "  Vérification terminée"
echo "======================================"
```

Rendre le script exécutable :
```bash
chmod +x verifier-environnements.sh
./verifier-environnements.sh
```

### Script de Nettoyage

Créez un script `nettoyer-projets.sh` :

```bash
#!/bin/bash

echo "Nettoyage des environnements de développement..."

# Fonction pour demander confirmation
confirm() {
    read -r -p "$1 [o/N] " response
    case "$response" in
        [oO][uU][iI]|[oO]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# Node.js
if confirm "Nettoyer les caches Node.js et NPM ?"; then
    echo "Nettoyage de NPM..."
    npm cache clean --force
    echo "✓ NPM nettoyé"
fi

# Python
if confirm "Nettoyer les caches Python et pip ?"; then
    echo "Nettoyage de pip..."
    pip cache purge
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
    find . -type f -name "*.pyc" -delete 2>/dev/null
    echo "✓ Python nettoyé"
fi

# Composer
if confirm "Nettoyer le cache Composer ?"; then
    echo "Nettoyage de Composer..."
    composer clear-cache
    echo "✓ Composer nettoyé"
fi

# Go
if confirm "Nettoyer les caches Go ?"; then
    echo "Nettoyage de Go..."
    go clean -modcache
    echo "✓ Go nettoyé"
fi

# Rust
if confirm "Nettoyer les builds Rust ?"; then
    echo "Nettoyage de Cargo..."
    find . -type d -name "target" -exec rm -rf {} + 2>/dev/null
    echo "✓ Rust nettoyé"
fi

# APT
if confirm "Nettoyer les packages APT inutilisés ?"; then
    echo "Nettoyage APT..."
    sudo apt autoremove -y
    sudo apt autoclean -y
    echo "✓ APT nettoyé"
fi

echo ""
echo "Nettoyage terminé !"
echo "Espace disque libéré :"
df -h / | tail -1
```

Rendre le script exécutable :
```bash
chmod +x nettoyer-projets.sh
./nettoyer-projets.sh
```

---

## Contribution

Les contributions sont les bienvenues ! Veuillez :

1. **Fork** le repository
2. Créer une branche de fonctionnalité (`git checkout -b feature/amelioration`)
3. **Commiter** vos changements (`git commit -am 'Ajout nouvelle fonctionnalité'`)
4. **Pusher** vers la branche (`git push origin feature/amelioration`)
5. Ouvrir une **Pull Request**

### Guidelines de Contribution

- Testez vos modifications sur un système propre
- Documentez les nouvelles fonctionnalités
- Suivez le style de documentation existant
- Mettez à jour la table des matières si nécessaire

---

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## Ressources Complémentaires

### Documentation Officielle

- [Node.js Documentation](https://nodejs.org/docs/)
- [Python Documentation](https://docs.python.org/fr/)
- [Java Documentation](https://docs.oracle.com/en/java/)
- [.NET Documentation](https://docs.microsoft.com/fr-fr/dotnet/)
- [PHP Documentation](https://www.php.net/manual/fr/)
- [Go Documentation](https://go.dev/doc/)
- [Rust Documentation](https://doc.rust-lang.org/book/fr/)

### Tutoriels et Guides

- [MDN Web Docs](https://developer.mozilla.org/fr/)
- [freeCodeCamp](https://www.freecodecamp.org/)
- [W3Schools](https://www.w3schools.com/)
- [Dev.to](https://dev.to/)
- [Stack Overflow](https://stackoverflow.com/)

### Outils Recommandés

- **IDE/Éditeurs :** VS Code, IntelliJ IDEA, PyCharm, WebStorm
- **Terminaux :** Terminator, iTerm2, Windows Terminal
- **Gestionnaires de versions :** Git, GitHub, GitLab, Bitbucket
- **Conteneurisation :** Docker, Podman, LXC
- **Monitoring :** htop, glances, netdata

---

**Dernière Mise à Jour :** Novembre 2025

**Mainteneur :** Votre Nom

**Support :** Pour toute question ou problème, ouvrez une [issue](https://github.com/votre-username/repo/issues)

---

<div align="center">

**⭐ Si ce guide vous a été utile, n'hésitez pas à mettre une étoile !**

</div>
