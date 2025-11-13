# 🐍 Python venv - Environnements Virtuels

## 📋 Table des Matières
- [Introduction](#introduction)
- [Pourquoi utiliser venv ?](#pourquoi-utiliser-venv)
- [Installation](#installation)
- [Création d'un environnement virtuel](#création-dun-environnement-virtuel)
- [Activation et Désactivation](#activation-et-désactivation)
- [Gestion des dépendances](#gestion-des-dépendances)
- [Bonnes pratiques](#bonnes-pratiques)
- [Commandes utiles](#commandes-utiles)
- [Troubleshooting](#troubleshooting)

---

## Introduction

`venv` est un module Python intégré qui permet de créer des environnements virtuels isolés. Il est inclus par défaut dans Python 3.3 et versions ultérieures.

## Pourquoi utiliser venv ?

### Avantages
- ✅ **Isolation des dépendances** : Chaque projet a ses propres packages
- ✅ **Évite les conflits de versions** : Python 2 vs Python 3, différentes versions de packages
- ✅ **Reproductibilité** : Facilite le partage et le déploiement
- ✅ **Pas de pollution globale** : Installation système reste propre
- ✅ **Gestion de permissions** : Pas besoin de sudo pour installer des packages

### Cas d'usage
```
Projet A : Django 3.2 + Python 3.8
Projet B : Django 4.2 + Python 3.11
→ Sans venv, impossible d'avoir les deux versions simultanément
```

---

## Installation

### Vérifier si venv est disponible

```bash
python3 --version
python3 -m venv --help
```

### Installation si nécessaire

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install python3-venv
```

#### Fedora/RHEL/CentOS
```bash
sudo dnf install python3-virtualenv
# ou
sudo yum install python3-virtualenv
```

#### macOS
```bash
# venv est inclus avec Python 3
# Si besoin, installer via Homebrew
brew install python3
```

#### Windows
```powershell
# venv est inclus avec Python 3
# Télécharger depuis python.org si nécessaire
```

---

## Création d'un environnement virtuel

### Syntaxe de base

```bash
python3 -m venv <nom_environnement>
```

### Exemples pratiques

```bash
# Créer un environnement nommé "venv"
python3 -m venv venv

# Créer un environnement nommé "myenv"
python3 -m venv myenv

# Créer avec une version spécifique de Python
python3.11 -m venv venv311

# Créer dans un dossier spécifique
python3 -m venv /chemin/vers/mon_projet/venv
```

### Options avancées

```bash
# Sans pip (installer manuellement plus tard)
python3 -m venv --without-pip venv

# Avec accès aux packages système
python3 -m venv --system-site-packages venv

# Mise à niveau des packages de base
python3 -m venv --upgrade venv

# Avec des prompts personnalisés
python3 -m venv --prompt="MonProjet" venv
```

---

## Activation et Désactivation

### Linux / macOS

#### Activation
```bash
# Bash/Zsh
source venv/bin/activate

# Fish
source venv/bin/activate.fish

# Csh
source venv/bin/activate.csh
```

#### Vérification
```bash
# Le prompt change pour indiquer l'environnement actif
(venv) user@machine:~/project$

# Vérifier le chemin Python
which python
# Output: /chemin/vers/projet/venv/bin/python
```

#### Désactivation
```bash
deactivate
```

### Windows

#### Activation
```powershell
# PowerShell
.\venv\Scripts\Activate.ps1

# CMD
.\venv\Scripts\activate.bat
```

#### Si erreur de politique d'exécution (PowerShell)
```powershell
# Autoriser temporairement
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# Puis activer
.\venv\Scripts\Activate.ps1
```

#### Désactivation
```powershell
deactivate
```

---

## Gestion des dépendances

### Installer des packages

```bash
# Activer l'environnement d'abord
source venv/bin/activate

# Installer un package
pip install requests

# Installer une version spécifique
pip install django==4.2.0

# Installer plusieurs packages
pip install flask sqlalchemy pandas
```

### Fichier requirements.txt

#### Créer un fichier requirements.txt
```bash
# Exporter les dépendances installées
pip freeze > requirements.txt
```

#### Exemple de requirements.txt
```txt
Django==4.2.7
requests==2.31.0
python-dotenv==1.0.0
psycopg2-binary==2.9.9
celery==5.3.4
```

#### Installer depuis requirements.txt
```bash
pip install -r requirements.txt
```

### Mise à jour des packages

```bash
# Mettre à jour un package
pip install --upgrade requests

# Mettre à jour tous les packages
pip list --outdated
pip install --upgrade <package_name>
```

---

## Bonnes pratiques

### 1. Nommage de l'environnement

```bash
# Recommandé : utiliser "venv" ou ".venv"
python3 -m venv venv
python3 -m venv .venv  # Caché sur Linux/macOS
```

### 2. Fichier .gitignore

**Toujours exclure venv de Git !**

```gitignore
# .gitignore
venv/
.venv/
env/
ENV/
*.pyc
__pycache__/
.env
```

### 3. Documentation du projet

**README.md**
```markdown
## Installation

1. Créer l'environnement virtuel
   ```bash
   python3 -m venv venv
   ```

2. Activer l'environnement
   ```bash
   source venv/bin/activate  # Linux/macOS
   .\venv\Scripts\activate   # Windows
   ```

3. Installer les dépendances
   ```bash
   pip install -r requirements.txt
   ```
```

### 4. Structure de projet recommandée

```
mon_projet/
├── venv/                 # Environnement virtuel (non versionné)
├── src/                  # Code source
│   └── main.py
├── tests/                # Tests
├── requirements.txt      # Dépendances
├── .gitignore
├── .env.example          # Template de variables d'environnement
└── README.md
```

### 5. Gestion de plusieurs environnements

```bash
# Développement
python3 -m venv venv-dev
pip install -r requirements-dev.txt

# Production
python3 -m venv venv-prod
pip install -r requirements.txt

# Tests
python3 -m venv venv-test
pip install -r requirements-test.txt
```

### 6. Scripts d'automatisation

**setup.sh (Linux/macOS)**
```bash
#!/bin/bash
echo "🐍 Configuration de l'environnement Python..."

# Créer venv
python3 -m venv venv

# Activer
source venv/bin/activate

# Installer dépendances
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ Environnement prêt !"
```

**setup.ps1 (Windows)**
```powershell
Write-Host "🐍 Configuration de l'environnement Python..." -ForegroundColor Green

# Créer venv
python -m venv venv

# Activer
.\venv\Scripts\Activate.ps1

# Installer dépendances
pip install --upgrade pip
pip install -r requirements.txt

Write-Host "✅ Environnement prêt !" -ForegroundColor Green
```

---

## Commandes utiles

### Informations sur l'environnement

```bash
# Version de Python utilisée
python --version

# Chemin de l'exécutable Python
which python     # Linux/macOS
where python     # Windows

# Liste des packages installés
pip list

# Détails d'un package
pip show django

# Packages obsolètes
pip list --outdated

# Vérifier les dépendances
pip check
```

### Nettoyage et maintenance

```bash
# Désinstaller un package
pip uninstall requests

# Désinstaller tous les packages
pip freeze | xargs pip uninstall -y

# Nettoyer le cache pip
pip cache purge

# Supprimer l'environnement
deactivate
rm -rf venv  # Linux/macOS
rmdir /s venv  # Windows
```

### Export et import

```bash
# Export avec hashes pour la sécurité
pip freeze --all > requirements-full.txt

# Export seulement les dépendances principales
pip list --not-required --format=freeze > requirements.txt

# Import avec vérification des hashes
pip install --require-hashes -r requirements.txt
```

---

## Troubleshooting

### Problème : venv n'est pas reconnu

**Solution Ubuntu/Debian**
```bash
sudo apt install python3-venv
```

### Problème : Permission denied lors de l'activation (Windows)

**Solution PowerShell**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Problème : pip n'est pas disponible dans venv

**Solution**
```bash
# Réinstaller pip dans le venv
python -m ensurepip --upgrade
# ou
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
```

### Problème : Mauvaise version de Python dans venv

**Solution**
```bash
# Spécifier la version lors de la création
python3.11 -m venv venv

# Ou utiliser pyenv pour gérer plusieurs versions
pyenv local 3.11.0
python -m venv venv
```

### Problème : venv trop volumineux

**Solution**
```bash
# Ne pas inclure les packages système
python3 -m venv --without-pip venv

# Nettoyer le cache
pip cache purge

# Utiliser des alternatives légères
pip install pipdeptree  # Analyser les dépendances
```

### Problème : Conflits de dépendances

**Solution**
```bash
# Utiliser pip-tools pour gérer les dépendances
pip install pip-tools

# Créer requirements.in
echo "django>=4.0" > requirements.in

# Compiler les dépendances
pip-compile requirements.in

# Installer
pip-sync requirements.txt
```

---

## Alternatives à venv

### virtualenv
Plus ancien, plus de fonctionnalités
```bash
pip install virtualenv
virtualenv venv
```

### conda
Gestion de Python et packages non-Python
```bash
conda create -n myenv python=3.11
conda activate myenv
```

### pipenv
Combine pip et virtualenv
```bash
pip install pipenv
pipenv install django
pipenv shell
```

### poetry
Gestion moderne des dépendances
```bash
curl -sSL https://install.python-poetry.org | python3 -
poetry new mon_projet
poetry add django
```

---

## Ressources

- 📖 [Documentation officielle venv](https://docs.python.org/3/library/venv.html)
- 📖 [Guide pip](https://pip.pypa.io/en/stable/)
- 📖 [PEP 405 - Python Virtual Environments](https://www.python.org/dev/peps/pep-0405/)

---

[⬆ Retour en haut](#-python-venv---environnements-virtuels)
