# 🐳 Docker – Guide Complet

## 🛠️ Installation & Configuration

### Installation sur Debian/Ubuntu
```bash
# Méthode officielle (recommandée)
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# Ajouter la clé GPG officielle de Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Configurer le dépôt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installer Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Méthode rapide (pour tests)
sudo apt install docker.io -y
```

### Configuration Post-Installation
```bash
# Ajouter l'utilisateur au groupe docker (éviter sudo)
sudo usermod -aG docker $USER
newgrp docker  # Activer immédiatement

# Vérifier l'installation
docker --version
docker compose version
docker info

# Démarrage automatique
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
```

---

## 📦 Gestion des Images

### 🔍 Rechercher et télécharger
```bash
docker search <nom>                    # Rechercher sur Docker Hub
docker search --limit 5 nginx          # Limiter les résultats
docker pull <image>                    # Télécharger une image
docker pull <image>:<tag>              # Télécharger une version spécifique
docker pull nginx:alpine               # Image légère
docker pull ubuntu:22.04               # Version spécifique
```

### 📋 Lister et inspecter
```bash
docker images                          # Lister toutes les images
docker images -a                       # Inclure les images intermédiaires
docker images --filter "dangling=true" # Images orphelines
docker image ls --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
docker image inspect <image>           # Détails d'une image
docker image history <image>           # Historique des layers
```

### 🏷️ Tags
```bash
docker tag <image> <nouveau_nom>:<tag> # Renommer/taguer une image
docker tag nginx:latest monapp:v1.0    # Exemple
```

### 🗑️ Supprimer
```bash
docker rmi <image_id ou nom>           # Supprimer une image
docker rmi -f <image>                  # Forcer la suppression
docker image prune                     # Supprimer les images non utilisées
docker image prune -a                  # Supprimer toutes les images non utilisées
docker rmi $(docker images -q)         # Supprimer toutes les images
```

### 💾 Sauvegarder et charger
```bash
docker save -o image.tar <image>       # Sauvegarder une image
docker load -i image.tar               # Charger une image
docker export <conteneur> > conteneur.tar  # Exporter un conteneur
docker import conteneur.tar nom:tag    # Importer
```

---

## 🚀 Gestion des Conteneurs

### ▶️ Créer et lancer
```bash
docker run <options> <image> <commande>

# Exemples courants
docker run -it ubuntu /bin/bash                    # Mode interactif
docker run -d -p 8080:80 nginx                     # En arrière-plan avec port
docker run -d -p 8080:80 --name monweb nginx       # Avec nom personnalisé
docker run -d -v /host/data:/data alpine           # Avec volume
docker run -d --rm --name temp nginx               # Suppression auto après arrêt
docker run -d --restart unless-stopped nginx       # Redémarrage automatique
docker run -d -e MYSQL_ROOT_PASSWORD=secret mysql  # Variables d'environnement
docker run -d --network mon-reseau nginx           # Sur un réseau spécifique
docker run -d --memory="256m" --cpus="1.0" nginx   # Limites de ressources
```

### Options importantes du `docker run`
```bash
-d                          # Détaché (background)
-it                         # Interactif + terminal
-p <host>:<conteneur>       # Mapping de ports
-P                          # Mapper tous les ports exposés automatiquement
--name <nom>                # Nom du conteneur
-v <source>:<dest>          # Monter un volume
--rm                        # Supprimer après arrêt
--restart <policy>          # Politique de redémarrage
-e <KEY>=<VALUE>            # Variable d'environnement
--env-file <fichier>        # Fichier de variables
--network <réseau>          # Réseau Docker
--link <conteneur>          # Lier à un autre conteneur (legacy)
-w <path>                   # Répertoire de travail
-u <user>                   # Utilisateur
--hostname <nom>            # Nom d'hôte
--memory <limit>            # Limite mémoire
--cpus <nombre>             # Limite CPU
--privileged                # Mode privilégié (accès complet)
```

### 📋 Lister et surveiller
```bash
docker ps                              # Conteneurs actifs
docker ps -a                           # Tous les conteneurs
docker ps -q                           # Seulement les IDs
docker ps --filter "status=exited"     # Filtrer par status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
docker stats                           # Statistiques en temps réel
docker stats --no-stream               # Stats instantanées
docker top <conteneur>                 # Processus dans le conteneur
docker port <conteneur>                # Ports mappés
```

