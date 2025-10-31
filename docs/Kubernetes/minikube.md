# 📗 Minikube - Kubernetes Local

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Démarrage et Configuration](#-démarrage-et-configuration)
- [Gestion du Cluster](#-gestion-du-cluster)
- [Addons](#-addons)
- [Gestion des Images Docker](#-gestion-des-images-docker)
- [Déploiement d'Applications](#-déploiement-dapplications)
- [Accès aux Services](#-accès-aux-services)
- [Profiles et Multi-Clusters](#-profiles-et-multi-clusters)
- [Tunneling et LoadBalancer](#-tunneling-et-loadbalancer)
- [Monitoring et Dashboard](#-monitoring-et-dashboard)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**Minikube** est un outil qui permet d'exécuter un cluster Kubernetes local sur votre machine pour le développement et les tests.

### Caractéristiques
- ✅ **Simple** : Installation et démarrage en quelques commandes
- ✅ **Rapide** : Démarrage du cluster en ~1 minute
- ✅ **Multi-drivers** : Support de différents hyperviseurs
- ✅ **Addons** : Dashboard, Ingress, Metrics Server intégrés
- ✅ **Multi-nodes** : Possibilité de créer plusieurs nodes
- ✅ **Isolation** : Chaque cluster est isolé dans sa VM/conteneur

### Cas d'usage
- 💻 **Développement local** d'applications Kubernetes
- 🎓 **Apprentissage** de Kubernetes
- 🧪 **Tests** de manifests et configurations
- 🔬 **Prototypage** rapide
- 📝 **CI/CD** locaux
- 🎯 **Démonstrations** et formations

### Minikube vs Alternatives

| Aspect | Minikube | K3s | Kind | Docker Desktop |
|--------|----------|-----|------|----------------|
| **Installation** | 🟢 Simple | 🟢 Simple | 🟢 Simple | 🟢 Simple |
| **Démarrage** | ~1 min | ~30s | ~30s | ~1 min |
| **RAM recommandée** | 2GB | 512MB | 2GB | 2GB |
| **Multi-nodes** | ✅ Oui | ✅ Oui | ✅ Oui | ❌ Non |
| **Addons** | ✅ Nombreux | ⚠️ Limité | ❌ Non | ⚠️ Limité |
| **Dashboard** | ✅ Intégré | ❌ Non | ❌ Non | ✅ Intégré |
| **Production** | ❌ Non | ✅ Oui | ❌ Non | ❌ Non |

---

## 🔧 Prérequis

### Configuration système requise

```bash
# Minimum
- CPU: 2 cores
- RAM: 2GB
- Disk: 20GB
- OS: Linux, macOS, Windows

# Recommandé
- CPU: 4+ cores
- RAM: 4GB+
- Disk: 40GB+
- Virtualisation activée (VT-x/AMD-v)
```

### Vérifier la virtualisation

#### Linux
```bash
# Vérifier si la virtualisation est activée
grep -E --color 'vmx|svm' /proc/cpuinfo

# Si rien ne s'affiche, activer dans le BIOS
# Intel: VT-x
# AMD: AMD-V
```

#### macOS
```bash
# La virtualisation est généralement activée par défaut
sysctl -a | grep -E --color 'machdep.cpu.features|VMX'
```

#### Windows
```powershell
# PowerShell (Admin)
systeminfo | findstr /C:"Virtualization"

# Doit afficher: "Virtualization Enabled In Firmware: Yes"
```

---

## 📥 Installation

### Linux

#### Méthode 1 : Binaire direct (Recommandée)
```bash
# Télécharger la dernière version
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Installer
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Nettoyer
rm minikube-linux-amd64

# Vérifier
minikube version
```

#### Méthode 2 : Package manager
```bash
# Debian/Ubuntu
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/v1.28/deb/Release.key | \
    sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
    
wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y minikube

# Arch Linux
yay -S minikube

# Fedora
sudo dnf install minikube
```

---

### macOS

```bash
# Via Homebrew (Recommandé)
brew install minikube

# Ou binaire direct
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
rm minikube-darwin-amd64

# Vérifier
minikube version
```

---

### Windows

#### Méthode 1 : Chocolatey
```powershell
# PowerShell (Admin)
choco install minikube
```

#### Méthode 2 : Winget
```powershell
winget install Kubernetes.minikube
```

#### Méthode 3 : Installeur
```powershell
# Télécharger depuis
# https://minikube.sigs.k8s.io/docs/start/

# Installer et ajouter au PATH
# Vérifier
minikube version
```

---

### Installation des Drivers

Minikube nécessite un driver de virtualisation :

#### Docker (Recommandé - Multi-plateforme)
```bash
# Linux
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# macOS
brew install docker

# Windows
# Installer Docker Desktop depuis docker.com

# Vérifier
docker --version
```

#### VirtualBox (Alternative)
```bash
# Linux
sudo apt install virtualbox virtualbox-ext-pack

# macOS
brew install --cask virtualbox

# Windows
choco install virtualbox

# Vérifier
VBoxManage --version
```

#### KVM (Linux uniquement)
```bash
# Ubuntu/Debian
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Vérifier
virsh list --all
```

#### HyperKit (macOS uniquement)
```bash
brew install hyperkit
```

#### Hyper-V (Windows uniquement)
```powershell
# PowerShell (Admin)
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

---

## 🚀 Démarrage et Configuration

### Démarrage Simple

```bash
# Démarrer avec le driver par défaut
minikube start

# Vérifier le statut
minikube status

# Afficher les informations
kubectl cluster-info
kubectl get nodes
```

---

### Démarrage avec Options

```bash
# Spécifier le driver
minikube start --driver=docker
minikube start --driver=virtualbox
minikube start --driver=kvm2
minikube start --driver=hyperkit

# Allouer des ressources
minikube start --cpus=4 --memory=8192 --disk-size=40g

# Version de Kubernetes spécifique
minikube start --kubernetes-version=v1.28.0

# Avec un nom personnalisé
minikube start -p dev-cluster

# Configuration complète
minikube start \
  --driver=docker \
  --cpus=4 \
  --memory=8192 \
  --disk-size=40g \
  --kubernetes-version=v1.28.0 \
  --nodes=3 \
  -p my-cluster
```

---

### Définir le Driver par Défaut

```bash
# Définir Docker comme driver par défaut
minikube config set driver docker

# Autres drivers
minikube config set driver virtualbox
minikube config set driver kvm2
minikube config set driver hyperkit

# Voir la configuration
minikube config view
```

---

## 🔧 Gestion du Cluster

### Commandes de Base

```bash
# Statut du cluster
minikube status

# Informations détaillées
minikube profile list
minikube version
kubectl cluster-info

# Arrêter le cluster
minikube stop

# Démarrer un cluster arrêté
minikube start

# Redémarrer le cluster
minikube stop && minikube start

# Suspendre le cluster (pause)
minikube pause

# Reprendre un cluster en pause
minikube unpause

# Supprimer le cluster
minikube delete

# Supprimer tous les clusters
minikube delete --all
```

---

### Accès au Cluster

```bash
# SSH dans le node Minikube
minikube ssh

# Exécuter une commande dans le node
minikube ssh "docker ps"
minikube ssh "sudo crictl ps"

# Voir les logs du cluster
minikube logs

# Logs en temps réel
minikube logs -f

# IP du cluster
minikube ip

# Obtenir l'URL du service Kubernetes
kubectl cluster-info
```

---

### Mise à Jour

```bash
# Mettre à jour Minikube
# Linux/macOS
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Via package manager
brew upgrade minikube          # macOS
sudo apt update && sudo apt upgrade minikube  # Ubuntu
choco upgrade minikube         # Windows

# Mettre à jour Kubernetes dans le cluster
minikube start --kubernetes-version=v1.29.0

# Vérifier la version
minikube version
kubectl version
```

---

## 🧩 Addons

### Lister les Addons Disponibles

```bash
# Voir tous les addons
minikube addons list

# Addons populaires:
# - dashboard: Interface web Kubernetes
# - ingress: Contrôleur Ingress NGINX
# - metrics-server: Métriques de ressources
# - registry: Registry Docker local
# - storage-provisioner: Provisionnement de volumes
```

---

### Activer/Désactiver des Addons

```bash
# Activer un addon
minikube addons enable <nom>

# Exemples
minikube addons enable dashboard
minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable registry

# Désactiver un addon
minikube addons disable <nom>

# Voir le statut d'un addon
minikube addons list | grep <nom>
```

---

### Addons Essentiels

#### Dashboard (Interface Web)
```bash
# Activer le dashboard
minikube addons enable dashboard

# Ouvrir le dashboard dans le navigateur
minikube dashboard

# Obtenir l'URL sans ouvrir
minikube dashboard --url

# Dashboard en arrière-plan
minikube dashboard &
```

#### Ingress Controller
```bash
# Activer Ingress NGINX
minikube addons enable ingress

# Vérifier l'installation
kubectl get pods -n ingress-nginx

# Exemple d'Ingress
cat > ingress.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - host: hello.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-service
            port:
              number: 80
EOF

kubectl apply -f ingress.yaml

# Ajouter à /etc/hosts
echo "$(minikube ip) hello.local" | sudo tee -a /etc/hosts
```

#### Metrics Server
```bash
# Activer metrics-server
minikube addons enable metrics-server

# Attendre quelques secondes, puis vérifier
kubectl top nodes
kubectl top pods
```

#### Registry Local
```bash
# Activer le registry
minikube addons enable registry

# Obtenir l'URL du registry
minikube service registry -n kube-system --url

# Utiliser le registry
docker tag my-image:latest $(minikube ip):5000/my-image:latest
docker push $(minikube ip):5000/my-image:latest
```

---

## 🐳 Gestion des Images Docker

### Méthode 1 : Docker Daemon de Minikube (Recommandée)

```bash
# Pointer Docker vers le daemon de Minikube
eval $(minikube docker-env)

# Vérifier
docker ps

# Maintenant, construire directement dans Minikube
docker build -t my-app:latest .

# L'image est directement disponible dans Minikube
kubectl run my-app --image=my-app:latest --image-pull-policy=Never

# Revenir au Docker local
eval $(minikube docker-env -u)
```

---

### Méthode 2 : Load une Image

```bash
# Construire l'image localement
docker build -t my-aspnetapp:latest .

# Charger l'image dans Minikube
minikube image load my-aspnetapp:latest

# Ou depuis un fichier tar
docker save my-aspnetapp:latest > my-aspnetapp.tar
minikube image load my-aspnetapp.tar

# Vérifier
minikube image ls | grep my-aspnetapp

# Utiliser dans un pod
kubectl run my-app --image=my-aspnetapp:latest --image-pull-policy=Never
```

---

### Méthode 3 : Registry Local avec Addon

```bash
# Activer le registry addon
minikube addons enable registry

# Construire et tagger pour le registry
docker build -t localhost:5000/my-app:latest .

# Pousser vers le registry Minikube
docker push localhost:5000/my-app:latest

# Utiliser dans Kubernetes
kubectl run my-app --image=localhost:5000/my-app:latest
```

---

### Commandes de Gestion des Images

```bash
# Lister les images dans Minikube
minikube image ls
minikube image ls --format table

# Charger une image
minikube image load <image:tag>

# Construire une image dans Minikube
minikube image build -t my-app:latest .

# Supprimer une image
minikube image rm <image:tag>

# Pull une image
minikube image pull nginx:latest

# Sauvegarder une image
minikube image save <image:tag> -o image.tar
```

---

### Configuration ImagePullPolicy

```yaml
# deployment-local.yaml
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
        imagePullPolicy: Never  # N'essaie pas de pull, utilise l'image locale
        ports:
        - containerPort: 3000
```

---

## 📦 Déploiement d'Applications

### Exemple Complet : Application Node.js

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
        imagePullPolicy: Never
        ports:
        - containerPort: 3000
          name: http
        env:
        - name: NODE_ENV
          value: "development"
        - name: PORT
          value: "3000"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: node-app-service
  labels:
    app: node-app
spec:
  type: NodePort
  selector:
    app: node-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
    nodePort: 30080
```

```bash
# Déployer
kubectl apply -f deployment.yaml

# Vérifier
kubectl get deployments
kubectl get pods
kubectl get services

# Voir les logs
kubectl logs -l app=node-app -f

# Accéder à l'application
minikube service node-app-service
# Ou
curl $(minikube ip):30080
```

---

## 🌐 Accès aux Services

### Service Type: NodePort

```bash
# Obtenir l'URL du service
minikube service <service-name>

# Obtenir l'URL sans ouvrir le navigateur
minikube service <service-name> --url

# Exemple
minikube service node-app-service
minikube service node-app-service --url

# Liste de tous les services
minikube service list
```

---

### Service Type: LoadBalancer

```bash
# Minikube simule un LoadBalancer avec tunnel
minikube tunnel

# Dans un autre terminal
kubectl get services

# Le LoadBalancer aura une EXTERNAL-IP
# Accéder via cette IP

# Exemple de service LoadBalancer
apiVersion: v1
kind: Service
metadata:
  name: lb-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
```

**Note:** `minikube tunnel` nécessite des privilèges sudo et doit rester actif.

---

### Port Forwarding

```bash
# Forward un port de pod vers localhost
kubectl port-forward pod/<pod-name> 8080:3000

# Forward un service
kubectl port-forward service/<service-name> 8080:80

# Exemple
kubectl port-forward service/node-app-service 8080:80

# Accéder
curl http://localhost:8080
```

---

## 👥 Profiles et Multi-Clusters

### Créer et Gérer des Profiles

```bash
# Créer un nouveau profile (cluster)
minikube start -p dev-cluster
minikube start -p test-cluster
minikube start -p staging-cluster

# Lister tous les profiles
minikube profile list

# Changer de profile
minikube profile dev-cluster
minikube profile test-cluster

# Voir le profile actif
minikube profile

# Commandes spécifiques à un profile
minikube status -p dev-cluster
minikube stop -p test-cluster
minikube delete -p staging-cluster
```

---

### Multi-Nodes dans un Cluster

```bash
# Créer un cluster avec 3 nodes
minikube start --nodes 3

# Ajouter un node à un cluster existant
minikube node add

# Voir les nodes
kubectl get nodes
minikube node list

# Supprimer un node
minikube node delete <node-name>

# SSH dans un node spécifique
minikube ssh -n <node-name>
```

---

## 🔄 Tunneling et LoadBalancer

### Minikube Tunnel

```bash
# Démarrer le tunnel (nécessite sudo)
minikube tunnel

# Le tunnel créé des routes pour les LoadBalancers
# Garder cette commande active

# Dans un autre terminal
kubectl get services

# Les services LoadBalancer auront une EXTERNAL-IP
# Exemple: 10.96.0.1
```

### Exemple avec LoadBalancer

```yaml
# loadbalancer-service.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-lb
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-lb-service
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

```bash
# Déployer
kubectl apply -f loadbalancer-service.yaml

# Dans un terminal
minikube tunnel

# Dans un autre terminal
kubectl get svc nginx-lb-service
# EXTERNAL-IP sera visible

# Accéder
curl http://<EXTERNAL-IP>
```

---

## 📊 Monitoring et Dashboard

### Kubernetes Dashboard

```bash
# Activer le dashboard
minikube addons enable dashboard

# Lancer le dashboard
minikube dashboard

# URL du dashboard sans ouvrir
minikube dashboard --url

# Accès via kubectl proxy
kubectl proxy
# Puis accéder : http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```

---

### Metrics et Monitoring

```bash
# Activer metrics-server
minikube addons enable metrics-server

# Attendre ~30 secondes pour collecter les métriques

# Voir les métriques des nodes
kubectl top nodes

# Voir les métriques des pods
kubectl top pods
kubectl top pods --all-namespaces
kubectl top pods -n kube-system

# Trier par CPU
kubectl top pods --sort-by=cpu

# Trier par mémoire
kubectl top pods --sort-by=memory
```

---

### Logs et Events

```bash
# Logs du cluster Minikube
minikube logs
minikube logs -f

# Logs d'un pod
kubectl logs <pod-name>
kubectl logs -f <pod-name>
kubectl logs <pod-name> -c <container-name>

# Logs de tous les pods d'un deployment
kubectl logs -l app=my-app -f

# Events Kubernetes
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events -w  # Watch mode
```

---

## 🔧 Dépannage

### Problèmes Courants

#### Minikube ne démarre pas

```bash
# Voir les logs détaillés
minikube start --alsologtostderr -v=7

# Supprimer et recréer le cluster
minikube delete
minikube start

# Vérifier la virtualisation
# Linux
grep -E 'vmx|svm' /proc/cpuinfo

# Essayer un autre driver
minikube start --driver=docker
minikube start --driver=virtualbox
```

---

#### Problèmes de ressources

```bash
# Vérifier les ressources allouées
minikube config view

# Augmenter les ressources
minikube delete
minikube start --cpus=4 --memory=8192 --disk-size=40g

# Voir l'utilisation des ressources
kubectl top nodes
kubectl top pods --all-namespaces
```

---

#### Images ne se chargent pas

```bash
# Vérifier que vous utilisez le daemon Minikube
eval $(minikube docker-env)
docker images

# Charger manuellement une image
minikube image load my-image:latest

# Vérifier
minikube image ls | grep my-image

# Utiliser avec imagePullPolicy: Never
kubectl run test --image=my-image:latest --image-pull-policy=Never
```

---

#### Service inaccessible

```bash
# Vérifier que le service existe
kubectl get services

# Pour NodePort
minikube service <service-name> --url
curl $(minikube service <service-name> --url)

# Pour LoadBalancer, tunnel doit être actif
minikube tunnel

# Port forwarding comme alternative
kubectl port-forward service/<service-name> 8080:80
```

---

#### Dashboard ne s'ouvre pas

```bash
# Vérifier que l'addon est activé
minikube addons list | grep dashboard

# Activer si nécessaire
minikube addons enable dashboard

# Vérifier les pods du dashboard
kubectl get pods -n kubernetes-dashboard

# Redémarrer si nécessaire
minikube addons disable dashboard
minikube addons enable dashboard

# Utiliser kubectl proxy
kubectl proxy
# Accéder via: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```

---

#### Nettoyer l'espace disque

```bash
# Voir l'utilisation du disque
minikube ssh "df -h"

# Nettoyer les images non utilisées
minikube ssh "docker system prune -af"

# Nettoyer les volumes
minikube ssh "docker volume prune -f"

# Redémarrer avec plus d'espace
minikube delete
minikube start --disk-size=60g
```

---

### Commandes de Diagnostic

```bash
# Statut complet
minikube status
minikube version
kubectl version
kubectl cluster-info

# Configuration
minikube config view
kubectl config view

# Logs système
minikube logs
journalctl -u minikube  # Linux

# SSH pour investigation
minikube ssh
# Dans le node:
docker ps
docker images
crictl ps
crictl images

# Redémarrage complet
minikube stop
minikube start
```

---

## 📚 Ressources Complémentaires

### Documentation Officielle
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

### Guides Kubernetes Connexes
- 📘 [Kubernetes - Guide Général](./kubernetes.md)
- 🐄 [K3s - Kubernetes Léger](./k3s.md)
- 📕 [EKS - Amazon Elastic Kubernetes Service](./eks.md)

### Tutoriels et Outils
- [Katacoda - Interactive Learning](https://www.katacoda.com/courses/kubernetes)
- [Play with Kubernetes](https://labs.play-with-k8s.com/)
- [K9s - Terminal UI](https://k9scli.io/)
- [Lens - Kubernetes IDE](https://k8slens.dev/)

---

## 🎯 Commandes de Référence Rapide

```bash
# Cycle de vie
minikube start                    # Démarrer
minikube stop                     # Arrêter
minikube delete                   # Supprimer
minikube status                   # Statut

# Configuration
minikube config set driver docker # Définir driver
minikube config view              # Voir config

# Addons
minikube addons list              # Lister
minikube addons enable dashboard  # Activer
minikube addons disable ingress   # Désactiver

# Images
eval $(minikube docker-env)       # Use Minikube Docker
minikube image load <image>       # Charger image
minikube image ls                 # Lister images

# Services
minikube service <name>           # Ouvrir service
minikube service list             # Lister services
minikube tunnel                   # Tunnel LoadBalancer

# Accès
minikube dashboard                # Dashboard
minikube ssh                      # SSH
minikube ip                       # IP cluster
minikube logs                     # Logs

# Profiles
minikube start -p <name>          # Nouveau cluster
minikube profile list             # Lister clusters
minikube profile <name>           # Changer cluster
```

---

**🎉 Vous êtes prêt à développer avec Minikube !**
