# 🏗️ Terraform – Guide Complet

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Installation](#-installation)
- [Configuration AWS](#-configuration-aws)
- [Premiers pas](#-premiers-pas)
- [Commandes essentielles](#-commandes-essentielles)
- [Structure de fichiers](#-structure-de-fichiers)
- [Ressources avancées](#-ressources-avancées)
- [State Management](#-state-management)
- [Modules](#-modules)
- [Bonnes pratiques](#-bonnes-pratiques)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**Terraform** est un outil d'Infrastructure as Code (IaC) développé par HashiCorp permettant de :
- ✅ Définir l'infrastructure dans des fichiers de configuration
- ✅ Gérer des ressources multi-cloud (AWS, Azure, GCP, etc.)
- ✅ Versionner et collaborer sur l'infrastructure
- ✅ Automatiser les déploiements
- ✅ Détecter et corriger les dérives de configuration

### Concepts clés
- **Provider** : Plugin pour interagir avec un service cloud (AWS, Azure, etc.)
- **Resource** : Composant d'infrastructure (VM, réseau, base de données)
- **State** : Fichier suivant l'état actuel de l'infrastructure
- **Module** : Ensemble de ressources réutilisables
- **Variable** : Paramètres configurables
- **Output** : Valeurs exportées après déploiement

---

## 📥 Installation

### Prérequis
```bash
# Mettre à jour le système
sudo apt update && sudo apt upgrade -y

# Installer les dépendances
sudo apt install -y wget unzip curl gnupg software-properties-common
```

---

### Méthode 1 : Installation manuelle (version spécifique)

```bash
# Définir la version souhaitée
TERRAFORM_VERSION="1.7.0"

# Télécharger Terraform
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Extraire l'archive
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Déplacer le binaire
sudo mv terraform /usr/local/bin/

# Nettoyer
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Vérifier l'installation
terraform --version
```

---

### Méthode 2 : Installation via le dépôt HashiCorp (recommandée)

```bash
# Ajouter la clé GPG HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Vérifier l'empreinte de la clé
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

# Ajouter le dépôt HashiCorp
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

# Mettre à jour et installer
sudo apt update
sudo apt install terraform

# Vérifier
terraform --version
```

---

### Configuration de l'autocomplétion (optionnel)

```bash
# Pour Bash
terraform -install-autocomplete

# Recharger le shell
source ~/.bashrc

# Pour Zsh
terraform -install-autocomplete
source ~/.zshrc
```

---

## ☁️ Configuration AWS

### Prérequis AWS
- Compte AWS actif
- Accès à IAM pour créer des utilisateurs
- Permissions nécessaires (EC2, VPC, S3, etc.)

---

### Étape 1 : Installer AWS CLI

```bash
# Télécharger et installer AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Vérifier
aws --version

# Nettoyer
rm -rf aws awscliv2.zip
```

---

### Étape 2 : Créer un utilisateur IAM (Console AWS)

1. **Accéder à IAM** : AWS Console → IAM → Users → Add users
2. **Créer l'utilisateur** :
   - Nom : `terraform-user`
   - Access type : ✅ Programmatic access
3. **Attacher les permissions** :
   - Option 1 (simple) : `AdministratorAccess` ⚠️ Pour tests uniquement
   - Option 2 (recommandée) : Créer une politique personnalisée avec uniquement les permissions nécessaires
4. **Récupérer les clés** :
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - ⚠️ **Sauvegarder immédiatement** (elles ne s'affichent qu'une fois)

---

### Étape 3 : Configurer les identifiants AWS

#### Méthode 1 : Via AWS CLI (recommandée)
```bash
# Configuration interactive
aws configure

# Saisir les informations demandées :
# AWS Access Key ID: AKIAIOSFODNN7EXAMPLE
# AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Default region name: eu-west-3
# Default output format: json
```

#### Méthode 2 : Fichier de configuration manuel
```bash
# Créer le dossier de configuration
mkdir -p ~/.aws

# Créer le fichier credentials
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
EOF

# Créer le fichier config
cat > ~/.aws/config << EOF
[default]
region = eu-west-3
output = json
EOF

# Protéger les fichiers
chmod 600 ~/.aws/credentials
chmod 600 ~/.aws/config
```

#### Méthode 3 : Variables d'environnement (temporaire)
```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="eu-west-3"

# Vérifier
aws sts get-caller-identity
```

---

### Étape 4 : Générer une paire de clés SSH

#### Sur Linux/macOS
```bash
# Générer la clé SSH
ssh-keygen -t rsa -b 4096 -f ~/.ssh/<nom_cle_ssh> -C "votre.email@example.com"

# Exemples
ssh-keygen -t rsa -b 4096 -f ~/.ssh/aws_terraform_key -C "admin@example.com"
ssh-keygen -t ed25519 -f ~/.ssh/aws_key_ed25519 -C "admin@example.com"

# Protéger la clé privée
chmod 400 ~/.ssh/<nom_cle_ssh>

# Afficher la clé publique
cat ~/.ssh/<nom_cle_ssh>.pub
```

#### Sur Windows (PowerShell)
```powershell
# Générer la clé SSH
ssh-keygen -t rsa -b 4096 -f C:\Users\<VOTRE_UTILISATEUR>\.ssh\<nom_cle_ssh>

# Exemple
ssh-keygen -t rsa -b 4096 -f C:\Users\John\.ssh\aws_terraform_key

# Afficher la clé publique
type C:\Users\<VOTRE_UTILISATEUR>\.ssh\<nom_cle_ssh>.pub
```

---

### Étape 5 : Importer la clé publique dans AWS

#### Via Console AWS (Interface Web)
1. AWS Console → **EC2** → **Key Pairs** (menu gauche)
2. Cliquer sur **"Import key pair"**
3. **Name** : `<nom_cle_ssh>` (ex: `aws_terraform_key`)
4. **Key pair file** : Copier le contenu du fichier `.pub`
   ```bash
   cat ~/.ssh/<nom_cle_ssh>.pub
   ```
5. Cliquer sur **"Import key pair"**

#### Via AWS CLI
```bash
# Importer la clé publique
aws ec2 import-key-pair \
    --key-name "<nom_cle_ssh>" \
    --public-key-material fileb://~/.ssh/<nom_cle_ssh>.pub \
    --region eu-west-3

# Vérifier
aws ec2 describe-key-pairs --region eu-west-3
```

#### Via Terraform (automatique)
```hcl
resource "aws_key_pair" "<nom_ressource>" {
  key_name   = "<nom_cle_ssh>"
  public_key = file("~/.ssh/<nom_cle_ssh>.pub")
}
```

---

## 🚀 Premiers Pas

### Structure d'un projet Terraform de base

```bash
# Créer un dossier de projet
mkdir -p ~/terraform-projects/premier-projet
cd ~/terraform-projects/premier-projet
```

---

### Fichier main.tf – Configuration de base EC2

```hcl
# Déclaration du provider AWS
provider "aws" {
  region = "eu-west-3"  # Paris
}

# Ressource : Instance EC2
resource "aws_instance" "mon_serveur_web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 22.04 LTS eu-west-3
  instance_type = "t2.micro"               # Instance gratuite (Free Tier)
  key_name      = "<nom_cle_ssh>"          # Nom de votre clé SSH importée dans AWS
  
  # Groupe de sécurité (firewall)
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  
  # Tags pour identifier la ressource
  tags = {
    Name        = "MonServeurWeb"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
  
  # User data : script exécuté au démarrage
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Serveur déployé avec Terraform</h1>" > /var/www/html/index.html
              EOF
}

# Groupe de sécurité : autoriser SSH et HTTP
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Autoriser SSH et HTTP"
  
  # Règle entrante : SSH (port 22)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Restreindre en production (votre IP uniquement)
  }
  
  # Règle entrante : HTTP (port 80)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Règle sortante : tout autoriser
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow_ssh_http"
  }
}

# Output : afficher l'IP publique après déploiement
output "instance_public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.mon_serveur_web.public_ip
}

output "ssh_connection" {
  description = "Commande SSH pour se connecter"
  value       = "ssh -i ~/.ssh/<nom_cle_ssh> ubuntu@${aws_instance.mon_serveur_web.public_ip}"
}
```

---

## 🎮 Commandes Essentielles

### Cycle de vie de base

```bash
# 1. Initialiser le projet
terraform init
# - Télécharge les providers nécessaires
# - Initialise le backend (state)
# - Prépare les modules

# 2. Formater le code (optionnel)
terraform fmt
# - Reformate automatiquement les fichiers .tf
# - Applique le style HashiCorp

# 3. Valider la configuration
terraform validate
# - Vérifie la syntaxe
# - Détecte les erreurs de configuration

# 4. Planifier les changements
terraform plan
# - Affiche ce qui sera créé/modifié/détruit
# - Ne modifie rien
# - Permet de vérifier avant d'appliquer

# 5. Appliquer la configuration
terraform apply
# - Crée/modifie l'infrastructure
# - Demande confirmation (taper "yes")

# 6. Appliquer sans confirmation
terraform apply -auto-approve

# 7. Voir l'état actuel
terraform show

# 8. Lister les ressources
terraform state list

# 9. Détruire l'infrastructure
terraform destroy
# - Supprime toutes les ressources gérées
# - Demande confirmation

# 10. Détruire sans confirmation
terraform destroy -auto-approve
```

---

### Commandes avancées

```bash
# Sauvegarder le plan dans un fichier
terraform plan -out=tfplan
terraform apply tfplan

# Cibler une ressource spécifique
terraform apply -target=aws_instance.mon_serveur_web
terraform destroy -target=aws_instance.mon_serveur_web

# Rafraîchir l'état sans modification
terraform refresh

# Importer une ressource existante
terraform import aws_instance.mon_serveur_web i-1234567890abcdef0

# Afficher les outputs
terraform output
terraform output instance_public_ip

# Créer un graphique de dépendances
terraform graph | dot -Tpng > graph.png

# Déboguer
TF_LOG=DEBUG terraform apply
TF_LOG=TRACE terraform plan

# Verrouiller l'état (éviter modifications concurrentes)
terraform force-unlock <LOCK_ID>

# Remplacer une ressource (destroy + create)
terraform taint aws_instance.mon_serveur_web
terraform apply

# Annuler un taint
terraform untaint aws_instance.mon_serveur_web
```

---

## 📁 Structure de Fichiers

### Organisation recommandée

```
mon-projet-terraform/
├── main.tf              # Ressources principales
├── variables.tf         # Déclaration des variables
├── outputs.tf           # Valeurs exportées
├── terraform.tfvars     # Valeurs des variables (ne pas commiter si secrets)
├── versions.tf          # Versions des providers
├── backend.tf           # Configuration du backend (state)
├── providers.tf         # Configuration des providers
├── modules/             # Modules réutilisables
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/        # Configurations par environnement
│   ├── dev/
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   ├── staging/
│   └── production/
├── .gitignore
└── README.md
```

---

### Fichier variables.tf

```hcl
# variables.tf

# Variable : Région AWS
variable "aws_region" {
  description = "Région AWS pour les ressources"
  type        = string
  default     = "eu-west-3"
}

# Variable : Type d'instance
variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t2.micro"
}

# Variable : Nom de la clé SSH
variable "key_name" {
  description = "Nom de la clé SSH"
  type        = string
}

# Variable : AMI ID
variable "ami_id" {
  description = "ID de l'AMI Ubuntu"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

# Variable : Tags communs
variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "Development"
  }
}

# Variable : Liste d'IPs autorisées pour SSH
variable "allowed_ssh_ips" {
  description = "Liste des IPs autorisées pour SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # ⚠️ Restreindre en production
}
```

---

### Fichier terraform.tfvars

```hcl
# terraform.tfvars
# ⚠️ Ne JAMAIS commiter ce fichier s'il contient des secrets

aws_region  = "eu-west-3"
instance_type = "t2.micro"
key_name    = "aws_terraform_key"
ami_id      = "ami-0c55b159cbfafe1f0"

common_tags = {
  ManagedBy   = "Terraform"
  Environment = "Development"
  Project     = "MonProjet"
  Owner       = "Equipe DevOps"
}

allowed_ssh_ips = [
  "203.0.113.0/24",  # Votre réseau d'entreprise
  "198.51.100.42/32" # Votre IP personnelle
]
```

---

### Fichier outputs.tf

```hcl
# outputs.tf

output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.mon_serveur_web.id
}

output "instance_public_ip" {
  description = "IP publique de l'instance"
  value       = aws_instance.mon_serveur_web.public_ip
}

output "instance_private_ip" {
  description = "IP privée de l'instance"
  value       = aws_instance.mon_serveur_web.private_ip
}

output "ssh_connection" {
  description = "Commande SSH pour se connecter"
  value       = "ssh -i ~/.ssh/${var.key_name} ubuntu@${aws_instance.mon_serveur_web.public_ip}"
}

output "security_group_id" {
  description = "ID du groupe de sécurité"
  value       = aws_security_group.allow_ssh_http.id
}
```

---

### Fichier versions.tf

```hcl
# versions.tf

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

### Fichier .gitignore

```bash
# .gitignore pour Terraform

# State files
*.tfstate
*.tfstate.*
*.tfstate.backup

# Crash logs
crash.log
crash.*.log

# Variables sensibles
terraform.tfvars
*.auto.tfvars
secrets.tfvars

# Override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# CLI configuration
.terraformrc
terraform.rc

# Directories
.terraform/
.terraform.lock.hcl

# Plans
*.tfplan

# SSH keys
*.pem
*.pub
```

---

## 🔧 Ressources Avancées

### Exemple : VPC complet

```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(
    var.common_tags,
    {
      Name = "main-vpc"
    }
  )
}

# Subnet publique
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  
  tags = merge(
    var.common_tags,
    {
      Name = "public-subnet"
      Type = "Public"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.common_tags,
    {
      Name = "main-igw"
    }
  )
}

# Table de routage
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = merge(
    var.common_tags,
    {
      Name = "public-route-table"
    }
  )
}

# Association subnet <-> route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

---

### Exemple : RDS (Base de données)

```hcl
resource "aws_db_instance" "postgres" {
  identifier = "myapp-db"
  
  engine         = "postgres"
  engine_version = "15.3"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true
  
  db_name  = "myappdb"
  username = "admin"
  password = var.db_password  # ⚠️ Utiliser AWS Secrets Manager en production
  
  vpc_security_group_ids = [aws_security_group.database.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  
  skip_final_snapshot       = false
  final_snapshot_identifier = "myapp-db-final-snapshot"
  
  tags = merge(
    var.common_tags,
    {
      Name = "myapp-database"
    }
  )
}
```

---

## 💾 State Management

### Backend S3 + DynamoDB (recommandé pour production)

```hcl
# backend.tf

terraform {
  backend "s3" {
    bucket         = "mon-terraform-state-bucket"
    key            = "projet/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### Créer le backend (une seule fois)

```bash
# Créer le bucket S3
aws s3api create-bucket \
    --bucket mon-terraform-state-bucket \
    --region eu-west-3 \
    --create-bucket-configuration LocationConstraint=eu-west-3

# Activer le versioning
aws s3api put-bucket-versioning \
    --bucket mon-terraform-state-bucket \
    --versioning-configuration Status=Enabled

# Créer la table DynamoDB pour le verrouillage
aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region eu-west-3
```

---

## 📦 Modules

### Créer un module réutilisable

```hcl
# modules/ec2-instance/main.tf

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
```

### Utiliser un module

```hcl
# main.tf

module "serveur_web" {
  source = "./modules/ec2-instance"
  
  instance_name = "MonServeurWeb"
  instance_type = "t2.micro"
  ami_id        = "ami-0c55b159cbfafe1f0"
  key_name      = var.key_name
}

output "web_server_ip" {
  value = module.serveur_web.public_ip
}
```

---

## ✅ Bonnes Pratiques

### Sécurité

```hcl
# 1. Ne jamais hardcoder de secrets
# ❌ Mauvais
resource "aws_db_instance" "db" {
  password = "MonMotDePasse123!"
}

# ✅ Bon
resource "aws_db_instance" "db" {
  password = var.db_password
}

# 2. Utiliser des groupes de sécurité restrictifs
# ❌ Mauvais
cidr_blocks = ["0.0.0.0/0"]

# ✅ Bon
cidr_blocks = var.allowed_ips

# 3. Chiffrer les données
storage_encrypted = true

# 4. Activer les logs
enable_cloudwatch_logs_exports = ["postgresql", "upgrade"]
```

### Organisation

```hcl
# 1. Utiliser des variables pour tout ce qui peut changer
# 2. Séparer les environnements (dev, staging, prod)
# 3. Utiliser des modules pour la réutilisabilité
# 4. Versionner le code avec Git
# 5. Utiliser un backend distant (S3)
# 6. Documenter avec des descriptions
# 7. Utiliser des tags cohérents
# 8. Préfixer les noms de ressources
```

---

## 🚨 Dépannage

### Problème : Permission denied (SSH)

```bash
# Solution : Corriger les permissions de la clé
chmod 400 ~/.ssh/<nom_cle_ssh>

# Vérifier
ls -l ~/.ssh/<nom_cle_ssh>
# Devrait afficher : -r-------- 1 user user ... 
```

---

### Problème : Connection timeout (SSH)

**Causes possibles :**
1. Le groupe de sécurité ne permet pas le port 22
2. L'instance n'a pas d'IP publique
3. Pas d'Internet Gateway dans le VPC

**Solutions :**

```bash
# 1. Vérifier le groupe de sécurité
aws ec2 describe-security-groups --group-ids <security-group-id>

# 2. Vérifier l'instance
aws ec2 describe-instances --instance-ids <instance-id>

# 3. Ajouter une règle SSH au groupe de sécurité
aws ec2 authorize-security-group-ingress \
    --group-id <security-group-id> \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0  # ⚠️ Restreindre à votre IP en production
```

---

### Problème : Error acquiring state lock

```bash
# Si le verrouillage persiste après une interruption
terraform force-unlock <LOCK_ID>

# Trouver le LOCK_ID dans le message d'erreur
```

---

### Problème : Resource already exists

```bash
# Importer la ressource existante dans l'état
terraform import <type_ressource>.<nom> <id_aws>

# Exemple
terraform import aws_instance.mon_serveur_web i-1234567890abcdef0
```

---

### Problème : Provider configuration not present

```bash
# Réinitialiser le projet
rm -rf .terraform .terraform.lock.hcl
terraform init
```

---

### Problème : Insufficient permissions (IAM)

**Solution :** Ajouter les permissions manquantes à l'utilisateur IAM

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "vpc:*",
        "rds:*",
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## 🔌 Connexion SSH à l'instance

### Commande de connexion

```bash
# Format général
ssh -i ~/.ssh/<nom_cle_ssh> <utilisateur>@<ip_publique>

# Exemples
ssh -i ~/.ssh/aws_terraform_key ubuntu@203.0.113.42
ssh -i ~/.ssh/aws_terraform_key ec2-user@198.51.100.100

# Avec verbose (debug)
ssh -v -i ~/.ssh/<nom_cle_ssh> ubuntu@<ip_publique>

# Depuis Windows
ssh -i C:\Users\<UTILISATEUR>\.ssh\<nom_cle_ssh> ubuntu@<ip_publique>
```

### Utilisateurs par défaut selon l'AMI

| AMI | Utilisateur |
|-----|-------------|
| Ubuntu | `ubuntu` |
| Amazon Linux | `ec2-user` |
| Amazon Linux 2 | `ec2-user` |
| Debian | `admin` |
| CentOS | `centos` |
| RHEL | `ec2-user` |
| SUSE | `ec2-user` |
| Fedora | `fedora` |

### Récupérer l'IP publique avec Terraform

```bash
# Afficher tous les outputs
terraform output

# Afficher une output spécifique
terraform output instance_public_ip

# Connexion automatique via output
$(terraform output -raw ssh_connection)
```

---

## 📊 AMI IDs par Région

### Ubuntu 22.04 LTS (x86_64)

| Région | AMI ID | Code Région |
|--------|--------|-------------|
| Paris | `ami-0c55b159cbfafe1f0` | eu-west-3 |
| Ireland | `ami-0d71ea30463e0ff8d` | eu-west-1 |
| Frankfurt | `ami-0a1ee2fb28fe05df3` | eu-central-1 |
| London | `ami-0b45ae66668865cd6` | eu-west-2 |
| N. Virginia | `ami-0c7217cdde317cfec` | us-east-1 |
| Ohio | `ami-0900fe555666598a2` | us-east-2 |

### Trouver les AMIs les plus récentes

```bash
# Via AWS CLI
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --query 'Images | sort_by(@, &CreationDate) | [-1].[ImageId,Name,CreationDate]' \
    --output table \
    --region eu-west-3

# Avec jq pour un meilleur formatage
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
    --region eu-west-3 | jq -r '.Images | sort_by(.CreationDate) | last | .ImageId'
```

### Utiliser une data source pour l'AMI (recommandé)

```hcl
# Récupérer automatiquement la dernière AMI Ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "mon_serveur_web" {
  ami           = data.aws_ami.ubuntu.id  # Utilise l'AMI la plus récente
  instance_type = "t2.micro"
  # ...
}
```

---

## 🎯 Cas d'Usage Pratiques

### Exemple 1 : Stack LAMP (Linux, Apache, MySQL, PHP)

```hcl
# main.tf

resource "aws_instance" "lamp_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
  key_name      = var.key_name
  
  vpc_security_group_ids = [aws_security_group.lamp.id]
  
  user_data = <<-EOF
              #!/bin/bash
              # Mise à jour
              apt update && apt upgrade -y
              
              # Installation Apache
              apt install -y apache2
              
              # Installation MySQL
              apt install -y mysql-server
              mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${var.mysql_root_password}';"
              
              # Installation PHP
              apt install -y php libapache2-mod-php php-mysql
              
              # Configuration Apache
              systemctl enable apache2
              systemctl start apache2
              
              # Test PHP
              echo "<?php phpinfo(); ?>" > /var/www/html/info.php
              
              # Page d'accueil
              echo "<h1>Serveur LAMP déployé avec Terraform</h1>" > /var/www/html/index.html
              EOF
  
  tags = {
    Name = "LAMP-Server"
  }
}

resource "aws_security_group" "lamp" {
  name = "lamp-security-group"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "lamp_server_url" {
  value = "http://${aws_instance.lamp_server.public_ip}"
}
```

---

### Exemple 2 : Application avec Load Balancer

```hcl
# Application Load Balancer
resource "aws_lb" "app" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  
  tags = {
    Name = "app-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "app" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 30
  }
}

# Listener
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "app-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  
  vpc_security_group_ids = [aws_security_group.app.id]
  
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt update
              apt install -y nginx
              echo "<h1>Instance: $(hostname)</h1>" > /var/www/html/index.html
              systemctl start nginx
              EOF
  )
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "app-asg"
  min_size            = 2
  max_size            = 5
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  target_group_arns   = [aws_lb_target_group.app.arn]
  
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
}

output "load_balancer_dns" {
  value = aws_lb.app.dns_name
}
```

---

### Exemple 3 : Infrastructure Multi-Environnements

```bash
# Structure de dossiers
terraform-project/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── rds/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── production/
│       ├── main.tf
│       ├── terraform.tfvars
│       └── backend.tf
```

```hcl
# environments/dev/main.tf

module "vpc" {
  source = "../../modules/vpc"
  
  environment = "dev"
  cidr_block  = "10.0.0.0/16"
}

module "ec2" {
  source = "../../modules/ec2"
  
  environment   = "dev"
  instance_type = "t2.micro"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
}

module "rds" {
  source = "../../modules/rds"
  
  environment     = "dev"
  instance_class  = "db.t3.micro"
  allocated_storage = 20
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
}
```

```hcl
# environments/dev/terraform.tfvars

aws_region = "eu-west-3"
environment = "dev"
instance_type = "t2.micro"
db_instance_class = "db.t3.micro"
```

```hcl
# environments/production/terraform.tfvars

aws_region = "eu-west-3"
environment = "production"
instance_type = "t3.large"
db_instance_class = "db.r5.xlarge"
```

---

## 🔄 Workspaces (Environnements Légers)

```bash
# Lister les workspaces
terraform workspace list

# Créer un nouveau workspace
terraform workspace new dev
terraform workspace new staging
terraform workspace new production

# Basculer entre workspaces
terraform workspace select dev
terraform workspace select production

# Voir le workspace actuel
terraform workspace show

# Supprimer un workspace
terraform workspace delete dev
```

### Utiliser les workspaces dans le code

```hcl
# main.tf

locals {
  environment = terraform.workspace
  
  instance_types = {
    dev        = "t2.micro"
    staging    = "t2.small"
    production = "t3.large"
  }
  
  db_instance_classes = {
    dev        = "db.t3.micro"
    staging    = "db.t3.small"
    production = "db.r5.xlarge"
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_types[local.environment]
  
  tags = {
    Name        = "app-${local.environment}"
    Environment = local.environment
  }
}
```

---

## 🔐 Gestion des Secrets

### Méthode 1 : AWS Secrets Manager

```hcl
# Créer un secret
resource "aws_secretsmanager_secret" "db_password" {
  name = "myapp-db-password-${var.environment}"
  
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

# Utiliser le secret
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
}

resource "aws_db_instance" "main" {
  password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
  # ...
}
```

---

### Méthode 2 : Variables d'environnement

```bash
# Définir des variables d'environnement
export TF_VAR_db_password="SuperSecretPassword123!"
export TF_VAR_aws_access_key="AKIAIOSFODNN7EXAMPLE"

# Terraform les utilisera automatiquement
terraform apply
```

---

### Méthode 3 : Fichier .tfvars séparé

```bash
# secrets.tfvars (ajouté au .gitignore)
db_password = "SuperSecretPassword123!"
api_key     = "sk-1234567890abcdef"

# Utilisation
terraform apply -var-file="secrets.tfvars"
```

---

## 📈 Monitoring et Logging

### CloudWatch Logs

```hcl
# Log group CloudWatch
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ec2/myapp"
  retention_in_days = 7
}

# IAM Role pour CloudWatch
resource "aws_iam_role" "cloudwatch" {
  name = "ec2-cloudwatch-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "cloudwatch" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.cloudwatch.name
}

# Instance avec CloudWatch
resource "aws_instance" "monitored" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.cloudwatch.name
  
  user_data = <<-EOF
              #!/bin/bash
              # Installer CloudWatch Agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i -E ./amazon-cloudwatch-agent.deb
              
              # Configuration CloudWatch
              cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<'EOC'
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/syslog",
                          "log_group_name": "/aws/ec2/myapp",
                          "log_stream_name": "{instance_id}"
                        }
                      ]
                    }
                  }
                }
              }
              EOC
              
              # Démarrer l'agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -s \
                -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json
              EOF
}
```

---

## 🧪 Tests et Validation

### Terraform Validate

```bash
# Vérifier la syntaxe
terraform validate