### 🔍 Inspection et logs
```bash
docker inspect <conteneur>             # Détails complets (JSON)
docker logs <conteneur>                # Logs du conteneur
docker logs -f <conteneur>             # Suivre les logs (tail -f)
docker logs --tail 50 <conteneur>      # 50 dernières lignes
docker logs --since 10m <conteneur>    # Logs des 10 dernières minutes
docker logs -t <conteneur>             # Avec timestamps
```

### ⏸️ Contrôle du cycle de vie
```bash
docker start <conteneur>               # Démarrer
docker stop <conteneur>                # Arrêter (graceful)
docker stop -t 0 <conteneur>           # Arrêt immédiat
docker restart <conteneur>             # Redémarrer
docker pause <conteneur>               # Mettre en pause
docker unpause <conteneur>             # Reprendre
docker kill <conteneur>                # Tuer (SIGKILL)
docker wait <conteneur>                # Attendre la fin
```

### 🗑️ Suppression
```bash
docker rm <conteneur>                  # Supprimer (doit être arrêté)
docker rm -f <conteneur>               # Forcer la suppression
docker rm $(docker ps -aq)             # Supprimer tous les conteneurs
docker rm $(docker ps -aq -f status=exited)  # Supprimer les conteneurs arrêtés
docker container prune                 # Nettoyer les conteneurs arrêtés
```

### 🔄 Copier des fichiers
```bash
docker cp <conteneur>:<chemin> <dest>  # Copier depuis le conteneur
docker cp <source> <conteneur>:<chemin> # Copier vers le conteneur
docker cp monweb:/etc/nginx/nginx.conf ./  # Exemple
```

---

## 🧠 Exécution de Commandes

### 💻 Shell interactif
```bash
docker exec -it <conteneur> bash       # Bash
docker exec -it <conteneur> sh         # Shell (pour Alpine)
docker exec -it <conteneur> /bin/bash  # Chemin complet
docker attach <conteneur>              # Attacher au processus principal
```

### ▶️ Commandes ponctuelles
```bash
docker exec <conteneur> <commande>     # Exécuter une commande
docker exec monweb ls /etc             # Exemple
docker exec -u root <conteneur> apt update  # En tant que root
docker exec -w /app <conteneur> npm install # Dans un répertoire spécifique
```

---

## 🧱 Volumes (Données Persistantes)

### Types de volumes
```bash
# Volume nommé (recommandé)
docker volume create mon-volume
docker run -v mon-volume:/data alpine

# Bind mount (dossier hôte)
docker run -v /chemin/host:/chemin/conteneur alpine

# tmpfs (en mémoire, temporaire)
docker run --tmpfs /app/cache alpine
```

### 📋 Gestion des volumes
```bash
docker volume ls                       # Lister les volumes
docker volume create <nom>             # Créer un volume
docker volume inspect <nom>            # Détails d'un volume
docker volume rm <nom>                 # Supprimer un volume
docker volume prune                    # Supprimer les volumes non utilisés
```

### 💾 Utilisation avancée
```bash
# Volume en lecture seule
docker run -v mon-volume:/data:ro nginx

# Monter plusieurs volumes
docker run -v vol1:/data1 -v vol2:/data2 alpine

# Sauvegarder un volume
docker run --rm -v mon-volume:/source -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /source

# Restaurer un volume
docker run --rm -v mon-volume:/dest -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /dest
```

---

## 🌐 Réseaux Docker

### Types de réseaux
- **bridge** : Réseau par défaut, isolation des conteneurs
- **host** : Utilise directement le réseau de l'hôte
- **none** : Aucun réseau
- **overlay** : Pour Docker Swarm (multi-hôtes)

### 📋 Gestion des réseaux
```bash
docker network ls                      # Lister les réseaux
docker network inspect <nom>           # Détails d'un réseau
docker network create <nom>            # Créer un réseau bridge
docker network create --driver bridge mon-reseau
docker network create --subnet=172.20.0.0/16 mon-reseau
docker network rm <nom>                # Supprimer un réseau
docker network prune                   # Nettoyer les réseaux inutilisés
```

### 🔗 Connecter des conteneurs
```bash
# Créer un conteneur sur un réseau
docker run -d --name web --network mon-reseau nginx

# Connecter un conteneur existant
docker network connect mon-reseau <conteneur>

# Déconnecter
docker network disconnect mon-reseau <conteneur>

# Créer avec alias
docker network connect --alias webapp mon-reseau <conteneur>
```

### 🌍 Exemple réseau multi-conteneurs
```bash
# Créer un réseau
docker network create app-network

# Lancer une base de données
docker run -d --name db --network app-network -e MYSQL_ROOT_PASSWORD=secret mysql

# Lancer l'application (peut accéder à db par son nom)
docker run -d --name web --network app-network -p 8080:80 monapp

# Les conteneurs communiquent via leurs noms DNS
```

