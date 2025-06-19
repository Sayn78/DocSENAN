# Installation et Configuration de Terraform sur Ubuntu

Ce guide explique comment installer et configurer **Terraform** sur une machine virtuelle Ubuntu. Terraform est un outil d'infrastructure as code (IaC) permettant de gérer des ressources cloud via des fichiers de configuration.

## Prérequis

Avant d'installer Terraform, assurez-vous d'avoir les éléments suivants :

- Une machine virtuelle Ubuntu avec un accès SSH.
- Un compte utilisateur avec des privilèges `sudo`.

- 
## Étape 1 : Mise à jour des paquets système

Avant d'installer Terraform, il est recommandé de mettre à jour les paquets de votre système pour garantir que vous disposez des dernières versions des outils nécessaires. Exécutez la commande suivante :

```bash
sudo apt update && sudo apt upgrade -y
```

## Étape 2 : Installation de Terraform

### 2.1 : Télécharger Terraform

```bash
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
```

### 2.2 : Installer unzip

```bash
sudo apt install unzip -y
```

### 2.3 : Extraire le fichier ZIP

```bash
unzip terraform_1.6.0_linux_amd64.zip
```

### 2.4 : Déplacer le binaire Terraform

```bash
sudo mv terraform /usr/local/bin/
```

### 2.5 : Vérifier l'installation

```bash
terraform --version
```

## Étape 3 : Configuration de Terraform sur AWS

## Prérequis
Avant de configurer Terraform pour AWS, assurez-vous de disposer des éléments suivants :

Terraform installé (si ce n'est pas déjà fait, suivez ce guide).

Un compte AWS actif avec les bonnes autorisations.

Les clés d'accès AWS (AWS_ACCESS_KEY_ID et AWS_SECRET_ACCESS_KEY) que vous pouvez obtenir dans la section IAM de la console AWS.

### 3.1 : Configurer les identifiants AWS

```bash
aws configure
```
Cela vous demandera votre AWS Access Key ID, AWS Secret Access Key, et la région par défaut. Vous pouvez également définir un profil si nécessaire.



### 3.2 Générer une paire de clés SSH sur Windows ou Linux

Sur Windows :
```bash
ssh-keygen -t rsa -b 4096 -f C:\Users\TON_UTILISATEUR\.ssh\votrecleSSH

```

Sur Linux :
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/votrecleSSH
```

### 3.3 Importer la clé publique dans AWS (console web)

Va sur AWS EC2 > Key Pairs

Clique sur “Import key pair”

Donne un nom (ex. votrecleSSH)

Ouvre le fichier votrecleSSH.pub avec un éditeur de texte

Copie/colle son contenu dans le champ "Public key contents"

Valide


### 3.4 : Créer un fichier de configuration Terraform (serveur web aws EC2)

```bash
provider "aws" {
  region = "eu-west-3" #Paris
}

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx" # ← rentrer une AMI proposer par AWS
  instance_type = "t2.micro"
  key_name      = "votrecleSSH" # ← rentrer votre clé SSH (nom du fichier dans ~/.ssh)

  tags = {
    Name = "server1" # ← rentrer le nom de votre serveur web
  }
}
```

### 3.5 : Initialiser le projet Terraform et verifier le plan

```bash
terraform init
terraform plan
```

### 3.6 : Appliquer la configuration

```bash
terraform apply
```


Tu as maintenant une nouvelle instance sur AWS de créer (instance EC2)


### 3.7 : connection SSH

```bash
ssh -i ~/.ssh/votrecleSSH.pem ubuntu@<IP_PUBLIQUE>
```
L’utilisateur par défaut dépend de l’AMI :

Ubuntu : ubuntu

Amazon Linux : ec2-user

## 🚨 Problèmes fréquents (ssh via une machine linux):

### 🔒 Permission denied → les droits sur la clé .pem ne sont pas bons :

```bash
chmod 400 ~/.ssh/ta-cle.pem
```

### 🚫 Connection timeout → le groupe de sécurité n'autorise pas le port 22.
Va sur la console AWS → EC2 → Security Groups