# Avec sortie JSON
terraform validate -json
```

---

### Terraform Plan avec fichier de sortie

```bash
# Sauvegarder le plan
terraform plan -out=tfplan

# Afficher le plan en lisible
terraform show tfplan

# Afficher en JSON
terraform show -json tfplan | jq
```

---

### TFLint (Linter pour Terraform)

```bash
# Installer TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Initialiser
tflint --init

# Lancer le linting
tflint

# Avec configuration personnalisée
cat > .tflint.hcl <<EOF
plugin "aws" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_instance_previous_type" {
  enabled = true
}
EOF

tflint
```

---

### Terratest (Tests automatisés)

```go
// test/terraform_aws_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformAwsInstance(t *testing.T) {
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        TerraformDir: "../",
    })
    
    defer terraform.Destroy(t, terraformOptions)
    
    terraform.InitAndApply(t, terraformOptions)
    
    instanceID := terraform.Output(t, terraformOptions, "instance_id")
    assert.NotEmpty(t, instanceID)
}
```

---

## 🔄 CI/CD avec Terraform

### GitHub Actions

```yaml
# .github/workflows/terraform.yml

name: Terraform

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v3
    
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.7.0
    
    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: eu-west-3
    
    - name: Terraform Format
      run: terraform fmt -check
    
    - name: Terraform Init
      run: terraform init
    
    - name: Terraform Validate
      run: terraform validate
    
    - name: Terraform Plan
      run: terraform plan
    
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: terraform apply -auto-approve
```

---

### GitLab CI

```yaml
# .gitlab-ci.yml