---

## 🏗️ Dockerfile – Créer des Images

### Structure de base
```dockerfile
# Dockerfile
FROM ubuntu:22.04

# Métadonnées
LABEL maintainer="votre@email.com"
LABEL version="1.0"
LABEL description="Mon application"

# Variables d'environnement
ENV APP_HOME=/app
ENV NODE_ENV=production

# Répertoire de travail
WORKDIR /app

# Copier les fichiers
COPY package*.json ./
COPY . .

# Installer les dépendances
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Exposer un port
EXPOSE 3000

# Utilisateur non-root (sécurité)
RUN useradd -m appuser
USER appuser

# Commande par défaut
CMD ["node", "server.js"]
```

### Instructions Dockerfile
```dockerfile
FROM <image>:<tag>          # Image de base
LABEL <key>=<value>         # Métadonnées
ENV <key>=<value>           # Variables d'environnement
ARG <name>=<default>        # Arguments de build
WORKDIR <path>              # Répertoire de travail
COPY <src> <dest>           # Copier fichiers (build context)
ADD <src> <dest>            # Copier + extraction archives
RUN <commande>              # Exécuter une commande
EXPOSE <port>               # Documenter les ports
VOLUME <path>               # Point de montage
USER <user>                 # Utilisateur
CMD ["executable","param"]  # Commande par défaut
ENTRYPOINT ["executable"]   # Point d'entrée
HEALTHCHECK <options> CMD   # Vérification de santé
```

### 🔨 Construire une image
```bash
docker build -t <nom>:<tag> <chemin>
docker build -t monapp:v1.0 .          # Depuis le dossier courant
docker build -t monapp:latest -f custom.dockerfile .  # Dockerfile personnalisé
docker build --no-cache -t monapp .    # Sans cache
docker build --build-arg VERSION=1.0 . # Avec arguments
docker build --target production .     # Multi-stage (target spécifique)
```

### 🎯 Multi-stage builds
```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package*.json ./
RUN npm install --production
CMD ["node", "dist/server.js"]
```

### 📝 .dockerignore
```bash
# .dockerignore
node_modules
npm-debug.log
.git
.env
*.md
.vscode
.idea
dist
coverage
```

---

## 🐳 Docker Compose

### 📄 Structure docker-compose.yml
```yaml
version: '3.8'

services:
  web:
    build: .
    # ou
    image: nginx:alpine
    container_name: mon-web
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
      - logs:/var/log/nginx
    environment:
      - NODE_ENV=production
    env_file:
      - .env
    networks:
      - app-network
    depends_on:
      - db
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3

  db:
    image: mysql:8.0
    container_name: mon-db
    volumes:
      - db-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: app
    networks:
      - app-network
    restart: unless-stopped

volumes:
  db-data:
  logs:

networks:
  app-network:
    driver: bridge
```

### 🎮 Commandes Docker Compose
```bash
# Démarrer les services
docker-compose up                      # Premier plan
docker-compose up -d                   # Arrière-plan (detached)
docker-compose up --build              # Rebuild les images

# Arrêter et supprimer
docker-compose down                    # Arrêter et supprimer conteneurs/réseaux
docker-compose down -v                 # + supprimer les volumes
docker-compose down --rmi all          # + supprimer les images

# Gestion des services
docker-compose start                   # Démarrer services existants
docker-compose stop                    # Arrêter les services
docker-compose restart                 # Redémarrer
docker-compose pause                   # Pause
docker-compose unpause                 # Reprendre

# Monitoring
docker-compose ps                      # Statut des services
docker-compose top                     # Processus
docker-compose logs                    # Logs de tous les services
docker-compose logs -f web             # Logs d'un service spécifique
docker-compose logs --tail=100         # 100 dernières lignes

# Exécution
docker-compose exec web bash           # Shell dans un service
docker-compose run web npm install     # Commande ponctuelle

# Build et images
docker-compose build                   # Construire les images
docker-compose build --no-cache        # Sans cache
docker-compose pull                    # Télécharger les images

# Scaling
docker-compose up -d --scale web=3     # 3 instances du service web

# Validation
docker-compose config                  # Valider la syntaxe
docker-compose config --services       # Lister les services
```

### 📋 Variables d'environnement (.env)
```bash
# .env
COMPOSE_PROJECT_NAME=monapp
MYSQL_ROOT_PASSWORD=supersecret
APP_PORT=8080
NODE_ENV=production
```

