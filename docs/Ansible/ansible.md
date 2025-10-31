# 🔧 Ansible – Guide Complet

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Installation](#-installation)
- [Configuration de base](#-configuration-de-base)
- [Inventory](#-inventory)
- [Modules essentiels](#-modules-essentiels)
- [Playbooks](#-playbooks)
- [Variables](#-variables)
- [Roles](#-roles)
- [Ansible Vault](#-ansible-vault)
- [Exemple pratique : Nginx + Docker](#-exemple-pratique--nginx--docker)
- [Bonnes pratiques](#-bonnes-pratiques)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**Ansible** est un outil d'automatisation IT open-source permettant de :
- ✅ **Configurer** des serveurs (Configuration Management)
- ✅ **Déployer** des applications
- ✅ **Orchestrer** des tâches complexes
- ✅ **Provisionner** l'infrastructure
- ✅ **Automatiser** les workflows

### Pourquoi Ansible ?

- 🚀 **Simple** : Basé sur YAML, lisible et facile
- 🔓 **Agentless** : Pas d'agent à installer sur les serveurs cibles
- 🔌 **SSH natif** : Utilise SSH pour la communication
- 📦 **Idempotent** : Peut être exécuté plusieurs fois sans effet secondaire
- 🌐 **Multi-plateforme** : Linux, Windows, Cloud, Réseau
- 📚 **Riche** : +3000 modules disponibles

### Cas d'usage

- Configuration automatisée de serveurs
- Déploiements d'applications
- Gestion de configuration
- Orchestration cloud (AWS, Azure, GCP)
- CI/CD pipelines
- Compliance et sécurité

---

## 📥 Installation

### Ubuntu/Debian

```bash
# Méthode 1 : Via apt (Recommandée)
sudo apt update
sudo apt install ansible -y

# Vérifier l'installation
ansible --version

# Méthode 2 : Via PPA (dernière version)
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
```

---

### CentOS/RHEL/Fedora

```bash
# CentOS/RHEL 8+
sudo dnf install ansible -y

# CentOS/RHEL 7
sudo yum install epel-release -y
sudo yum install ansible -y

# Fedora
sudo dnf install ansible -y

# Vérifier
ansible --version
```

---

### macOS

```bash
# Via Homebrew
brew install ansible

# Vérifier
ansible --version
```

---

### Via pip (Multi-plateforme)

```bash
# Installer pip si nécessaire
sudo apt install python3-pip -y

# Installer Ansible
pip3 install ansible

# Ou avec virtualenv (recommandé)
python3 -m venv ansible-env
source ansible-env/bin/activate
pip install ansible

# Vérifier
ansible --version
```

---

### Configuration post-installation

```bash
# Créer le dossier de configuration
mkdir -p ~/.ansible

# Fichier de configuration global (optionnel)
sudo mkdir -p /etc/ansible
sudo touch /etc/ansible/ansible.cfg
sudo touch /etc/ansible/hosts

# Vérifier la configuration
ansible --version
ansible-config dump

# Lister les modules disponibles
ansible-doc -l
```

---

## ⚙️ Configuration de Base

### Fichier ansible.cfg

```ini
# ansible.cfg
[defaults]
# Inventory par défaut
inventory = ./inventory.ini

# Désactiver la vérification des clés SSH
host_key_checking = False

# Nombre de processus parallèles
forks = 10

# Timeout SSH
timeout = 30

# Utilisateur SSH par défaut
remote_user = ubuntu

# Clé SSH privée par défaut
private_key_file = ~/.ssh/id_rsa

# Logs
log_path = ./ansible.log

# Affichage
stdout_callback = yaml
display_skipped_hosts = False

# Privilèges
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[ssh_connection]
# Pipelining pour améliorer les performances
pipelining = True
# Timeout de connexion
timeout = 10
```

### Hiérarchie des fichiers de configuration

Ansible cherche les fichiers de configuration dans cet ordre :
1. `ANSIBLE_CONFIG` (variable d'environnement)
2. `./ansible.cfg` (répertoire courant)
3. `~/.ansible.cfg` (home de l'utilisateur)
4. `/etc/ansible/ansible.cfg` (global)

---

## 📋 Inventory

Le fichier **inventory** contient la liste des serveurs à gérer.

### Inventory simple

```ini
# inventory.ini

# Serveur unique
web1.example.com

# Avec options SSH
web2.example.com ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/mykey

# Avec IP
192.168.1.10 ansible_user=admin
```

---

### Inventory avec groupes

```ini
# inventory.ini

# Groupe de serveurs web
[webservers]
web1.example.com
web2.example.com
web3.example.com

# Groupe de bases de données
[databases]
db1.example.com ansible_user=ubuntu
db2.example.com ansible_user=ubuntu

# Groupe de serveurs AWS
[aws_servers]
ec2-XX-XX-XX-XX.eu-west-3.compute.amazonaws.com ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws_key.pem

# Groupe parent
[production:children]
webservers
databases

# Variables de groupe
[webservers:vars]
ansible_user=ubuntu
ansible_port=22
http_port=80

[databases:vars]
ansible_user=postgres
db_port=5432
```

---

### Inventory YAML

```yaml
# inventory.yml
all:
  children:
    webservers:
      hosts:
        web1.example.com:
        web2.example.com:
      vars:
        ansible_user: ubuntu
        http_port: 80
    
    databases:
      hosts:
        db1.example.com:
          ansible_user: postgres
        db2.example.com:
          ansible_user: postgres
      vars:
        db_port: 5432
    
    production:
      children:
        webservers:
        databases:
```

---

### Variables d'inventory

```ini
# Connexion SSH
ansible_host=192.168.1.10
ansible_port=2222
ansible_user=admin
ansible_ssh_private_key_file=~/.ssh/mykey
ansible_ssh_pass=password        # ⚠️ Non recommandé
ansible_become=yes
ansible_become_method=sudo
ansible_become_user=root
ansible_become_pass=password     # ⚠️ Utiliser Vault

# Python
ansible_python_interpreter=/usr/bin/python3

# Connexion
ansible_connection=ssh           # ssh, local, docker
```

---

### Commandes d'inventory

```bash
# Lister les hosts
ansible all --list-hosts -i inventory.ini
ansible webservers --list-hosts -i inventory.ini

# Voir l'inventory complet
ansible-inventory -i inventory.ini --list
ansible-inventory -i inventory.ini --graph

# Tester la connexion
ansible all -m ping -i inventory.ini
ansible webservers -m ping -i inventory.ini

# Commande ad-hoc
ansible all -m shell -a "uptime" -i inventory.ini
ansible webservers -m apt -a "name=nginx state=present" -i inventory.ini
```

---

## 🧩 Modules Essentiels

### Modules de commande

```bash
# Commande simple
ansible all -m shell -a "ls -la /var/www"

# Commande avec become
ansible all -m shell -a "apt update" --become

# Command (plus sûr que shell)
ansible all -m command -a "uptime"

# Script
ansible all -m script -a "./mon_script.sh"
```

---

### Modules système

```yaml
# Package management
- name: Installer nginx (apt)
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Installer plusieurs paquets
  apt:
    name:
      - nginx
      - git
      - curl
    state: present

- name: Installer avec yum
  yum:
    name: httpd
    state: present

# Service
- name: Démarrer et activer nginx
  service:
    name: nginx
    state: started
    enabled: yes

- name: Redémarrer le service
  service:
    name: nginx
    state: restarted

# User
- name: Créer un utilisateur
  user:
    name: deploy
    state: present
    groups: sudo
    shell: /bin/bash
    create_home: yes

# Group
- name: Créer un groupe
  group:
    name: developers
    state: present
```

---

### Modules fichiers

```yaml
# File
- name: Créer un répertoire
  file:
    path: /var/www/html
    state: directory
    mode: '0755'
    owner: www-data
    group: www-data

- name: Créer un fichier
  file:
    path: /etc/config.txt
    state: touch
    mode: '0644'

- name: Créer un lien symbolique
  file:
    src: /etc/nginx/sites-available/default
    dest: /etc/nginx/sites-enabled/default
    state: link

# Copy
- name: Copier un fichier
  copy:
    src: files/index.html
    dest: /var/www/html/index.html
    mode: '0644'
    owner: www-data

# Template (avec Jinja2)
- name: Template de configuration
  template:
    src: templates/nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    mode: '0644'
  notify: restart nginx

# Fetch (copier depuis remote vers local)
- name: Récupérer un fichier
  fetch:
    src: /var/log/app.log
    dest: ./logs/
    flat: yes
```

---

### Modules réseau

```yaml
# Get URL
- name: Télécharger un fichier
  get_url:
    url: https://example.com/file.tar.gz
    dest: /tmp/file.tar.gz
    mode: '0644'

# URI (API REST)
- name: Appel API
  uri:
    url: https://api.example.com/status
    method: GET
    return_content: yes
  register: api_response

# Wait for
- name: Attendre qu'un port soit ouvert
  wait_for:
    port: 80
    delay: 10
    timeout: 300
```

---

### Modules Docker

```yaml
# Docker container
- name: Lancer un conteneur nginx
  docker_container:
    name: nginx
    image: nginx:latest
    state: started
    restart_policy: always
    ports:
      - "80:80"
    volumes:
      - /var/www/html:/usr/share/nginx/html

# Docker image
- name: Pull une image
  docker_image:
    name: postgres:15
    source: pull

# Docker network
- name: Créer un réseau
  docker_network:
    name: app_network

# Docker volume
- name: Créer un volume
  docker_volume:
    name: db_data
```

---

## 📘 Playbooks

Les **Playbooks** sont des fichiers YAML définissant une série de tâches à exécuter.

### Structure d'un Playbook

```yaml
# playbook.yml
---
- name: Description du play
  hosts: webservers
  become: yes
  vars:
    http_port: 80
  
  tasks:
    - name: Tâche 1
      module:
        param: value
    
    - name: Tâche 2
      module:
        param: value
```

---

### Playbook complet

```yaml
# site.yml
---
- name: Configuration des serveurs web
  hosts: webservers
  become: yes
  vars:
    nginx_port: 80
    app_user: www-data
  
  pre_tasks:
    - name: Mettre à jour le cache apt
      apt:
        update_cache: yes
        cache_valid_time: 3600
  
  tasks:
    - name: Installer nginx
      apt:
        name: nginx
        state: present
    
    - name: Créer le répertoire web
      file:
        path: /var/www/html
        state: directory
        owner: "{{ app_user }}"
        group: "{{ app_user }}"
        mode: '0755'
    
    - name: Copier la page d'accueil
      copy:
        src: files/index.html
        dest: /var/www/html/index.html
        owner: "{{ app_user }}"
        mode: '0644'
      notify: restart nginx
    
    - name: Démarrer nginx
      service:
        name: nginx
        state: started
        enabled: yes
  
  handlers:
    - name: restart nginx
      service:
        name: nginx
        state: restarted
  
  post_tasks:
    - name: Vérifier que nginx répond
      uri:
        url: "http://localhost:{{ nginx_port }}"
        status_code: 200
```

---

### Exécution de Playbooks

```bash
# Exécution simple
ansible-playbook playbook.yml

# Avec inventory spécifique
ansible-playbook -i inventory.ini playbook.yml

# Avec variables
ansible-playbook playbook.yml -e "nginx_port=8080"
ansible-playbook playbook.yml -e "@vars.yml"

# Dry-run (check mode)
ansible-playbook playbook.yml --check

# Voir les différences
ansible-playbook playbook.yml --check --diff

# Limiter à certains hosts
ansible-playbook playbook.yml --limit webservers
ansible-playbook playbook.yml --limit web1.example.com

# Démarrer à une tâche spécifique
ansible-playbook playbook.yml --start-at-task="Installer nginx"

# Tags
ansible-playbook playbook.yml --tags "install,configure"
ansible-playbook playbook.yml --skip-tags "deploy"

# Verbose
ansible-playbook playbook.yml -v      # Verbose
ansible-playbook playbook.yml -vv     # Plus verbose
ansible-playbook playbook.yml -vvv    # Très verbose
ansible-playbook playbook.yml -vvvv   # Debug complet
```

---

## 🔢 Variables

### Définir des variables

```yaml
# Dans le playbook
---
- name: Mon playbook
  hosts: all
  vars:
    http_port: 80
    app_name: "myapp"
  tasks:
    - name: Afficher une variable
      debug:
        msg: "Port: {{ http_port }}"

# Dans un fichier externe
vars_files:
  - vars/common.yml
  - vars/{{ env }}.yml

# Dans l'inventory
[webservers:vars]
http_port=80

# En ligne de commande
ansible-playbook play.yml -e "http_port=8080"
ansible-playbook play.yml -e "@vars.yml"
```

---

### Types de variables

```yaml
# String
app_name: "myapp"

# Number
http_port: 80

# Boolean
enable_https: true

# List
packages:
  - nginx
  - git
  - curl

# Dictionary
database:
  host: localhost
  port: 5432
  name: mydb

# Multi-line
config: |
  server {
    listen 80;
    server_name example.com;
  }
```

---

### Utiliser les variables

```yaml
# Simple
{{ variable }}

# Avec filtres
{{ variable | default('valeur_defaut') }}
{{ variable | upper }}
{{ variable | lower }}
{{ list | length }}
{{ dict | to_json }}
{{ dict | to_yaml }}

# Conditions
"{{ 'yes' if condition else 'no' }}"

# Dans les tâches
- name: Installer {{ package_name }}
  apt:
    name: "{{ package_name }}"
    state: present

# Liste
- name: Installer des paquets
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - nginx
    - git
    - curl

# Dictionary
- name: Créer des utilisateurs
  user:
    name: "{{ item.name }}"
    groups: "{{ item.groups }}"
  loop:
    - { name: 'alice', groups: 'sudo' }
    - { name: 'bob', groups: 'users' }
```

---

### Facts (variables automatiques)

```bash
# Voir tous les facts
ansible all -m setup

# Voir un fact spécifique
ansible all -m setup -a "filter=ansible_distribution"

# Facts communs
{{ ansible_hostname }}
{{ ansible_default_ipv4.address }}
{{ ansible_distribution }}
{{ ansible_distribution_version }}
{{ ansible_os_family }}
{{ ansible_processor_cores }}
{{ ansible_memtotal_mb }}
```

```yaml
# Utilisation dans un playbook
- name: Afficher des infos système
  debug:
    msg: "OS: {{ ansible_distribution }} {{ ansible_distribution_version }}"

# Désactiver la collecte de facts (plus rapide)
- name: Mon playbook
  hosts: all
  gather_facts: no
  tasks:
    # ...
```

---

## 📦 Roles

Les **Roles** permettent d'organiser les playbooks en composants réutilisables.

### Structure d'un Role

```
roles/
└── nginx/
    ├── tasks/
    │   └── main.yml
    ├── handlers/
    │   └── main.yml
    ├── templates/
    │   └── nginx.conf.j2
    ├── files/
    │   └── index.html
    ├── vars/
    │   └── main.yml
    ├── defaults/
    │   └── main.yml
    ├── meta/
    │   └── main.yml
    └── README.md
```

---

### Créer un Role

```bash
# Créer la structure
ansible-galaxy init roles/nginx

# Structure générée
roles/nginx/
├── defaults/
│   └── main.yml          # Variables par défaut
├── files/                # Fichiers statiques
├── handlers/
│   └── main.yml          # Handlers
├── meta/
│   └── main.yml          # Métadonnées et dépendances
├── tasks/
│   └── main.yml          # Tâches principales
├── templates/            # Templates Jinja2
├── tests/
│   ├── inventory
│   └── test.yml
└── vars/
    └── main.yml          # Variables du role
```

---

### Exemple de Role : nginx

```yaml
# roles/nginx/defaults/main.yml
---
nginx_port: 80
nginx_user: www-data
nginx_worker_processes: auto

# roles/nginx/vars/main.yml
---
nginx_config_path: /etc/nginx/nginx.conf

# roles/nginx/tasks/main.yml
---
- name: Installer nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Créer le répertoire web
  file:
    path: /var/www/html
    state: directory
    owner: "{{ nginx_user }}"
    mode: '0755'

- name: Copier la configuration
  template:
    src: nginx.conf.j2
    dest: "{{ nginx_config_path }}"
    mode: '0644'
  notify: restart nginx

- name: Démarrer nginx
  service:
    name: nginx
    state: started
    enabled: yes

# roles/nginx/handlers/main.yml
---
- name: restart nginx
  service:
    name: nginx
    state: restarted

# roles/nginx/templates/nginx.conf.j2
user {{ nginx_user }};
worker_processes {{ nginx_worker_processes }};

events {
    worker_connections 1024;
}

http {
    server {
        listen {{ nginx_port }};
        server_name _;
        
        location / {
            root /var/www/html;
            index index.html;
        }
    }
}
```

---

### Utiliser un Role

```yaml
# site.yml
---
- name: Configuration des serveurs web
  hosts: webservers
  become: yes
  
  roles:
    - nginx
    - { role: postgresql, db_name: 'myapp' }
    - role: monitoring
      when: environment == "production"
```

---

### Ansible Galaxy

```bash
# Rechercher des roles
ansible-galaxy search nginx

# Installer un role
ansible-galaxy install geerlingguy.nginx

# Installer depuis un fichier
# requirements.yml
---
roles:
  - name: geerlingguy.nginx
    version: 3.1.4
  - src: https://github.com/user/ansible-role-custom
    name: custom

# Installer
ansible-galaxy install -r requirements.yml

# Lister les roles installés
ansible-galaxy list

# Supprimer un role
ansible-galaxy remove geerlingguy.nginx
```

---

## 🔐 Ansible Vault

**Ansible Vault** permet de chiffrer des données sensibles.

### Créer un fichier chiffré

```bash
# Créer un nouveau fichier chiffré
ansible-vault create secrets.yml

# Éditer un fichier chiffré
ansible-vault edit secrets.yml

# Chiffrer un fichier existant
ansible-vault encrypt vars.yml

# Déchiffrer un fichier
ansible-vault decrypt secrets.yml

# Voir le contenu sans déchiffrer
ansible-vault view secrets.yml

# Rechiffrer avec un nouveau mot de passe
ansible-vault rekey secrets.yml
```

---

### Utiliser Vault dans un Playbook

```bash
# Exécuter avec mot de passe interactif
ansible-playbook playbook.yml --ask-vault-pass

# Avec fichier de mot de passe
echo "mon_mot_de_passe" > .vault_pass
chmod 600 .vault_pass
ansible-playbook playbook.yml --vault-password-file .vault_pass

# Avec variable d'environnement
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_pass
ansible-playbook playbook.yml
```

```yaml
# secrets.yml (chiffré)
---
db_password: "SuperSecret123!"
api_key: "abc123def456"

# playbook.yml
---
- name: Déploiement avec secrets
  hosts: all
  vars_files:
    - secrets.yml
  tasks:
    - name: Utiliser un secret
      debug:
        msg: "Password: {{ db_password }}"
```

---

### Chiffrer des variables individuelles

```yaml
# Chiffrer une string
ansible-vault encrypt_string 'my_secret_password' --name 'db_password'

# Résultat dans le playbook
db_password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66386439653736393061613366363565...
```

---

## 🌐 Exemple Pratique : Nginx + Docker

### Structure du projet

```
ansible-nginx-docker/
├── ansible.cfg
├── inventory.ini
├── playbook.yml
├── files/
│   └── index.html
└── group_vars/
    └── webservers.yml
```

---

### Fichier ansible.cfg

```ini
# ansible.cfg
[defaults]
inventory = ./inventory.ini
host_key_checking = False
remote_user = ubuntu
private_key_file = ~/.ssh/aws_key.pem
log_path = ./ansible.log
```

---

### Fichier inventory.ini

```ini
# inventory.ini
[webservers]
ec2-XX-XX-XX-XX.eu-west-3.compute.amazonaws.com ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws_key.pem

[webservers:vars]
ansible_python_interpreter=/usr/bin/python3
```

---

### Fichier index.html

```html
<!-- files/index.html -->
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Déployé avec Ansible</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            text-align: center;
        }
        h1 {
            font-size: 3em;
            margin-bottom: 0.5em;
        }
        p {
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Nginx + Docker</h1>
        <p>Déployé automatiquement avec Ansible</p>
        <p>✅ Configuration réussie!</p>
    </div>
</body>
</html>
```

---

### Playbook nginx_docker.yml

```yaml
---
- name: Installer NGINX via Docker sur AWS EC2
  hosts: webservers
  become: true
  
  vars:
    nginx_container_name: nginx-web
    nginx_port: 80
    web_root: /usr/share/nginx/html
  
  pre_tasks:
    - name: Mettre à jour le cache apt
      apt:
        update_cache: yes
        cache_valid_time: 3600
  
  tasks:
    - name: Installer les dépendances système
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - gnupg
          - lsb-release
          - python3-pip
        state: present
    
    - name: Installer le module Python Docker
      pip:
        name:
          - docker
          - docker-compose
        state: present
    
    - name: Télécharger et enregistrer la clé GPG officielle de Docker
      shell: |
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
      args:
        creates: /usr/share/keyrings/docker-archive-keyring.gpg
    
    - name: Ajouter le dépôt Docker
      apt_repository:
        repo: "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
        state: present
        filename: docker
    
    - name: Installer Docker Engine
      apt:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: present
        update_cache: yes
    
    - name: Démarrer et activer Docker
      service:
        name: docker
        state: started
        enabled: yes
    
    - name: Ajouter l'utilisateur au groupe docker
      user:
        name: "{{ ansible_user }}"
        groups: docker
        append: yes
    
    - name: Créer le dossier pour la page web
      file:
        path: "{{ web_root }}"
        state: directory
        mode: '0755'
    
    - name: Copier le fichier index.html
      copy:
        src: files/index.html
        dest: "{{ web_root }}/index.html"
        mode: '0644'
    
    - name: Arrêter le conteneur existant (si présent)
      docker_container:
        name: "{{ nginx_container_name }}"
        state: absent
      ignore_errors: yes
    
    - name: Lancer le conteneur NGINX
      docker_container:
        name: "{{ nginx_container_name }}"
        image: nginx:alpine
        state: started
        restart_policy: always
        ports:
          - "{{ nginx_port }}:80"
        volumes:
          - "{{ web_root }}:/usr/share/nginx/html:ro"
        healthcheck:
          test: ["CMD", "curl", "-f", "http://localhost"]
          interval: 30s
          timeout: 10s
          retries: 3
    
    - name: Attendre que nginx soit prêt
      wait_for:
        port: "{{ nginx_port }}"
        delay: 5
        timeout: 60
    
    - name: Vérifier que nginx répond
      uri:
        url: "http://localhost:{{ nginx_port }}"
        status_code: 200
      register: nginx_response
    
    - name: Afficher le statut
      debug:
        msg: "✅ Nginx est opérationnel sur le port {{ nginx_port }}"
      when: nginx_response.status == 200
  
  handlers:
    - name: restart docker
      service:
        name: docker
        state: restarted
```

---

### Tester la connexion SSH

```bash
# Vérifier la connexion
ansible -i inventory.ini webservers -m ping

# Commande ad-hoc pour tester
ansible -i inventory.ini webservers -m shell -a "uptime"

# Vérifier Docker
ansible -i inventory.ini webservers -m shell -a "docker --version" --become
```

---

### Lancer le Playbook

```bash
# Exécution normale
ansible-playbook -i inventory.ini nginx_docker.yml

# Dry-run (vérifier sans exécuter)
ansible-playbook -i inventory.ini nginx_docker.yml --check

# Verbose
ansible-playbook -i inventory.ini nginx_docker.yml -v

# Très verbose (debug)
ansible-playbook -i inventory.ini nginx_docker.yml -vvv

# Limiter à un host
ansible-playbook -i inventory.ini nginx_docker.yml --limit ec2-XX-XX-XX-XX.eu-west-3.compute.amazonaws.com
```

---

### Vérifier le déploiement

```bash
# Depuis votre machine locale
# Récupérer l'IP de l'instance
EC2_IP=$(grep webservers -A1 inventory.ini | tail -1 | awk '{print $1}')

# Tester avec curl
curl http://$EC2_IP

# Ou ouvrir dans le navigateur
# http://ec2-XX-XX-XX-XX.eu-west-3.compute.amazonaws.com

# Vérifier les conteneurs Docker
ansible -i inventory.ini webservers -m shell -a "docker ps" --become

# Voir les logs du conteneur
ansible -i inventory.ini webservers -m shell -a "docker logs nginx-web" --become

# Vérifier la santé du conteneur
ansible -i inventory.ini webservers -m shell -a "docker inspect nginx-web | grep Health -A 10" --become
```

---

## ✅ Bonnes Pratiques

### Organisation des fichiers

```
projet-ansible/
├── ansible.cfg
├── inventory/
│   ├── production/
│   │   ├── hosts
│   │   └── group_vars/
│   ├── staging/
│   │   ├── hosts
│   │   └── group_vars/
│   └── development/
│       ├── hosts
│       └── group_vars/
├── playbooks/
│   ├── site.yml
│   ├── webservers.yml
│   └── databases.yml
├── roles/
│   ├── common/
│   ├── nginx/
│   └── postgresql/
├── group_vars/
│   ├── all.yml
│   ├── webservers.yml
│   └── databases.yml
├── host_vars/
│   └── web1.example.com.yml
├── files/
├── templates/
├── vars/
│   ├── common.yml
│   └── secrets.yml.vault
└── README.md
```

---

### Naming conventions

```yaml
# Noms de tâches descriptifs
- name: Install nginx web server
  apt:
    name: nginx
    state: present

# Variables en snake_case
http_port: 80
database_name: myapp_db

# Roles en kebab-case
- nginx-webserver
- postgresql-database

# Playbooks descriptifs
- site.yml
- deploy-webservers.yml
- backup-databases.yml
```

---

### Idempotence

```yaml
# ❌ Mauvais (non idempotent)
- name: Ajouter une ligne au fichier
  shell: echo "config=value" >> /etc/config

# ✅ Bon (idempotent)
- name: Configurer le fichier
  lineinfile:
    path: /etc/config
    line: "config=value"
    state: present

# ❌ Mauvais
- name: Créer un utilisateur
  shell: useradd john

# ✅ Bon
- name: Créer un utilisateur
  user:
    name: john
    state: present
```

---

### Handlers

```yaml
# Utiliser des handlers pour les actions conditionnelles
tasks:
  - name: Copier la configuration nginx
    copy:
      src: nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: restart nginx
  
  - name: Copier le site
    copy:
      src: index.html
      dest: /var/www/html/index.html
    notify: reload nginx

handlers:
  - name: restart nginx
    service:
      name: nginx
      state: restarted
  
  - name: reload nginx
    service:
      name: nginx
      state: reloaded
```

---

### Tags

```yaml
# Utiliser des tags pour l'exécution sélective
- name: Installer nginx
  apt:
    name: nginx
    state: present
  tags:
    - install
    - nginx

- name: Configurer nginx
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  tags:
    - configure
    - nginx

- name: Déployer le site
  copy:
    src: site/
    dest: /var/www/html/
  tags:
    - deploy
    - website

# Exécuter uniquement certains tags
ansible-playbook playbook.yml --tags "install,configure"
ansible-playbook playbook.yml --skip-tags "deploy"
```

---

### Tests et validation

```yaml
# Vérifier la syntaxe
ansible-playbook playbook.yml --syntax-check

# Dry-run
ansible-playbook playbook.yml --check

# Voir les changements
ansible-playbook playbook.yml --check --diff

# Mode pas-à-pas
ansible-playbook playbook.yml --step

# Linter (installer avec pip install ansible-lint)
ansible-lint playbook.yml
```

---

### Sécurité

```yaml
# 1. Utiliser Vault pour les secrets
ansible-vault create secrets.yml

# 2. Ne jamais commiter les secrets
# .gitignore
*.vault
secrets.yml
.vault_pass

# 3. Utiliser become avec parcimonie
become: yes
become_user: root

# 4. Limiter les privilèges
- name: Tâche sans privilèges
  file:
    path: /home/user/file
    state: touch
  become: no

# 5. Valider les inputs
- name: Installer un paquet
  apt:
    name: "{{ package_name | regex_search('^[a-z0-9-]+) }}"
    state: present
  when: package_name is defined and package_name != ""
```

---

## 🔧 Dépannage

### Problèmes de connexion SSH

```bash
# Vérifier la connexion SSH manuelle
ssh -i ~/.ssh/aws_key.pem ubuntu@ec2-XX-XX-XX-XX.eu-west-3.compute.amazonaws.com

# Tester avec Ansible
ansible -i inventory.ini all -m ping -vvv

# Problèmes courants:

# 1. Permission denied (clé SSH)
chmod 600 ~/.ssh/aws_key.pem

# 2. Host key checking
# Dans ansible.cfg
host_key_checking = False

# Ou via variable d'environnement
export ANSIBLE_HOST_KEY_CHECKING=False

# 3. Timeout
# Augmenter le timeout dans ansible.cfg
timeout = 60

# 4. Mauvais utilisateur
ansible_user=ubuntu  # Pour Ubuntu/Debian
ansible_user=ec2-user  # Pour Amazon Linux
ansible_user=centos  # Pour CentOS
```

---

### Problèmes de privilèges

```bash
# Erreur: "Missing sudo password"
# Solution 1: Ajouter dans inventory
[webservers:vars]
ansible_become_pass=password

# Solution 2: Demander interactivement
ansible-playbook playbook.yml --ask-become-pass

# Solution 3: Sudoers sans mot de passe
# Sur le serveur distant:
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu

# Tester become
ansible -i inventory.ini all -m shell -a "whoami" --become
```

---

### Problèmes de modules

```bash
# Module Python manquant
# Exemple: docker module
ansible -i inventory.ini all -m pip -a "name=docker state=present" --become

# Python interpreter
# Dans inventory
ansible_python_interpreter=/usr/bin/python3

# Lister les modules disponibles
ansible-doc -l

# Aide sur un module
ansible-doc apt
ansible-doc docker_container
```

---

### Debug et verbose

```yaml
# Utiliser le module debug
- name: Afficher une variable
  debug:
    msg: "La valeur est {{ ma_variable }}"
    verbosity: 2

- name: Afficher toutes les variables
  debug:
    var: hostvars[inventory_hostname]

- name: Debug conditionnel
  debug:
    msg: "Environnement de production détecté"
  when: env == "production"
```

```bash
# Niveaux de verbosité
ansible-playbook playbook.yml -v      # Info
ansible-playbook playbook.yml -vv     # Plus d'info + résultats des tâches
ansible-playbook playbook.yml -vvv    # Debug + connexions SSH
ansible-playbook playbook.yml -vvvv   # Tout (très verbeux)

# Afficher les variables d'un host
ansible -i inventory.ini web1 -m debug -a "var=hostvars[inventory_hostname]"
```

---

### Problèmes courants Docker

```yaml
# Permission denied sur Docker socket
- name: Ajouter l'utilisateur au groupe docker
  user:
    name: "{{ ansible_user }}"
    groups: docker
    append: yes

# Puis se reconnecter ou:
- name: Reset SSH connection
  meta: reset_connection

# Docker daemon non démarré
- name: S'assurer que Docker est démarré
  service:
    name: docker
    state: started
    enabled: yes

# Module docker_container manquant
- name: Installer le SDK Docker Python
  pip:
    name:
      - docker
      - docker-compose
    state: present
```

---

### Erreurs de syntaxe YAML

```yaml
# ❌ Mauvais
- name: Ma tâche
  apt:
  name: nginx
  state: present

# ✅ Bon (indentation correcte)
- name: Ma tâche
  apt:
    name: nginx
    state: present

# ❌ Mauvais (guillemets manquants)
msg: Il y a un : dans le texte

# ✅ Bon
msg: "Il y a un : dans le texte"

# Vérifier la syntaxe
ansible-playbook playbook.yml --syntax-check

# Valider avec yamllint
yamllint playbook.yml
```

---

## 🚀 Commandes de Référence Rapide

```bash
# Ansible
ansible --version
ansible-config dump
ansible-config list

# Inventory
ansible-inventory -i inventory.ini --list
ansible-inventory -i inventory.ini --graph
ansible all --list-hosts -i inventory.ini

# Ad-hoc
ansible all -m ping -i inventory.ini
ansible all -m shell -a "uptime" -i inventory.ini
ansible all -m apt -a "name=nginx state=present" -i inventory.ini --become

# Playbooks
ansible-playbook playbook.yml
ansible-playbook playbook.yml -i inventory.ini
ansible-playbook playbook.yml --check
ansible-playbook playbook.yml --check --diff
ansible-playbook playbook.yml -v
ansible-playbook playbook.yml --syntax-check
ansible-playbook playbook.yml --list-tasks
ansible-playbook playbook.yml --list-hosts
ansible-playbook playbook.yml --tags "install,configure"
ansible-playbook playbook.yml --limit webservers
ansible-playbook playbook.yml -e "env=production"

# Vault
ansible-vault create secrets.yml
ansible-vault edit secrets.yml
ansible-vault encrypt file.yml
ansible-vault decrypt file.yml
ansible-vault view secrets.yml
ansible-vault rekey secrets.yml
ansible-playbook playbook.yml --ask-vault-pass
ansible-playbook playbook.yml --vault-password-file .vault_pass

# Roles
ansible-galaxy init roles/myrole
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install -r requirements.yml
ansible-galaxy list
ansible-galaxy search nginx

# Documentation
ansible-doc -l                    # Lister tous les modules
ansible-doc apt                   # Doc d'un module
ansible-doc -s apt                # Snippets
```

---

## 📚 Ressources Complémentaires

### Documentation Officielle
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible Module Index](https://docs.ansible.com/ansible/latest/collections/index_module.html)

### Guides Connexes
- 📘 [Terraform - Infrastructure as Code](../terraform/terraform.md)
- 🐳 [Docker - Containerisation](../Docker/docker.md)
- ☸️ [Kubernetes - Orchestration](../Kubernetes/kubernetes.md)

### Outils et Intégrations
- [AWX](https://github.com/ansible/awx) - Interface web pour Ansible (Tower open-source)
- [Ansible Lint](https://github.com/ansible/ansible-lint) - Linter pour playbooks
- [Molecule](https://molecule.readthedocs.io/) - Framework de test pour roles
- [Ansible Semaphore](https://www.ansible-semaphore.com/) - Interface web alternative

### Collections Populaires
- `community.general` - Modules communautaires
- `community.docker` - Modules Docker
- `community.postgresql` - Modules PostgreSQL
- `community.mysql` - Modules MySQL
- `amazon.aws` - Modules AWS
- `kubernetes.core` - Modules Kubernetes

### Roles Ansible Galaxy Populaires
- [geerlingguy.nginx](https://galaxy.ansible.com/geerlingguy/nginx)
- [geerlingguy.docker](https://galaxy.ansible.com/geerlingguy/docker)
- [geerlingguy.postgresql](https://galaxy.ansible.com/geerlingguy/postgresql)
- [geerlingguy.mysql](https://galaxy.ansible.com/geerlingguy/mysql)

---

**🎉 Vous maîtrisez maintenant Ansible !**