stages:
  - validate
  - plan
  - apply

variables:
  TF_ROOT: ${CI_PROJECT_DIR}
  TF_VERSION: 1.7.0

before_script:
  - apt-get update -qq && apt-get install -y -qq wget unzip
  - wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
  - unzip terraform_${TF_VERSION}_linux_amd64.zip
  - mv terraform /usr/local/bin/
  - terraform --version

validate:
  stage: validate
  script:
    - cd ${TF_ROOT}
    - terraform init -backend=false
    - terraform validate
    - terraform fmt -check

plan:
  stage: plan
  script:
    - cd ${TF_ROOT}
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - ${TF_ROOT}/tfplan

apply:
  stage: apply
  script:
    - cd ${TF_ROOT}
    - terraform init
    - terraform apply -auto-approve tfplan
  when: manual
  only:
    - main
```

---

## 📚 Ressources Complémentaires

### Documentation Officielle
- [Terraform Documentation](https://www.terraform.io/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)

### Outils Utiles
- **Terragrunt** : Wrapper pour gérer plusieurs environnements
- **Atlantis** : Terraform Pull Request Automation
- **Infracost** : Estimation des coûts cloud
- **Checkov** : Scanner de sécurité pour IaC
- **Terraform Cloud** : Service managé par HashiCorp

### Commandes de Référence Rapide

```bash
# Installation & Configuration
terraform init                  # Initialiser
terraform version              # Version

