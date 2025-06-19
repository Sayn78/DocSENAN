# Installation et Configuration de Ansible pour déployer nginx (serveur web) sur une VM dans un docker

Ce guide explique comment installer et configurer **Ansible** sur une machine virtuelle Ubuntu. cette exemple install un serveur web dans un conteneur (docker) sur une VM AWS (EC2).

## Prérequis

Avant d'installer Ansible, assurez-vous d'avoir les éléments suivants :

- Une machine virtuelle Ubuntu avec un accès SSH.
- Un compte utilisateur avec des privilèges `sudo`.
- un site web ou au moins une page web (index.html) prête a l'emploi


## Étape 1 : installer Ansible

```bash
sudo apt update
sudo apt install ansible -y
```

## Étape 2 : Créer un fichier inventory.ini

Ce fichier sert a repertorier la liste de tes serveur

```bash
[webservers]
ec2-XX-XX-XX-XX.eu-west-3.compute.amazonaws.com ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/votrecleSSH
```

## Étape 3 : Tester la connexion SSH

```bash
ansible -i inventory.ini webservers -m ping
```

## Étape 4 : Créer un playbook Ansible nginx_docker.yml

```yaml
---
- name: Installer NGINX via Docker
  hosts: webserver
  become: true

  tasks:
    - name: Installer les dépendances
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - gnupg
          - lsb-release
          - python3-pip
          - python3-docker
        state: present
        update_cache: true

    - name: Télécharger et enregistrer la clé GPG officielle de Docker
      shell: |
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
      args:
        creates: /usr/share/keyrings/docker-archive-keyring.gpg

    - name: Ajouter le dépôt Docker
      apt_repository:
        repo: "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
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

    - name: Créer le dossier pour la page web
      file:
        path: /usr/share/nginx/html
        state: directory
        mode: '0755'

    - name: Copier le fichier index.html
      copy:
        src: index.html
        dest: /usr/share/nginx/html/index.html
        mode: '0644'

    - name: Lancer le conteneur NGINX
      docker_container:
        name: nginx
        image: nginx:latest
        state: started
        restart_policy: always
        ports:
          - "80:80"
        volumes:
          - /usr/share/nginx/html:/usr/share/nginx/html

```

## Étape 4 : lance ton playbook

```bash
ansible-playbook -i inventory.ini nginx_docker.yml
```
