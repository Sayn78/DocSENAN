# ☸️ Kubernetes – Guide Complet

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Concepts fondamentaux](#-concepts-fondamentaux)
- [Installation kubectl](#-installation-kubectl)
- [Commandes essentielles](#-commandes-essentielles)
- [Objets Kubernetes](#-objets-kubernetes)
- [Déploiement d'applications](#-déploiement-dapplications)
- [Configuration & Secrets](#-configuration--secrets)
- [Réseau & Services](#-réseau--services)
- [Stockage](#-stockage)
- [Mise à l'échelle](#-mise-à-léchelle)
- [Monitoring & Logs](#-monitoring--logs)
- [Bonnes pratiques](#-bonnes-pratiques)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**Kubernetes (K8s)** est une plateforme open-source d'orchestration de conteneurs permettant d'automatiser le déploiement, la mise à l'échelle et la gestion d'applications conteneurisées.

### Pourquoi Kubernetes ?
- ✅ **Haute disponibilité** : Redémarrage automatique des conteneurs défaillants
- ✅ **Scalabilité** : Mise à l'échelle automatique selon la charge
- ✅ **Déploiements sans interruption** : Rolling updates et rollbacks
- ✅ **Auto-healing** : Détection et remplacement des pods défaillants
- ✅ **Gestion de configuration** : ConfigMaps et Secrets
- ✅ **Load balancing** : Distribution automatique du trafic
- ✅ **Multi-cloud** : Fonctionne sur AWS, Azure, GCP, on-premise

### Alternatives à Kubernetes
- **Minikube** : K8s local pour développement ([voir guide](./minikube.md))
- **EKS** : Kubernetes managé sur AWS ([voir guide](./eks.md))
- **GKE** : Kubernetes managé sur Google Cloud
- **AKS** : Kubernetes managé sur Azure
- **Docker Swarm** : Orchestrateur plus simple
- **Nomad** : Alternative HashiCorp

---

## 🧩 Concepts Fondamentaux

### Architecture Kubernetes

```
┌─────────────────────────────────────────────┐
│           CONTROL PLANE (Master)            │
├─────────────────────────────────────────────┤
│  API Server  │  Scheduler  │  Controller    │
│  etcd (DB)   │  Cloud Controller Manager    │
└─────────────────────────────────────────────┘
                    ↓ ↓ ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   NODE 1     │  │   NODE 2     │  │   NODE 3     │
├──────────────┤  ├──────────────┤  ├──────────────┤
│  Kubelet     │  │  Kubelet     │  │  Kubelet     │
│  Kube-proxy  │  │  Kube-proxy  │  │  Kube-proxy  │
│  Container   │  │  Container   │  │  Container   │
│  Runtime     │  │  Runtime     │  │  Runtime     │
├──────────────┤  ├──────────────┤  ├──────────────┤
│  Pod  Pod    │  │  Pod  Pod    │  │  Pod  Pod    │
└──────────────┘  └──────────────┘  └──────────────┘
```

### Composants du Control Plane
- **API Server** : Point d'entrée pour toutes les opérations
- **etcd** : Base de données clé-valeur pour l'état du cluster
- **Scheduler** : Assigne les pods aux nodes
- **Controller Manager** : Gère les contrôleurs (ReplicaSet, Deployment, etc.)

### Composants des Nodes
- **Kubelet** : Agent sur chaque node, gère les pods
- **Kube-proxy** : Gère le réseau et le load balancing
- **Container Runtime** : Docker, containerd, CRI-O

### Hiérarchie des objets

```
Cluster
└── Namespace
    └── Deployment
        └── ReplicaSet
            └── Pod
                └── Container(s)
```

---

## 📥 Installation kubectl

### Linux

```bash
# Télécharger la dernière version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Vérifier le checksum (optionnel)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Installer kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Vérifier l'installation
kubectl version --client
```

### macOS

```bash
# Via Homebrew
brew install kubectl

# Ou téléchargement direct
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Vérifier
kubectl version --client
```

### Windows (PowerShell)

```powershell
# Via Chocolatey
choco install kubernetes-cli

# Ou via Scoop
scoop install kubectl

# Vérifier
kubectl version --client
```

### Configuration de l'autocomplétion

```bash
# Bash
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc

# Zsh
echo 'source <(kubectl completion zsh)' >> ~/.zshrc
echo 'alias k=kubectl' >> ~/.zshrc
echo 'complete -F __start_kubectl k' >> ~/.zshrc

# Recharger
source ~/.bashrc  # ou source ~/.zshrc
```

---

## 🎮 Commandes Essentielles

### Gestion du contexte

```bash
# Voir la configuration actuelle
kubectl config view

# Lister les contextes
kubectl config get-contexts

# Voir le contexte actuel
kubectl config current-context

# Changer de contexte
kubectl config use-context <nom_contexte>

# Définir le namespace par défaut
kubectl config set-context --current --namespace=<nom_namespace>
```

---

### Informations sur le cluster

```bash
# Informations générales
kubectl cluster-info

# Version du cluster
kubectl version

# Lister les nodes
kubectl get nodes
kubectl get nodes -o wide

# Détails d'un node
kubectl describe node <nom_node>

# Utilisation des ressources
kubectl top nodes        # Nécessite metrics-server
kubectl top pods
```

---

### Gestion des Namespaces

```bash
# Lister les namespaces
kubectl get namespaces
kubectl get ns

# Créer un namespace
kubectl create namespace <nom>
kubectl create ns dev

# Supprimer un namespace
kubectl delete namespace <nom>

# Tout faire dans un namespace spécifique
kubectl get pods -n <namespace>
kubectl get pods --all-namespaces
kubectl get pods -A  # Raccourci
```

---

### Gestion des Pods

```bash
# Lister les pods
kubectl get pods
kubectl get pods -o wide
kubectl get pods --watch
kubectl get pods -w

# Détails d'un pod
kubectl describe pod <nom_pod>

# Logs d'un pod
kubectl logs <nom_pod>
kubectl logs <nom_pod> -f              # Suivre les logs
kubectl logs <nom_pod> --tail=50       # 50 dernières lignes
kubectl logs <nom_pod> --since=10m     # 10 dernières minutes
kubectl logs <nom_pod> -c <conteneur>  # Logs d'un conteneur spécifique

# Exécuter une commande dans un pod
kubectl exec <nom_pod> -- <commande>
kubectl exec <nom_pod> -- ls /app
kubectl exec <nom_pod> -- env

# Shell interactif dans un pod
kubectl exec -it <nom_pod> -- /bin/bash
kubectl exec -it <nom_pod> -- sh

# Pour un conteneur spécifique (si plusieurs dans le pod)
kubectl exec -it <nom_pod> -c <conteneur> -- /bin/bash

# Copier des fichiers
kubectl cp <nom_pod>:<chemin_source> <destination_locale>
kubectl cp <source_locale> <nom_pod>:<chemin_destination>

# Exemples
kubectl cp monpod:/app/logs/app.log ./local.log
kubectl cp ./config.json monpod:/app/config/

# Port forwarding (accès local)
kubectl port-forward <nom_pod> <port_local>:<port_pod>
kubectl port-forward monpod 8080:80

# Supprimer un pod
kubectl delete pod <nom_pod>
kubectl delete pod <nom_pod> --grace-period=0 --force  # Forcer
```

---

### Gestion des Deployments

```bash
# Lister les deployments
kubectl get deployments
kubectl get deploy

# Détails d'un deployment
kubectl describe deployment <nom>

# Créer un deployment
kubectl create deployment <nom> --image=<image>
kubectl create deployment nginx --image=nginx:latest

# Mettre à jour l'image
kubectl set image deployment/<nom> <conteneur>=<nouvelle_image>
kubectl set image deployment/nginx nginx=nginx:1.21

# Scaler un deployment
kubectl scale deployment <nom> --replicas=<nombre>
kubectl scale deployment nginx --replicas=3

# Autoscaling
kubectl autoscale deployment <nom> --min=2 --max=10 --cpu-percent=80

# Rollout (mise à jour progressive)
kubectl rollout status deployment/<nom>
kubectl rollout history deployment/<nom>
kubectl rollout undo deployment/<nom>              # Annuler le dernier rollout
kubectl rollout undo deployment/<nom> --to-revision=2  # Revenir à une révision

# Mettre en pause/reprendre un rollout
kubectl rollout pause deployment/<nom>
kubectl rollout resume deployment/<nom>

# Redémarrer un deployment
kubectl rollout restart deployment/<nom>

# Supprimer un deployment
kubectl delete deployment <nom>
```

---

### Gestion des Services

```bash
# Lister les services
kubectl get services
kubectl get svc

# Détails d'un service
kubectl describe service <nom>

# Créer un service
kubectl expose deployment <nom> --port=80 --type=LoadBalancer

# Types de services
kubectl expose deployment nginx --port=80 --type=ClusterIP      # Interne
kubectl expose deployment nginx --port=80 --type=NodePort       # Externe via port node
kubectl expose deployment nginx --port=80 --type=LoadBalancer   # Load balancer cloud

# Supprimer un service
kubectl delete service <nom>
```

---

### Gestion des ConfigMaps

```bash
# Lister les ConfigMaps
kubectl get configmaps
kubectl get cm

# Créer depuis un fichier
kubectl create configmap <nom> --from-file=<fichier>

# Créer depuis des valeurs littérales
kubectl create configmap <nom> --from-literal=<clé>=<valeur>
kubectl create configmap app-config --from-literal=ENV=production --from-literal=DEBUG=false

# Voir le contenu
kubectl describe configmap <nom>
kubectl get configmap <nom> -o yaml

# Supprimer
kubectl delete configmap <nom>
```

---

### Gestion des Secrets

```bash
# Lister les secrets
kubectl get secrets

# Créer un secret générique
kubectl create secret generic <nom> --from-literal=<clé>=<valeur>
kubectl create secret generic db-secret --from-literal=password=SuperSecret123

# Créer depuis un fichier
kubectl create secret generic <nom> --from-file=<fichier>

# Secret pour Docker Registry
kubectl create secret docker-registry <nom> \
  --docker-server=<serveur> \
  --docker-username=<user> \
  --docker-password=<pass> \
  --docker-email=<email>

# Voir un secret (base64 encodé)
kubectl get secret <nom> -o yaml

# Décoder un secret
kubectl get secret <nom> -o jsonpath='{.data.password}' | base64 --decode

# Supprimer
kubectl delete secret <nom>
```

---

### Gestion avec YAML

```bash
# Appliquer une configuration
kubectl apply -f <fichier.yaml>
kubectl apply -f deployment.yaml
kubectl apply -f ./configs/      # Dossier entier

# Créer depuis YAML
kubectl create -f <fichier.yaml>

# Supprimer depuis YAML
kubectl delete -f <fichier.yaml>

# Voir la config générée d'une ressource
kubectl get deployment <nom> -o yaml
kubectl get pod <nom> -o json

# Éditer une ressource existante
kubectl edit deployment <nom>
kubectl edit pod <nom>

# Dry-run (tester sans créer)
kubectl apply -f deployment.yaml --dry-run=client
kubectl apply -f deployment.yaml --dry-run=server

# Valider un fichier YAML
kubectl apply -f deployment.yaml --validate=true --dry-run=client
```

---

### Commandes de dépannage

```bash
# Événements du cluster
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events -n <namespace>

# Ressources consommées
kubectl top nodes
kubectl top pods
kubectl top pod <nom_pod>

# Débug d'un pod qui ne démarre pas
kubectl describe pod <nom_pod>
kubectl logs <nom_pod>
kubectl logs <nom_pod> --previous  # Logs du conteneur précédent

# Lister toutes les ressources
kubectl get all
kubectl get all -A  # Tous les namespaces

# API resources disponibles
kubectl api-resources

# Vérifier la connectivité réseau
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
# Dans le pod :
# nslookup <service>
# wget -O- <service>:<port>
```

---

## 📦 Objets Kubernetes

### Pod

Le plus petit objet déployable dans Kubernetes.

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

```bash
kubectl apply -f pod.yaml
kubectl get pods
kubectl logs nginx-pod
kubectl delete pod nginx-pod
```

---

### Deployment

Gère les ReplicaSets et permet les mises à jour progressives.

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
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
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get rs  # ReplicaSets créés
kubectl get pods
kubectl scale deployment nginx-deployment --replicas=5
kubectl set image deployment/nginx-deployment nginx=nginx:1.22
kubectl rollout status deployment/nginx-deployment
```

---

### Service

Expose des pods via un point d'accès stable.

```yaml
# service.yaml

# ClusterIP (par défaut) - Accessible uniquement dans le cluster
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80

---
# NodePort - Accessible via IP du node + port
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080  # Port entre 30000-32767

---
# LoadBalancer - Crée un load balancer cloud
apiVersion: v1
kind: Service
metadata:
  name: nginx-loadbalancer
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
kubectl apply -f service.yaml
kubectl get svc
kubectl describe svc nginx-service

# Tester depuis le cluster
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
wget -O- nginx-service
```

---

### ConfigMap

Stocke des données de configuration non confidentielles.

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: "production"
  APP_DEBUG: "false"
  DATABASE_HOST: "db.example.com"
  config.json: |
    {
      "server": {
        "port": 8080,
        "host": "0.0.0.0"
      }
    }
```

**Utilisation dans un Pod :**

```yaml
# pod-with-configmap.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:latest
    # Méthode 1 : Variables d'environnement
    envFrom:
    - configMapRef:
        name: app-config
    
    # Méthode 2 : Variables spécifiques
    env:
    - name: APP_ENV
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_ENV
    
    # Méthode 3 : Monter comme fichier
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

---

### Secret

Stocke des données sensibles (encodées en base64).

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=          # admin en base64
  password: c3VwZXJzZWNyZXQ=  # supersecret en base64
```

```bash
# Créer un secret
echo -n 'admin' | base64
echo -n 'supersecret' | base64

kubectl apply -f secret.yaml

# Ou directement
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=supersecret
```

**Utilisation dans un Pod :**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:latest
    env:
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

---

### Ingress

Gère l'accès HTTP/HTTPS externe aux services.

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 3000
```

⚠️ **Nécessite un Ingress Controller** (nginx, traefik, etc.)

---

## 🚀 Déploiement d'Applications

### Exemple complet : Application Node.js

```yaml
# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-app
  labels:
    app: nodejs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nodejs
  template:
    metadata:
      labels:
        app: nodejs
    spec:
      containers:
      - name: nodejs
        image: <votre_dockerhub_user>/<nom_image>:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "3000"
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
  name: nodejs-service
spec:
  type: LoadBalancer
  selector:
    app: nodejs
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
```

```bash
# Déployer
kubectl apply -f app-deployment.yaml

# Vérifier
kubectl get deployments
kubectl get pods
kubectl get svc

# Obtenir l'URL externe (si LoadBalancer)
kubectl get svc nodejs-service

# Logs
kubectl logs -f deployment/nodejs-app

# Mettre à jour l'image
kubectl set image deployment/nodejs-app nodejs=<user>/<image>:v2

# Scaler
kubectl scale deployment nodejs-app --replicas=5
```

---

### Stratégies de déploiement

```yaml
# RollingUpdate (par défaut)
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Pods supplémentaires pendant update
      maxUnavailable: 0  # Pods indisponibles pendant update

---
# Recreate (stop all -> start all)
spec:
  strategy:
    type: Recreate
```

---

## 📊 Mise à l'Échelle

### Scaling manuel

```bash
# Scaler un deployment
kubectl scale deployment <nom> --replicas=5

# Scaler un ReplicaSet
kubectl scale rs <nom> --replicas=3

# Scaler un StatefulSet
kubectl scale statefulset <nom> --replicas=2
```

---

### Horizontal Pod Autoscaler (HPA)

```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nodejs-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nodejs-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

```bash
# Créer un HPA
kubectl apply -f hpa.yaml

# Ou via commande
kubectl autoscale deployment nodejs-app --min=2 --max=10 --cpu-percent=70

# Voir les HPA
kubectl get hpa
kubectl describe hpa nodejs-hpa

# Supprimer
kubectl delete hpa nodejs-hpa
```

⚠️ **Nécessite metrics-server installé**

---

## 📈 Monitoring & Logs

### Metrics Server

```bash
# Installer metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Vérifier
kubectl get deployment metrics-server -n kube-system

# Utiliser
kubectl top nodes
kubectl top pods
kubectl top pods --all-namespaces
kubectl top pod <nom_pod> --containers
```

---

### Logs

```bash
# Logs d'un pod
kubectl logs <nom_pod>
kubectl logs -f <nom_pod>                # Suivre
kubectl logs <nom_pod> --tail=100        # 100 dernières lignes
kubectl logs <nom_pod> --since=1h        # Dernière heure
kubectl logs <nom_pod> -c <conteneur>    # Conteneur spécifique
kubectl logs <nom_pod> --previous        # Conteneur précédent (après crash)

# Logs de tous les pods d'un deployment
kubectl logs -f deployment/<nom>

# Logs avec sélecteur
kubectl logs -l app=nginx
```

---

## ✅ Bonnes Pratiques

### 1. Ressources (requests & limits)

```yaml
resources:
  requests:      # Minimum garanti
    memory: "64Mi"
    cpu: "250m"
  limits:        # Maximum autorisé
    memory: "128Mi"
    cpu: "500m"
```

### 2. Health Checks

```yaml
livenessProbe:   # Redémarre si échoue
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:  # Retire du service si échoue
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### 3. Labels et Selectors

```yaml
metadata:
  labels:
    app: myapp
    version: v1.0
    environment: production
    tier: frontend
```

### 4. Namespaces

```bash
# Séparer les environnements
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace production
```

### 5. Resource Quotas

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "10"
    requests.memory: "20Gi"
    limits.cpu: "20"
    limits.memory: "40Gi"
    pods: "50"
```

---

## 🚨 Dépannage

### Pod ne démarre pas

```bash
# 1. Vérifier le status
kubectl get pods

# 2. Détails du pod
kubectl describe pod <nom_pod>

# 3. Logs
kubectl logs <nom_pod>

# 4. Événements
kubectl get events --sort-by='.lastTimestamp'

# Causes courantes :
# - ImagePullBackOff : Image introuvable
# - CrashLoopBackOff : Le conteneur crash au démarrage
# - Pending : Pas assez de ressources
# - Error : Erreur de configuration
```

### Service inaccessible

```bash
# 1. Vérifier le service
kubectl get svc <nom_service>
kubectl describe svc <nom_service>

# 2. Vérifier les endpoints
kubectl get endpoints <nom_service>

# 3. Vérifier les pods
kubectl get pods -l app=<label>

# 4. Tester depuis un pod de debug
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
wget -O- <nom_service>:<port>
```

### Problèmes de réseau

```bash
# Pod de debug réseau
kubectl run -it --rm debug --image=nicolaka/netshoot --restart=Never -- bash

# Dans le pod :
nslookup <service>
curl <service>:<port>
ping <service>
traceroute <service>
```

---

## 📚 Ressources Complémentaires

- [Documentation Kubernetes](https://kubernetes.io/docs/)
- [Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Patterns](https://k8spatterns.io/)
- [KubeAcademy](https://kube.academy/)

### Outils utiles
- **k9s** : Interface TUI pour Kubernetes
- **Lens** : IDE pour Kubernetes
- **Helm** : Gestionnaire de packages pour K8s
- **Kustomize** : Personnalisation de manifests YAML
- **Stern** : Multi-pod log tailing

---

**Pour aller plus loin :**
- [Guide EKS (AWS)](./eks.md) - Kubernetes managé sur AWS
- [Guide Minikube](./minikube.md) - Kubernetes local pour développement