# Développement
terraform fmt                  # Formater
terraform validate             # Valider
terraform console              # Console interactive

# Déploiement
terraform plan                 # Planifier
terraform apply                # Appliquer
terraform destroy              # Détruire

# État
terraform show                 # Afficher l'état
terraform state list           # Lister les ressources
terraform state show <ressource> # Détails d'une ressource
terraform refresh              # Rafraîchir l'état

# Outputs
terraform output               # Tous les outputs
terraform output <nom>         # Output spécifique

# Import
terraform import <type>.<nom> <id> # Importer une ressource

# Workspaces
terraform workspace list       # Lister
terraform workspace new <nom>  # Créer
terraform workspace select <nom> # Sélectionner

# Debug
TF_LOG=DEBUG terraform apply   # Mode debug
terraform graph                # Graphique de dépendances
```

---

## 🎓 Exercices Pratiques

### Exercice 1 : Instance EC2 de base
Créez une instance EC2 avec Nginx installé automatiquement.

### Exercice 2 : VPC personnalisé
Créez un VPC avec des subnets publics et privés.

### Exercice 3 : Application 3-tiers
Déployez une application avec :
- Load Balancer
- Serveurs web (Auto Scaling)
- Base de données RDS

### Exercice 4 : Infrastructure multi-environnements
Créez des modules réutilisables pour dev, staging et production.

---

**🎉 Félicitations ! Vous maîtrisez maintenant les bases et concepts avancés de Terraform !**
