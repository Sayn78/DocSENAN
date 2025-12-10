# Documentation Docker Swarm

## Table des matières

1. [Introduction à Docker Swarm](#introduction)
2. [Concepts fondamentaux](#concepts-fondamentaux)
3. [Installation et configuration](#installation-et-configuration)
4. [Gestion du cluster](#gestion-du-cluster)
5. [Déploiement avec docker-compose](#déploiement-avec-docker-compose)
6. [Services et stacks](#services-et-stacks)
7. [Réseaux et volumes](#réseaux-et-volumes)
8. [Secrets et configs](#secrets-et-configs)
9. [Mise à l'échelle et rolling updates](#mise-à-léchelle-et-rolling-updates)
10. [Monitoring et maintenance](#monitoring-et-maintenance)

---

## Introduction

Docker Swarm est la solution native d'orchestration de conteneurs de Docker. Il permet de gérer un cluster de machines Docker comme une seule entité virtuelle, facilitant le déploiement, la mise à l'échelle et la haute disponibilité des applications conteneurisées.

### Avantages de Docker Swarm

- **Intégration native** : Intégré directement dans Docker Engine
- **Simplicité** : Configuration et utilisation plus simple que Kubernetes
- **Haute disponibilité** : Réplication automatique et équilibrage de charge
- **Déploiement déclaratif** : Utilisation de fichiers docker-compose.yml
- **Service discovery** : DNS intégré pour la découverte de services
- **Load balancing** : Équilibrage de charge automatique

---

## Concepts fondamentaux

### Architecture

Docker Swarm utilise une architecture manager-worker :

- **Manager nodes** : Gèrent l'état du cluster, orchestrent les services, maintiennent l'état souhaité
- **Worker nodes** : Exécutent les conteneurs (tasks)
- Un nœud peut être à la fois manager et worker

### Composants clés

- **Node** : Instance Docker participant au Swarm
- **Service** : Définition d'une application à exécuter dans le Swarm
- **Task** : Unité atomique de travail (un conteneur)
- **Stack** : Groupe de services déployés ensemble
- **Network** : Réseau overlay pour la communication entre services
- **Secret** : Données sensibles chiffrées
- **Config** : Fichiers de configuration non sensibles

---

## Installation et configuration

### Prérequis

- Docker Engine 1.12 ou supérieur installé sur chaque nœud
- Connectivité réseau entre les nœuds
- Ports ouverts :
  - TCP 2377 : Communication du cluster
  - TCP/UDP 7946 : Communication entre nœuds
  - UDP 4789 : Trafic réseau overlay

### Initialisation du Swarm

Sur le nœud manager principal :

```bash
# Initialiser le Swarm
docker swarm init --advertise-addr <IP_DU_MANAGER>

# Exemple
docker swarm init --advertise-addr 192.168.1.100
```

Cette commande retourne un token pour joindre des workers :

```bash
docker swarm join --token SWMTKN-1-xxxxx 192.168.1.100:2377
```

### Ajouter des nœuds

**Ajouter un worker :**

```bash
# Sur le nœud worker
docker swarm join --token <WORKER_TOKEN> <MANAGER_IP>:2377
```

**Ajouter un manager :**

```bash
# Obtenir le token manager
docker swarm join-token manager

# Sur le nouveau nœud manager
docker swarm join --token <MANAGER_TOKEN> <MANAGER_IP>:2377
```

### Configuration initiale recommandée

```bash
# Vérifier l'état du Swarm
docker info

# Lister les nœuds
docker node ls

# Promouvoir un worker en manager
docker node promote <NODE_ID>

# Rétrograder un manager en worker
docker node demote <NODE_ID>
```

---

## Gestion du cluster

### Commandes de base

```bash
# Afficher les informations du Swarm
docker swarm --help

# Lister les nœuds
docker node ls

# Inspecter un nœud
docker node inspect <NODE_ID>

# Mettre à jour un nœud
docker node update --availability drain <NODE_ID>

# Disponibilités possibles : active, pause, drain
```

### Gestion des nœuds

**Drainer un nœud (pour maintenance) :**

```bash
docker node update --availability drain node-1
```

**Réactiver un nœud :**

```bash
docker node update --availability active node-1
```

**Retirer un nœud :**

```bash
# Sur le nœud à retirer
docker swarm leave

# Sur un manager, forcer la suppression
docker node rm --force <NODE_ID>
```

### Labels sur les nœuds

```bash
# Ajouter un label
docker node update --label-add environment=production node-1
docker node update --label-add zone=europe node-1

# Utiliser les labels pour placer des services
docker service create \
  --constraint 'node.labels.environment==production' \
  nginx
```

---

## Déploiement avec docker-compose

### Introduction

Docker Swarm peut déployer des applications définies dans des fichiers `docker-compose.yml` en utilisant la commande `docker stack`. C'est la méthode recommandée pour déployer des applications multi-conteneurs dans un Swarm.

### Différences entre docker-compose et docker stack

| Fonctionnalité | docker-compose | docker stack |
|----------------|----------------|--------------|
| Environnement | Développement local | Production (Swarm) |
| Build d'images | Supporté | Non supporté (images pré-buildées) |
| Réplication | Non | Oui |
| Mise à jour rolling | Non | Oui |
| Secrets | Fichiers locaux | Swarm secrets |
| Placement | Non | Oui (contraintes) |

### Structure d'un fichier docker-compose pour Swarm

```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
        max_attempts: 3
      placement:
        constraints:
          - node.role == worker
    networks:
      - frontend
    configs:
      - source: nginx_config
        target: /etc/nginx/nginx.conf
    secrets:
      - ssl_cert

  api:
    image: myapp/api:latest
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
      update_config:
        parallelism: 2
        delay: 10s
        failure_action: rollback
    networks:
      - frontend
      - backend
    environment:
      - DATABASE_URL=postgres://db:5432/myapp
    secrets:
      - db_password

  db:
    image: postgres:14
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.labels.database == true
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - backend
    secrets:
      - db_password
    environment:
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password

networks:
  frontend:
    driver: overlay
  backend:
    driver: overlay
    internal: true

volumes:
  db_data:
    driver: local

secrets:
  db_password:
    external: true
  ssl_cert:
    external: true

configs:
  nginx_config:
    external: true
```

### Section deploy : Options principales

La section `deploy` est spécifique à Docker Swarm et ignorée par docker-compose en mode standalone.

**Options de réplication :**

```yaml
deploy:
  # Mode de déploiement
  mode: replicated  # ou 'global' pour un conteneur par nœud
  replicas: 3
  
  # Contraintes de placement
  placement:
    constraints:
      - node.role == worker
      - node.labels.disk == ssd
    preferences:
      - spread: node.labels.zone
  
  # Limites de ressources
  resources:
    limits:
      cpus: '1.0'
      memory: 1G
    reservations:
      cpus: '0.5'
      memory: 512M
```

**Configuration des mises à jour :**

```yaml
deploy:
  update_config:
    parallelism: 2          # Nombre de tâches à mettre à jour simultanément
    delay: 10s              # Délai entre les mises à jour
    failure_action: rollback # pause, continue, ou rollback
    monitor: 60s            # Période de surveillance après mise à jour
    max_failure_ratio: 0.3  # Taux d'échec maximum toléré
    order: stop-first       # ou start-first
```

**Politique de redémarrage :**

```yaml
deploy:
  restart_policy:
    condition: on-failure   # none, on-failure, ou any
    delay: 5s
    max_attempts: 3
    window: 120s
```

**Configuration du rollback :**

```yaml
deploy:
  rollback_config:
    parallelism: 1
    delay: 5s
    failure_action: pause
    monitor: 30s
    max_failure_ratio: 0.2
```

### Déployer une stack avec docker-compose

**1. Créer les secrets et configs :**

```bash
# Créer un secret depuis un fichier
echo "mon_mot_de_passe_secret" | docker secret create db_password -

# Créer un secret depuis stdin
docker secret create ssl_cert ./certificate.pem

# Créer une config
docker config create nginx_config ./nginx.conf
```

**2. Déployer la stack :**

```bash
# Déployer la stack
docker stack deploy -c docker-compose.yml mon_app

# Avec plusieurs fichiers compose
docker stack deploy -c docker-compose.yml -c docker-compose.prod.yml mon_app

# Avec résolution des variables d'environnement
docker stack deploy -c <(docker-compose config) mon_app
```

**3. Vérifier le déploiement :**

```bash
# Lister les stacks
docker stack ls

# Lister les services de la stack
docker stack services mon_app

# Afficher les tâches
docker stack ps mon_app

# Logs d'un service
docker service logs mon_app_web
```

### Exemples pratiques

**Exemple 1 : Application web simple avec base de données**

```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    deploy:
      replicas: 2
      update_config:
        parallelism: 1
        delay: 10s
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD_FILE: /run/secrets/db_password
      WORDPRESS_DB_NAME: wordpress
    secrets:
      - db_password
    networks:
      - app_network

  db:
    image: mysql:8.0
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == manager
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD_FILE: /run/secrets/db_password
    secrets:
      - db_root_password
      - db_password
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - app_network

networks:
  app_network:
    driver: overlay

volumes:
  db_data:

secrets:
  db_password:
    external: true
  db_root_password:
    external: true
```

**Exemple 2 : Application microservices**

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker.swarmMode=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    deploy:
      placement:
        constraints:
          - node.role == manager
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - traefik_public

  frontend:
    image: monapp/frontend:latest
    deploy:
      replicas: 3
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.frontend.rule=Host(`app.example.com`)"
        - "traefik.http.services.frontend.loadbalancer.server.port=3000"
      update_config:
        parallelism: 1
        delay: 10s
    networks:
      - traefik_public
      - backend

  api:
    image: monapp/api:latest
    deploy:
      replicas: 5
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.api.rule=Host(`api.example.com`)"
        - "traefik.http.services.api.loadbalancer.server.port=8000"
    networks:
      - traefik_public
      - backend
    secrets:
      - api_key

  redis:
    image: redis:alpine
    deploy:
      replicas: 1
    networks:
      - backend
    volumes:
      - redis_data:/data

networks:
  traefik_public:
    driver: overlay
  backend:
    driver: overlay
    internal: true

volumes:
  redis_data:

secrets:
  api_key:
    external: true
```

### Commandes utiles pour gérer les stacks

```bash
# Déployer ou mettre à jour une stack
docker stack deploy -c docker-compose.yml mon_app

# Lister toutes les stacks
docker stack ls

# Afficher les services d'une stack
docker stack services mon_app

# Afficher les tâches d'une stack
docker stack ps mon_app

# Supprimer une stack
docker stack rm mon_app

# Voir les logs en temps réel
docker service logs -f mon_app_web

# Mettre à l'échelle un service
docker service scale mon_app_web=5

# Inspecter un service
docker service inspect mon_app_web

# Forcer la mise à jour d'un service
docker service update --force mon_app_web
```

### Gestion des variables d'environnement

**Avec fichier .env :**

```bash
# .env
TAG=v1.2.3
REPLICAS=3
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    image: monapp:${TAG:-latest}
    deploy:
      replicas: ${REPLICAS:-1}
```

**Déploiement avec variables :**

```bash
# Les variables du fichier .env sont automatiquement chargées
docker stack deploy -c docker-compose.yml mon_app

# Ou spécifier explicitement
export TAG=v2.0.0
docker stack deploy -c docker-compose.yml mon_app
```

### Mises à jour et rollback

**Mettre à jour un service :**

```bash
# Mettre à jour l'image
docker service update --image monapp:v2 mon_app_web

# Mettre à jour avec nouveau compose
docker stack deploy -c docker-compose.yml mon_app
```

**Rollback en cas de problème :**

```bash
# Rollback automatique (si configuré dans deploy.update_config)
# ou manuel
docker service rollback mon_app_web

# Voir l'historique
docker service inspect mon_app_web
```

---

## Services et stacks

### Créer et gérer des services

```bash
# Créer un service simple
docker service create --name web nginx:alpine

# Avec réplication
docker service create \
  --name web \
  --replicas 3 \
  --publish 80:80 \
  nginx:alpine

# Avec ressources
docker service create \
  --name web \
  --replicas 3 \
  --limit-cpu 0.5 \
  --limit-memory 512M \
  --reserve-cpu 0.25 \
  --reserve-memory 256M \
  nginx:alpine
```

### Inspection et surveillance

```bash
# Lister les services
docker service ls

# Détails d'un service
docker service inspect web

# Voir les tâches d'un service
docker service ps web

# Logs d'un service
docker service logs web
docker service logs -f --tail 100 web
```

### Mise à l'échelle

```bash
# Mettre à l'échelle manuellement
docker service scale web=5

# Mettre à l'échelle plusieurs services
docker service scale web=5 api=10 worker=3
```

---

## Réseaux et volumes

### Réseaux overlay

```bash
# Créer un réseau overlay
docker network create --driver overlay mon_reseau

# Avec chiffrement
docker network create \
  --driver overlay \
  --opt encrypted \
  mon_reseau_secure

# Attacher un service à un réseau
docker service create \
  --name web \
  --network mon_reseau \
  nginx:alpine
```

### Volumes dans Swarm

```yaml
# Dans docker-compose.yml
volumes:
  data:
    driver: local
    driver_opts:
      type: nfs
      o: addr=192.168.1.200,rw
      device: ":/path/to/nfs/share"
```

---

## Secrets et configs

### Gestion des secrets

```bash
# Créer un secret depuis un fichier
docker secret create mon_secret ./secret.txt

# Créer un secret depuis stdin
echo "mot_de_passe" | docker secret create db_password -

# Lister les secrets
docker secret ls

# Inspecter un secret
docker secret inspect mon_secret

# Supprimer un secret
docker secret rm mon_secret
```

### Utilisation dans les services

```yaml
services:
  db:
    image: postgres:14
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    external: true
```

### Gestion des configs

```bash
# Créer une config
docker config create nginx_conf ./nginx.conf

# Lister les configs
docker config ls

# Utiliser dans un service
docker service create \
  --name web \
  --config source=nginx_conf,target=/etc/nginx/nginx.conf \
  nginx:alpine
```

---

## Mise à l'échelle et rolling updates

### Configuration des mises à jour

```bash
# Mettre à jour un service avec rolling update
docker service update \
  --image nginx:1.21 \
  --update-parallelism 2 \
  --update-delay 10s \
  web

# Rollback en cas de problème
docker service rollback web
```

### Stratégies de déploiement

**Blue-Green deployment :**

```bash
# Déployer la nouvelle version
docker service create --name web-green nginx:new

# Basculer le trafic
docker service update --publish-add 80:80 web-green
docker service update --publish-rm 80:80 web-blue

# Supprimer l'ancienne version
docker service rm web-blue
```

---

## Monitoring et maintenance

### Surveillance du cluster

```bash
# État général du Swarm
docker node ls
docker service ls
docker stack ls

# Surveillance d'un service
watch docker service ps web

# Vérifier la santé
docker node inspect --format '{{.Status.State}}' node-1
```

### Health checks

```yaml
services:
  web:
    image: nginx:alpine
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

### Maintenance

```bash
# Drainer un nœud pour maintenance
docker node update --availability drain node-1

# Effectuer la maintenance
# ...

# Réactiver le nœud
docker node update --availability active node-1

# Nettoyer les ressources inutilisées
docker system prune -a
```

### Backup et restauration

```bash
# Backup des volumes
docker run --rm \
  -v nom_volume:/source:ro \
  -v $(pwd):/backup \
  alpine tar czf /backup/backup.tar.gz -C /source .

# Restauration
docker run --rm \
  -v nom_volume:/target \
  -v $(pwd):/backup \
  alpine tar xzf /backup/backup.tar.gz -C /target
```

---

## Bonnes pratiques

1. **Haute disponibilité** : Utiliser au moins 3 managers en production
2. **Sécurité** : Utiliser des secrets pour les données sensibles
3. **Ressources** : Définir des limites et réservations
4. **Labels** : Utiliser les labels pour organiser les services
5. **Monitoring** : Implémenter des health checks
6. **Mises à jour** : Toujours tester en staging avant production
7. **Logs** : Centraliser les logs (ELK, Loki, etc.)
8. **Networking** : Utiliser des réseaux overlay chiffrés pour les données sensibles
9. **Backup** : Sauvegarder régulièrement les volumes et la configuration
10. **Documentation** : Maintenir à jour la documentation de votre infrastructure

---

## Dépannage

### Problèmes courants

**Service ne démarre pas :**

```bash
docker service ps --no-trunc <service>
docker service logs <service>
```

**Problèmes réseau :**

```bash
docker network inspect <network>
docker service inspect <service>
```

**Nœud inaccessible :**

```bash
docker node inspect <node>
docker node update --availability drain <node>
```

### Commandes de diagnostic

```bash
# Voir l'état détaillé
docker system info
docker node inspect self
docker service inspect --pretty <service>

# Vérifier la connectivité
docker exec <container> ping <autre_service>
```

---

## Ressources supplémentaires

- [Documentation officielle Docker Swarm](https://docs.docker.com/engine/swarm/)
- [Docker Compose pour Swarm](https://docs.docker.com/compose/compose-file/)
- [Référence des commandes](https://docs.docker.com/engine/reference/commandline/docker/)

---

**Version :** 1.0  
**Dernière mise à jour :** Décembre 2025