---

## 🧹 Nettoyage & Maintenance

### 🗑️ Nettoyage complet
```bash
# Nettoyer tout ce qui n'est pas utilisé
docker system prune                    # Conteneurs, réseaux, images dangling
docker system prune -a                 # + toutes les images non utilisées
docker system prune --volumes          # + volumes

# Nettoyage spécifique
docker container prune                 # Conteneurs arrêtés
docker image prune                     # Images dangling
docker image prune -a                  # Toutes les images non utilisées
docker volume prune                    # Volumes non utilisés
docker network prune                   # Réseaux non utilisés
```

### 📊 Espace disque
```bash
docker system df                       # Utilisation du disque
docker system df -v                    # Détails
```

### 🔄 Mise à jour des images
```bash
# Script pour mettre à jour toutes les images
docker images --format "{{.Repository}}:{{.Tag}}" | grep -v '<none>' | xargs -L1 docker pull
```

---

## 🔒 Sécurité & Bonnes Pratiques

### ✅ Bonnes pratiques
```bash
# 1. Utiliser des images officielles
FROM node:18-alpine  # ✅ Officielle + légère

# 2. Utilisateur non-root
USER node

# 3. Multi-stage builds
# Réduire la taille finale

# 4. Scanner les vulnérabilités
docker scan <image>

# 5. Limiter les ressources
docker run --memory="512m" --cpus="1.0" <image>

# 6. Réseaux isolés
# Ne pas tout mettre sur le même réseau

# 7. Secrets
# Utiliser Docker secrets ou variables d'environnement
docker run -e DB_PASSWORD=$(cat db_password.txt) <image>

# 8. Read-only filesystem
docker run --read-only --tmpfs /tmp <image>

# 9. Drop capabilities
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE <image>
```

### 🔍 Audit de sécurité
```bash
# Scanner une image
docker scan nginx:latest

# Vérifier les vulnérabilités avec Trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image nginx
```

---

## 🔧 Dépannage (Troubleshooting)

### 🐛 Problèmes courants
```bash
# Conteneur qui s'arrête immédiatement
docker logs <conteneur>                # Voir les logs
docker inspect <conteneur>             # Vérifier la configuration

# Port déjà utilisé
sudo netstat -tulpn | grep <port>      # Trouver le processus
docker ps | grep <port>                # Vérifier les conteneurs

# Erreur de permissions
sudo chown -R $USER:$USER <dossier>    # Corriger les permissions

# Espace disque plein
docker system df                       # Vérifier l'usage
docker system prune -a --volumes       # Nettoyer

# Conteneur ne répond pas
docker exec <conteneur> ps aux         # Vérifier les processus
docker stats <conteneur>               # Vérifier les ressources

# Réseau inaccessible
docker network inspect bridge          # Vérifier la config réseau
sudo systemctl restart docker          # Redémarrer Docker
```

### 🔄 Redémarrer Docker
```bash
sudo systemctl restart docker
sudo systemctl status docker
```

---

## 📊 Monitoring & Performance

### 📈 Statistiques
```bash
docker stats                           # Stats temps réel tous conteneurs
docker stats --no-stream <conteneur>   # Snapshot d'un conteneur
docker top <conteneur>                 # Processus
```

### 🏥 Health checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

```bash
docker inspect --format='{{.State.Health.Status}}' <conteneur>
```

---

## 🎯 Cas d'Usage Pratiques

### 🌐 Serveur Web (Nginx)
```bash
docker run -d \
  --name monweb \
  -p 80:80 \
  -v $(pwd)/html:/usr/share/nginx/html:ro \
  nginx:alpine
```

### 🗄️ Base de données (PostgreSQL)
```bash
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=monapp \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:15-alpine
```

### 🐘 Stack LAMP complète
```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    image: php:8.2-apache
    ports:
      - "80:80"
    volumes:
      - ./www:/var/www/html
    depends_on:
      - db
  
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: app
    volumes:
      - dbdata:/var/lib/mysql

volumes:
  dbdata:
```

---

## ✅ Test de l'Installation

### Vérification rapide
```bash
# Test simple
docker run hello-world

# Test complet
docker run -d -p 8080:80 nginx
curl http://localhost:8080
docker stop $(docker ps -q)
```

---

## 📚 Ressources Complémentaires

- [Documentation officielle Docker](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Best Practices Guide](https://docs.docker.com/develop/dev-best-practices/)
- [Play with Docker](https://labs.play-with-docker.com/) - Environnement de test en ligne
