# 🐄 K3s - Kubernetes Léger

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Gestion des images Docker](#-gestion-des-images-docker)
- [Déploiement d'applications](#-déploiement-dapplications)
- [Cluster multi-nodes](#-cluster-multi-nodes)
- [High Availability](#-high-availability)
- [Stockage](#-stockage)
- [Monitoring](#-monitoring)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**K3s** est une distribution Kubernetes légère et certifiée, conçue pour des environnements avec des ressources limitées.

### Caractéristiques
- ✅ **Léger** : Binaire unique de ~70MB (vs ~1GB pour K8s)
- ✅ **Rapide** : Installation en une seule commande
- ✅ **Faible consommation** : ~512MB de RAM minimum
- ✅ **Production-ready** : Certifié Kubernetes
- ✅ **Simple** : Configuration automatique
- ✅ **Intégré** : SQLite, containerd, Flannel inclus

### Cas d'usage
- 🌐 **IoT & Edge Computing**
- 🏡 **Home Lab & Raspberry Pi**
- 🚀 **CI/CD Pipelines**
- 💻 **Environnements de développement**
- 📦 **Serveurs légers**
- 🎓 **Apprentissage de Kubernetes**

### K3s vs K8s Standard

| Aspect | K3s | K8s Standard |
|--------|-----|--------------|
| Taille binaire | ~70MB | ~1GB |
| RAM minimum | 512MB | 2GB |
| Installation | 1 commande | Multiple étapes |
| Datastore | SQLite/etcd | etcd |
| Runtime | containerd | Docker/containerd |
| Ingress | Traefik | Aucun par défaut |
| LoadBalancer | ServiceLB | Aucun par défaut |

---

## 🔧 Prérequis

### Système requis

```bash
# Minimum
- CPU: 1 core
- RAM: 512MB
- Disk: 1GB
- OS: Linux (kernel 3.10+)

# Recommandé
- CPU: 2+ cores
- RAM: 2GB
- Disk: 10GB
- OS: Ubuntu 20.04+, Debian 11+, CentOS 7+
```

### Vérifications préalables

```bash
# Version du kernel
uname -r
# Doit être >= 3.10

# Espace disque
df -h

# Mémoire disponible
free -h

# Ouvrir les ports nécessaires
# 6443: API Server
# 10250: kubelet
# 8472: Flannel VXLAN (si utilisé)

# Vérifier les ports
sudo netstat -tulpn | grep -E '6443|10250|8472'
```

---

## 📥 Installation

### Installation Server (Single Node)

```bash
# Installation standard
curl -sfL https://get.k3s.io | sh -

# Vérifier l'installation
sudo systemctl status k3s

# Configuration kubectl automatique
sudo cat /etc/rancher/k3s/k3s.yaml
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

# Vérifier le cluster
kubectl get nodes
kubectl cluster-info
kubectl get pods --all-namespaces
```

---

### Installation avec Options Personnalisées

```bash
# Sans Traefik (ingress controller)
curl -sfL https://get.k3s.io | sh -s - --disable traefik

# Sans ServiceLB (load balancer)
curl -sfL https://get.k3s.io | sh -s - --disable servicelb

# Sans Traefik ET ServiceLB
curl -sfL https://get.k3s.io | sh -s - \
  --disable traefik \
  --disable servicelb

# Port API personnalisé
curl -sfL https://get.k3s.io | sh -s - --https-listen-port 6443

# Avec Docker au lieu de containerd
curl -sfL https://get.k3s.io | sh -s - --docker

# Configuration kubeconfig avec permissions
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Installation complète personnalisée
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --disable traefik \
  --disable servicelb \
  --write-kubeconfig-mode 644 \
  --node-name k3s-master \
  --node-label environment=production" sh -
```

---

### Installation avec Version Spécifique

```bash
# Lister les versions disponibles
curl -s https://api.github.com/repos/k3s-io/k3s/releases | grep tag_name

# Installer une version spécifique
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.28.5+k3s1 sh -

# Vérifier la version
k3s --version
kubectl version --short
```

---

## ⚙️ Configuration

### Gestion du Service K3s

```bash
# Démarrer K3s
sudo systemctl start k3s

# Arrêter K3s
sudo systemctl stop k3s

# Redémarrer K3s
sudo systemctl restart k3s

# Statut
sudo systemctl status k3s

# Activer au démarrage
sudo systemctl enable k3s

# Désactiver au démarrage
sudo systemctl disable k3s

# Voir les logs
sudo journalctl -u k3s -f
sudo journalctl -u k3s --since "10 minutes ago"
```

---

### Fichier de Configuration

```bash
# Créer un fichier de configuration
sudo mkdir -p /etc/rancher/k3s

# Configuration server
sudo cat > /etc/rancher/k3s/config.yaml << EOF
write-kubeconfig-mode: "0644"
disable:
  - traefik
  - servicelb
node-name: "k3s-master"
cluster-cidr: "10.42.0.0/16"
service-cidr: "10.43.0.0/16"
node-label:
  - "environment=production"
  - "role=master"
EOF

# Redémarrer pour appliquer
sudo systemctl restart k3s
```

---

### Accès kubectl sans sudo

```bash
# Méthode 1 : Copier le kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
chmod 600 ~/.kube/config

# Méthode 2 : Variable d'environnement
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.bashrc
source ~/.bashrc

# Méthode 3 : Ajouter l'utilisateur au groupe
sudo usermod -aG k3s $USER
newgrp k3s

# Vérifier
kubectl get nodes
```

---

## 🐳 Gestion des Images Docker

### Importer des Images Locales

K3s utilise **containerd** comme runtime de conteneurs. Voici comment importer vos images Docker :

#### Méthode 1 : Save et Import (Recommandée)

```bash
# 1. Sur votre machine de développement avec Docker
docker build -t my-aspnetapp:latest .

# 2. Sauvegarder l'image en fichier tar
docker save my-aspnetapp:latest > my-aspnetapp.tar

# Ou avec compression (recommandé)
docker save my-aspnetapp:latest | gzip > my-aspnetapp.tar.gz

# 3. Transférer vers le serveur K3s
scp my-aspnetapp.tar user@k3s-server:/tmp/
# ou
scp my-aspnetapp.tar.gz user@k3s-server:/tmp/

# 4. Sur le serveur K3s, importer l'image
sudo k3s ctr images import /tmp/my-aspnetapp.tar

# Ou si compressé
gunzip < /tmp/my-aspnetapp.tar.gz | sudo k3s ctr images import -

# 5. Vérifier l'import
sudo k3s ctr images list | grep my-aspnetapp
sudo k3s ctr images ls | grep my-aspnetapp

# 6. Utiliser l'image dans un pod
kubectl run my-app \
  --image=my-aspnetapp:latest \
  --image-pull-policy=Never
```

#### Méthode 2 : Registry Privé Local

```bash
# 1. Démarrer un registry local sur K3s
kubectl create namespace registry

kubectl apply -f - << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: registry-pvc
  namespace: registry
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: registry
  namespace: registry
spec:
  replicas: 1
  selector:
    matchLabels:
      app: registry
  template:
    metadata:
      labels:
        app: registry
    spec:
      containers:
      - name: registry
        image: registry:2
        ports:
        - containerPort: 5000
        volumeMounts:
        - name: storage
          mountPath: /var/lib/registry
      volumes:
      - name: storage
        persistentVolumeClaim:
          claimName: registry-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: registry
  namespace: registry
spec:
  type: NodePort
  selector:
    app: registry
  ports:
  - port: 5000
    nodePort: 30500
EOF

# 2. Sur votre machine de dev, tagger et pousser
docker tag my-aspnetapp:latest localhost:30500/my-aspnetapp:latest
docker push localhost:30500/my-aspnetapp:latest

# 3. Utiliser dans K3s
kubectl run my-app --image=localhost:30500/my-aspnetapp:latest
```

#### Méthode 3 : Docker Hub / Registry Public

```bash
# 1. Se connecter à Docker Hub
docker login

# 2. Tagger l'image
docker tag my-aspnetapp:latest <votre_dockerhub_user>/my-aspnetapp:latest

# 3. Pousser vers Docker Hub
docker push <votre_dockerhub_user>/my-aspnetapp:latest

# 4. Utiliser dans K3s (pull automatique)
kubectl run my-app --image=<votre_dockerhub_user>/my-aspnetapp:latest
```

---

### Commandes de Gestion des Images K3s

```bash
# Lister toutes les images
sudo k3s ctr images list
sudo k3s ctr images ls

# Format lisible
sudo k3s ctr images ls -q

# Rechercher une image spécifique
sudo k3s ctr images list | grep <nom_image>
sudo k3s ctr images ls | grep my-aspnetapp

# Pull une image depuis un registry
sudo k3s ctr images pull docker.io/library/nginx:latest
sudo k3s ctr images pull docker.io/<user>/<image>:tag

# Tag une image
sudo k3s ctr images tag <source> <target>
sudo k3s ctr images tag nginx:latest my-nginx:v1.0

# Supprimer une image
sudo k3s ctr images remove <nom_image>
sudo k3s ctr images rm docker.io/library/nginx:latest

# Informations sur une image
sudo k3s ctr images check

# Export d'une image
sudo k3s ctr images export image.tar <nom_image>

# Nettoyer les images non utilisées
sudo k3s crictl rmi --prune
```

---

### Configuration ImagePullPolicy

```yaml
# deployment-local-image.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: my-aspnetapp:latest
        imagePullPolicy: Never  # N'essaie JAMAIS de pull, utilise locale uniquement
        ports:
        - containerPort: 3000

---
# deployment-always-pull.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-updated
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: dockerhub-user/my-aspnetapp:latest
        imagePullPolicy: Always  # Pull à chaque fois
        ports:
        - containerPort: 3000

---
# deployment-if-not-present.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-cached
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: my-aspnetapp:v1.0.0
        imagePullPolicy: IfNotPresent  # Pull uniquement si pas en local (par défaut)
        ports:
        - containerPort: 3000
```

---

## 📦 Déploiement d'Applications

### Exemple : Application Node.js

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app
  labels:
    app: node-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: node-app
  template:
    metadata:
      labels:
        app: node-app
    spec:
      containers:
      - name: node-app
        image: my-aspnetapp:latest
        imagePullPolicy: Never  # Image locale importée
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: node-app-service
spec:
  type: LoadBalancer  # ServiceLB de K3s
  selector:
    app: node-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
```

```bash
# Déployer
kubectl apply -f deployment.yaml

# Vérifier
kubectl get deployments
kubectl get pods
kubectl get services

# Accéder à l'application
# ServiceLB expose automatiquement sur l'IP du node
kubectl get svc node-app-service
curl http://<NODE_IP>:80
```

---

## 🔗 Cluster Multi-Nodes

### Architecture

```
┌─────────────────────────────────────────┐
│           K3s Master Node               │
│  • API Server                           │
│  • Scheduler                            │
│  • Controller Manager                   │
│  • etcd/SQLite                          │
│  • Workloads (optionnel)                │
└─────────────────────────────────────────┘
           │
           ├──────────┬──────────┐
           │          │          │
┌──────────▼─┐  ┌────▼──────┐  ┌▼──────────┐
│  Worker 1  │  │  Worker 2 │  │  Worker 3 │
│  • Kubelet │  │  • Kubelet│  │  • Kubelet│
│  • Pods    │  │  • Pods   │  │  • Pods   │
└────────────┘  └───────────┘  └───────────┘
```

### Installation Master (Server)

```bash
# Sur le master
curl -sfL https://get.k3s.io | sh -s - server \
  --write-kubeconfig-mode 644 \
  --node-name k3s-master

# Récupérer le token pour les workers
sudo cat /var/lib/rancher/k3s/server/node-token
# Exemple: K10abc123def456ghi789jkl...

# Récupérer l'IP du master
ip addr show | grep inet
```

### Installation Workers (Agents)

```bash
# Sur chaque worker
curl -sfL https://get.k3s.io | K3S_URL=https://<IP_MASTER>:6443 \
  K3S_TOKEN=<TOKEN_FROM_MASTER> \
  sh -s - agent --node-name worker-1

# Exemples avec options
# Worker 2
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.100:6443 \
  K3S_TOKEN=K10abc123... \
  sh -s - agent --node-name worker-2 \
  --node-label role=worker \
  --node-label zone=eu-west

# Worker 3
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.100:6443 \
  K3S_TOKEN=K10abc123... \
  sh -s - agent --node-name worker-3
```

### Vérification du Cluster

```bash
# Sur le master
kubectl get nodes
kubectl get nodes -o wide

# Détails d'un node
kubectl describe node worker-1

# Labels des nodes
kubectl get nodes --show-labels

# Ajouter un label à un node
kubectl label nodes worker-1 disktype=ssd

# Retirer un label
kubectl label nodes worker-1 disktype-
```

---

## 🏆 High Availability (HA)

### Architecture HA

```bash
# 3 masters minimum pour HA
curl -sfL https://get.k3s.io | sh -s - server \
  --cluster-init \
  --node-name k3s-master-1

# Récupérer le token
sudo cat /var/lib/rancher/k3s/server/node-token

# Ajouter les autres masters
curl -sfL https://get.k3s.io | K3S_URL=https://<FIRST_MASTER_IP>:6443 \
  K3S_TOKEN=<TOKEN> \
  sh -s - server --node-name k3s-master-2

curl -sfL https://get.k3s.io | K3S_URL=https://<FIRST_MASTER_IP>:6443 \
  K3S_TOKEN=<TOKEN> \
  sh -s - server --node-name k3s-master-3

# Vérifier
kubectl get nodes
```

---

## 💾 Stockage

### Local Path Provisioner (Par défaut)

```yaml
# pvc-local.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-storage
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path  # StorageClass par défaut de K3s
  resources:
    requests:
      storage: 5Gi
```

```bash
# App
