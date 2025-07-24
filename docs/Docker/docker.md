# 🐳 Docker – Commandes Essentielles

## 🛠️ Installation & Vérification

```bash
sudo apt install docker.io -y       #Installation docker
sudo apt install docker-compose -y  # Installation docker-compose
docker --version
docker info
```

---

## 📦 Images

### 🔍 Rechercher une image
```bash
docker search <nom>
```

### ⬇️ Télécharger une image
```bash
docker pull <image>
```

### 📋 Lister les images locales
```bash
docker images
```

### 🗑️ Supprimer une image
```bash
docker rmi <image_id ou nom>
```

---

## 🚀 Conteneurs

### ▶️ Lancer un conteneur
```bash
docker run <options> <image>
```
Exemples :
```bash
docker run -it ubuntu /bin/bash
docker run -d -p 8080:80 nginx
```

Options utiles :
- `-d` : détaché (background)
- `-p` : redirection de ports (ex: 8080:80)
- `--name` : nom du conteneur
- `-v` : volume
- `--rm` : supprime après arrêt
- `--restart unless-stopped` : redémarrage automatique

### 📋 Lister les conteneurs
```bash
docker ps           # conteneurs actifs
docker ps -a        # tous les conteneurs
```

### ⏹️ Arrêter / Démarrer un conteneur
```bash
docker stop <nom ou id>
docker start <nom ou id>
```

### 🗑️ Supprimer un conteneur
```bash
docker rm <nom ou id>
```

---

## 🧠 Shell & Exécution dans conteneur

### 💻 Accéder à un conteneur
```bash
docker exec -it <nom ou id> bash
```

### ▶️ Exécuter une commande dans un conteneur
```bash
docker exec -it <nom> <commande>
```

---

## 🧱 Volumes (Données persistantes)

### 📋 Lister les volumes
```bash
docker volume ls
```

### 🔍 Inspecter un volume
```bash
docker volume inspect <nom>
```

### 🗑️ Supprimer un volume
```bash
docker volume rm <nom>
```

### ➕ Monter un volume dans un conteneur
```bash
docker run -v nom_volume:/chemin/interne ...
```

---

## 🌐 Réseaux

### 📋 Lister les réseaux
```bash
docker network ls
```

### 🔍 Inspecter un réseau
```bash
docker network inspect <nom>
```

### ➕ Créer un réseau
```bash
docker network create <nom>
```

### 🗑️ Supprimer un réseau
```bash
docker network rm <nom>
```

---

## 🧹 Nettoyage

```bash
docker system prune             # Nettoyage global (conteneurs, images, réseaux)
docker volume prune             # Supprimer les volumes inutilisés
docker image prune              # Supprimer les images non utilisées
```

---

## 🐳 Docker Compose

```bash
docker-compose up -d           # Démarre les services en arrière-plan
docker-compose down            # Arrête et supprime les services
docker-compose ps              # Liste les services actifs
docker-compose logs -f         # Affiche les logs
```

---

## ✅ Vérifier que tout fonctionne

```bash
docker run hello-world
```