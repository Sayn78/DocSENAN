# ☸️ Kubernetes – Guide Complet

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Guides d'Installation](#-guides-dinstallation)
- [Architecture Kubernetes](#-architecture-kubernetes)
- [Concepts Fondamentaux](#-concepts-fondamentaux)
- [Installation kubectl](#-installation-kubectl)
- [Commandes kubectl essentielles](#-commandes-kubectl-essentielles)
- [Objets Kubernetes](#-objets-kubernetes)
- [Configuration & Manifests](#-configuration--manifests)
- [Networking](#-networking)
- [Storage](#-storage)
- [ConfigMaps & Secrets](#-configmaps--secrets)
- [Bonnes pratiques](#-bonnes-pratiques)
- [Ressources Complémentaires](#-ressources-complémentaires)

---

## 🚀 Guides d'Installation

Choisissez le guide correspondant à votre besoin :

| Guide | Description | Cas d'usage |
|-------|-------------|-------------|
| 📗 **[Minikube](./minikube.md)** | Kubernetes local sur une machine | Développement local, apprentissage, tests |
| 🐄 **[K3s](./k3s.md)** | Kubernetes léger et rapide | IoT, Edge, Raspberry Pi, serveurs légers |
| 📘 **[EKS](./eks.md)** | Kubernetes managé sur AWS | Production, cloud AWS, haute disponibilité |

### Comparaison rapide

| Critère | Minikube | K3s | EKS |
|---------|----------|-----|-----|
| **Environnement** | Local | Local/Serveur | AWS Cloud |
| **Complexité** | 🟢 Simple | 🟢 Simple | 🟡 Moyenne |
| **Coût** | Gratuit | Gratuit | ~$150/mois |
| **RAM minimale** | 2GB | 512MB | N/A (cloud) |
| **Production** | ❌ Non | ✅ Oui | ✅ Oui |
| **Installation** | 5 min | 1 min | 20 min |
| **Multi-node** | ⚠️ Limité | ✅ Oui | ✅ Oui |

---

## 🎯 Introduction

**Kubernetes (K8s)** est une plateforme open-source d'orchestration de conteneurs qui automatise le déploiement, la mise à l'échelle et la gestion des applications conteneurisées.

### Pourquoi Kubernetes ?
- ✅ **Scalabilité** : Mise à l'échelle automatique des applications
- ✅ **Haute disponibilité** : Redondance et self-healing
- ✅ **Portabilité** : Fonctionne sur n'importe quel cloud ou on-premise
- ✅ **Déploiement déclaratif** : État désiré vs état actuel
- ✅ **Service discovery** : DNS et load balancing intégrés
- ✅ **Rolling updates** : Déploiements sans downtime

### Cas d'usage
- Microservices
- Applications cloud-native
- CI/CD pipelines
- Applications stateful et stateless
- Machine Learning workloads

---

## 🏗️ Architecture Kubernetes

### Composants du Control Plane (Master)

```
┌─────────────────── Control Plane ───────────────────┐
│                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │
│  │  API Server  │  │  Scheduler   │  │Controller │ │
│  │   (kube-api) │  │(kube-scheduler│  │ Manager   │ │
│  └──────────────┘  └──────────────┘  └───────────┘ │
│                                                      │
│  ┌──────────────┐                                   │
│  │     etcd     │  (Base de données clé-valeur)     │
│  └──────────────┘                                   │
└──────────────────────────────────────────────────────┘

┌─────────────────── Worker Nodes ────────────────────┐
│                                                      │
│  Node 1              Node 2              Node 3     │
│  ┌────────┐         ┌────────┐         ┌────────┐  │
│  │ Kubelet│         │ Kubelet│         │ Kubelet│  │
│  ├────────┤         ├────────┤         ├────────┤  │
│  │  Pods  │         │  Pods  │         │  Pods  │  │
│  └────────┘         └────────┘         └────────┘  │
│  kube-proxy         kube-proxy         kube-proxy  │
└──────────────────────────────────────────────────────┘
```

#### Composants principaux

**Control Plane :**
- **API Server** : Point d'entrée pour toutes les requêtes REST
- **etcd** : Stockage clé-valeur distribué (état du cluster)
- **Scheduler** : Assigne les Pods aux Nodes
- **Controller Manager** : Gère les contrôleurs (ReplicaSet, Deployment, etc.)
- **Cloud Controller Manager** : Intégration avec les APIs cloud

**Worker Nodes :**
- **Kubelet** : Agent qui s'assure que les conteneurs tournent
- **Container Runtime** : Docker, containerd, CRI-O
- **kube-proxy** : Gère les règles réseau sur les nodes

---

## 🧩 Concepts Fondamentaux

### Hiérarchie des objets

```
Cluster
└── Namespace
    ├── Pod
    │   └── Container(s)
    ├── Service
    ├── Deployment
    │   └── ReplicaSet
    │       └── Pod(s)
    ├── ConfigMap
    ├── Secret
    └── Ingress
```

### Namespace
Isolation logique des ressources dans un cluster.

```yaml
# Namespaces par défaut
default           # Namespace par défaut
kube-system       # Objets créés par Kubernetes
kube-public       # Accessible à tous
kube-node-lease   # Heartbeats des nodes
```

### Pod
Plus petite unité déployable, contient un ou plusieurs conteneurs.

### Service
Point d'accès stable pour un ensemble de Pods.

### Deployment
Gestion déclarative des Pods et ReplicaSets.

### ConfigMap & Secret
Configuration et données sensibles.

### Ingress
Exposition HTTP/HTTPS des services.

---

## 📥 Installation kubectl

### Linux (Debian/Ubuntu)

```bash
# Méthode 1 : Via package manager (recommandée)
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl

# Ajouter la clé GPG de Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Ajouter le dépôt Kubernetes
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Installer kubectl
sudo apt update
sudo apt install -y kubectl

# Vérifier l'installation
kubectl version --client

# Méthode 2 : Binaire direct
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

### macOS

```bash
# Via Homebrew
brew install kubectl

# Vérifier
kubectl version --client
```

### Windows (PowerShell)

```powershell
# Via Chocolatey
choco install kubernetes-cli

# Ou téléchargement direct
curl.exe -LO "https://dl.k8s.io/release/v1.29.0/bin/windows/amd64/kubectl.exe"

# Vérifier
kubectl version --client
```

### Configuration de l'autocomplétion

```bash
# Bash
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source ~/.bashrc

# Zsh
echo 'source <(kubectl completion zsh)' >> ~/.zshrc
source ~/.zshrc

# Alias utile
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
```

---

## 🎮 Commandes kubectl Essentielles

### Configuration et contexte

```bash
# Voir la configuration actuelle
kubectl config view

# Lister les contextes (clusters)
kubectl config get-contexts

# Changer de contexte
kubectl config use-context <nom_contexte>

# Voir le contexte actuel
kubectl config current-context

# Créer un contexte
kubectl config set-context <nom> --cluster=<cluster> --user=<user> --namespace=<namespace>

# Définir le namespace par défaut
kubectl config set-context --current --namespace=<namespace>
```

---

### Gestion des Pods

```bash
# Lister les pods
kubectl get pods
kubectl get pods -n <namespace>
kubectl get pods --all-namespaces
kubectl get pods -o wide

# Détails d'un pod
kubectl describe pod <nom_pod>

# Créer un pod depuis une image
kubectl run <nom_pod> --image=<image>

# Exemple
kubectl run nginx --image=nginx:latest

# Supprimer un pod
kubectl delete pod <nom_pod>

# Logs d'un pod
kubectl logs <nom_pod>
kubectl logs -f <nom_pod>                    # Follow logs
kubectl logs <nom_pod> -c <nom_conteneur>    # Conteneur spécifique
kubectl logs --previous <nom_pod>            # Logs du conteneur précédent

# Exécuter une commande dans un pod
kubectl exec <nom_pod> -- <commande>
kubectl exec -it <nom_pod> -- bash
kubectl exec -it <nom_pod> -- sh

# Port forwarding
kubectl port-forward <nom_pod> 8080:80

# Copier des fichiers
kubectl cp <nom_pod>:/chemin/fichier ./fichier
kubectl cp ./fichier <nom_pod>:/chemin/
```

---

### Gestion des Deployments

```bash
# Créer un deployment
kubectl create deployment <nom> --image=<image>

# Exemple
kubectl create deployment nginx-deploy --image=nginx:latest

# Lister les deployments
kubectl get deployments
kubectl get deploy

# Détails
kubectl describe deployment <nom>

# Mettre à l'échelle
kubectl scale deployment <nom> --replicas=<nombre>
kubectl scale deployment nginx-deploy --replicas=5

# Autoscaling
kubectl autoscale deployment <nom> --min=2 --max=10 --cpu-percent=80

# Mettre à jour l'image
kubectl set image deployment/<nom> <conteneur>=<nouvelle_image>
kubectl set image deployment/nginx-deploy nginx=nginx:1.25

# Voir l'historique des rollouts
kubectl rollout history deployment/<nom>

# Rollback
kubectl rollout undo deployment/<nom>
kubectl rollout undo deployment/<nom> --to-revision=2

# Statut du rollout
kubectl rollout status deployment/<nom>

# Supprimer
kubectl delete deployment <nom>
```

---

### Gestion des Services

```bash
# Créer un service
kubectl expose deployment <nom> --port=80 --type=LoadBalancer

# Lister les services
kubectl get services
kubectl get svc

# Détails
kubectl describe service <nom>

# Supprimer
kubectl delete service <nom>
```

---

### Gestion des Namespaces

```bash
# Lister les namespaces
kubectl get namespaces
kubectl get ns

# Créer un namespace
kubectl create namespace <nom>

# Supprimer un namespace
kubectl delete namespace <nom>

# Travailler dans un namespace spécifique
kubectl get pods -n <namespace>
kubectl apply -f file.yaml -n <namespace>
```

---

### Appliquer des manifests YAML

```bash
# Appliquer un fichier
kubectl apply -f <fichier.yaml>

# Appliquer un dossier
kubectl apply -f <dossier>/

# Appliquer depuis une URL
kubectl apply -f https://example.com/manifest.yaml

# Supprimer depuis un fichier
kubectl delete -f <fichier.yaml>

# Dry-run (tester sans appliquer)
kubectl apply -f <fichier.yaml> --dry-run=client
kubectl apply -f <fichier.yaml> --dry-run=server

# Voir les différences avant d'appliquer
kubectl diff -f <fichier.yaml>
```

---

### Informations sur le cluster

```bash
# Informations du cluster
kubectl cluster-info

# Voir les nodes
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <nom_node>

# Ressources disponibles
kubectl top nodes
kubectl top pods

# Événements du cluster
kubectl get events
kubectl get events --sort-by='.lastTimestamp'

# API resources
kubectl api-resources
kubectl api-versions
```

---

### Debug et troubleshooting

```bash
# Voir les logs d'événements
kubectl get events --sort-by='.metadata.creationTimestamp'

# Déboguer un pod qui crash
kubectl describe pod <nom_pod>
kubectl logs <nom_pod> --previous

# Créer un pod temporaire pour debug
kubectl run debug --image=busybox --rm -it --restart=Never -- sh

# Tester la connectivité réseau
kubectl run netshoot --image=nicolaka/netshoot --rm -it --restart=Never -- bash

# Vérifier les permissions
kubectl auth can-i create pods
kubectl auth can-i create pods --as=<user>
```

---

## 📦 Objets Kubernetes

### Pod

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
    image: nginx:latest
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
kubectl describe pod nginx-pod
```

---

### Deployment

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
        image: nginx:1.25
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
kubectl get pods
kubectl scale deployment nginx-deployment --replicas=5
```

---

### Service

#### ClusterIP (par défaut)
```yaml
# service-clusterip.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-internal
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

#### NodePort
```yaml
# service-nodeport.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080  # Port entre 30000-32767
```

#### LoadBalancer
```yaml
# service-loadbalancer.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-lb
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
kubectl apply -f service-loadbalancer.yaml
kubectl get services
kubectl describe service nginx-service-lb

# Obtenir l'URL externe (LoadBalancer)
kubectl get service nginx-service-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

---

### ReplicaSet

```yaml
# replicaset.yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
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
        image: nginx:latest
        ports:
        - containerPort: 80
```

**Note :** En pratique, utilisez plutôt des Deployments qui gèrent automatiquement les ReplicaSets.

---

### StatefulSet

Pour les applications stateful (bases de données, etc.)

```yaml
# statefulset.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: "postgres"
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: password
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 10Gi
```

---

### DaemonSet

Un pod par node (monitoring, logs, etc.)

```yaml
# daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
spec:
  selector:
    matchLabels:
      name: fluentd
  template:
    metadata:
      labels:
        name: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:latest
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

---

### Job

Tâche ponctuelle

```yaml
# job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: backup-job
spec:
  template:
    spec:
      containers:
      - name: backup
        image: backup-tool:latest
        command: ["./backup.sh"]
      restartPolicy: OnFailure
  backoffLimit: 4
```

---

### CronJob

Tâche planifiée

```yaml
# cronjob.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup-cronjob
spec:
  schedule: "0 2 * * *"  # Tous les jours à 2h
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: backup-tool:latest
            command: ["./backup.sh"]
          restartPolicy: OnFailure
```

---

## 🌐 Networking

### Ingress

Routage HTTP/HTTPS avancé

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
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
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
  tls:
  - hosts:
    - myapp.example.com
    secretName: tls-secret
```

### NetworkPolicy

Contrôle du trafic réseau

```yaml
# networkpolicy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-specific
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
```

---

## 💾 Storage

### PersistentVolume (PV)

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: standard
  hostPath:
    path: /mnt/data
```

### PersistentVolumeClaim (PVC)

```yaml
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: standard
```

### Utilisation dans un Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-storage
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: /data
      name: storage
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: pvc-data
```

---

## 🔐 ConfigMaps & Secrets

### ConfigMap

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: "production"
  APP_DEBUG: "false"
  DATABASE_URL: "postgresql://db:5432/myapp"
  config.json: |
    {
      "server": {
        "port": 8080,
        "host": "0.0.0.0"
      }
    }
```

```bash
# Créer depuis un fichier
kubectl create configmap app-config --from-file=config.properties

# Créer depuis des littéraux
kubectl create configmap app-config --from-literal=ENV=prod --from-literal=DEBUG=false
```

### Utilisation dans un Pod

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
    - name: APP_ENV
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_ENV
    volumeMounts:
    - name: config
      mountPath: /etc/config
  volumes:
  - name: config
    configMap:
      name: app-config
```

---

### Secret

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  username: YWRtaW4=          # base64: admin
  password: cGFzc3dvcmQxMjM=  # base64: password123
```

```bash
# Créer un secret
kubectl create secret generic app-secret \
  --from-literal=username=admin \
  --from-literal=password=password123

# Depuis un fichier
kubectl create secret generic app-secret --from-file=./secret.txt

# TLS secret
kubectl create secret tls tls-secret \
  --cert=path/to/tls.cert \
  --key=path/to/tls.key
```

### Utilisation dans un Pod

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
          name: app-secret
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: app-secret
          key: password
```

---

## ✅ Bonnes Pratiques

### Organisation des fichiers

```
kubernetes/
├── base/                    # Manifests communs
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
├── overlays/               # Configurations spécifiques
│   ├── dev/
│   │   ├── kustomization.yaml
│   │   └── patches/
│   ├── staging/
│   └── production/
└── scripts/
    ├── deploy.sh
    └── rollback.sh
```

### Labels et Annotations

```yaml
metadata:
  labels:
    app: myapp
    version: v1.0.0
    environment: production
    component: backend
    managed-by: kubectl
  annotations:
    description: "Application backend"
    contact: "team@example.com"
    deployment-date: "2025-01-29"
```

### Resource Limits

```yaml
resources:
  requests:    # Ressources minimales
    memory: "64Mi"
    cpu: "250m"
  limits:      # Ressources maximales
    memory: "128Mi"
    cpu: "500m"
```

### Health Checks

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### Sécurité

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 2000
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
```

---

## 🐄 K3s - Kubernetes Léger

### Qu'est-ce que K3s ?

**K3s** est une distribution Kubernetes légère et certifiée, conçue pour :
- 🎯 IoT et Edge Computing
- 💻 Environnements de développement local
- 🚀 Déploiements rapides
- 📦 Faible empreinte mémoire (~512MB)
- ⚡ Installation en une seule commande

### Installation de K3s

#### Installation Server (Master)

```bash
# Installation standard
curl -sfL https://get.k3s.io | sh -

# Vérifier l'installation
sudo systemctl status k3s

# Récupérer le token pour les agents
sudo cat /var/lib/rancher/k3s/server/node-token

# Configuration kubectl
sudo cat /etc/rancher/k3s/k3s.yaml
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

# Vérifier
kubectl get nodes
```

#### Installation avec options

```bash
# Sans Traefik (ingress controller)
curl -sfL https://get.k3s.io | sh -s - --disable traefik

# Sans ServiceLB
curl -sfL https://get.k3s.io | sh -s - --disable servicelb

# Avec un port API personnalisé
curl -sfL https://get.k3s.io | sh -s - --https-listen-port 6443

# Installation complète personnalisée
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --disable traefik \
  --disable servicelb \
  --write-kubeconfig-mode 644" sh -
```

#### Installation Agent (Worker)

```bash
# Sur un autre serveur
curl -sfL https://get.k3s.io | K3S_URL=https://<IP_MASTER>:6443 \
  K3S_TOKEN=<TOKEN_FROM_MASTER> sh -

# Vérifier sur le master
kubectl get nodes
```

### Gestion de K3s

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

# Logs
sudo journalctl -u k3s -f

# Désinstaller K3s server
/usr/local/bin/k3s-uninstall.sh

# Désinstaller K3s agent
/usr/local/bin/k3s-agent-uninstall.sh
```

---

## 🐳 Gestion des Images Docker avec K3s

### Importer des images Docker dans K3s

K3s utilise **containerd** au lieu de Docker, voici comment gérer les images :

#### Méthode 1 : Sauvegarder et Importer

```bash
# 1. Créer une image Docker (sur votre machine de dev)
docker build -t my-aspnetapp:latest .

# 2. Sauvegarder l'image en tar
docker save my-aspnetapp:latest > my-aspnetapp.tar

# Ou avec compression
docker save my-aspnetapp:latest | gzip > my-aspnetapp.tar.gz

# 3. Transférer sur le serveur K3s
scp my-aspnetapp.tar user@k3s-server:/tmp/

# 4. Importer l'image dans K3s
sudo k3s ctr images import /tmp/my-aspnetapp.tar

# Ou si compressé
gunzip < my-aspnetapp.tar.gz | sudo k3s ctr images import -

# 5. Vérifier l'import
sudo k3s ctr images list | grep my-aspnetapp

# 6. Utiliser l'image dans un pod
kubectl run my-app --image=my-aspnetapp:latest --image-pull-policy=Never
```

#### Méthode 2 : Registry Privé Local

```bash
# 1. Créer un registry local
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# 2. Tagger l'image
docker tag my-aspnetapp:latest localhost:5000/my-aspnetapp:latest

# 3. Pousser vers le registry
docker push localhost:5000/my-aspnetapp:latest

# 4. Sur K3s, utiliser l'image
kubectl run my-app --image=localhost:5000/my-aspnetapp:latest
```

#### Méthode 3 : Docker Hub

```bash
# 1. Se connecter à Docker Hub
docker login

# 2. Tagger l'image
docker tag my-aspnetapp:latest <votre_user>/my-aspnetapp:latest

# 3. Pousser l'image
docker push <votre_user>/my-aspnetapp:latest

# 4. Utiliser dans K3s
kubectl run my-app --image=<votre_user>/my-aspnetapp:latest
```

### Commandes K3s pour les Images

```bash
# Lister toutes les images
sudo k3s ctr images list
sudo k3s ctr images ls

# Rechercher une image spécifique
sudo k3s ctr images list | grep <nom_image>

# Supprimer une image
sudo k3s ctr images remove <nom_image>

# Exemple
sudo k3s ctr images remove docker.io/library/my-aspnetapp:latest

# Pull une image
sudo k3s ctr images pull docker.io/library/nginx:latest

# Tag une image
sudo k3s ctr images tag <source> <target>

# Informations sur une image
sudo k3s ctr images check
```

### Configuration ImagePullPolicy

```yaml
# Toujours pull depuis le registry
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: app
    image: my-aspnetapp:latest
    imagePullPolicy: Always  # Always, IfNotPresent, Never

---
# Utiliser l'image locale (importée)
apiVersion: v1
kind: Pod
metadata:
  name: my-app-local
spec:
  containers:
  - name: app
    image: my-aspnetapp:latest
    imagePullPolicy: Never  # N'essaie pas de pull, utilise l'image locale
```

---

## 🌐 Gestion des Volumes Persistants (PV/PVC)

### Création de Volumes avec YAML

#### PersistentVolume (PV)

```yaml
# pv-hostpath.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/mnt/data"
    type: DirectoryOrCreate

---
# pv-nfs.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nfs
spec:
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: nfs
  nfs:
    server: 192.168.1.100
    path: "/exports/data"

---
# pv-aws-ebs.yaml (pour EKS)
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-aws-ebs
spec:
  capacity:
    storage: 100Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: gp3
  awsElasticBlockStore:
    volumeID: vol-0123456789abcdef0
    fsType: ext4
```

#### PersistentVolumeClaim (PVC)

```yaml
# pvc-data.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  selector:
    matchLabels:
      type: local

---
# pvc-database.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-postgres
  namespace: database
spec:
  storageClassName: fast-ssd
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```

### Utilisation dans un Deployment

```yaml
# deployment-with-volume.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-storage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: nginx:latest
        volumeMounts:
        - name: data
          mountPath: /usr/share/nginx/html
        - name: logs
          mountPath: /var/log/nginx
        - name: config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
      volumes:
      # Volume persistant
      - name: data
        persistentVolumeClaim:
          claimName: pvc-data
      # EmptyDir (temporaire)
      - name: logs
        emptyDir: {}
      # ConfigMap
      - name: config
        configMap:
          name: nginx-config
```

### Types de Volumes

```yaml
# hostPath (développement uniquement)
volumes:
- name: host-volume
  hostPath:
    path: /data
    type: DirectoryOrCreate

# emptyDir (temporaire, effacé si pod supprimé)
volumes:
- name: cache
  emptyDir: {}

# emptyDir en mémoire
volumes:
- name: memory-cache
  emptyDir:
    medium: Memory
    sizeLimit: 1Gi

# ConfigMap
volumes:
- name: config
  configMap:
    name: app-config
    items:
    - key: config.json
      path: config.json

# Secret
volumes:
- name: secret
  secret:
    secretName: app-secret
    defaultMode: 0400

# NFS
volumes:
- name: nfs
  nfs:
    server: nfs-server.example.com
    path: "/exports"

# Git Repository
volumes:
- name: git-repo
  gitRepo:
    repository: "https://github.com/user/repo.git"
    revision: "main"
```

### StorageClass

```yaml
# storageclass-fast.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
  iops: "3000"
  throughput: "125"
  encrypted: "true"
allowVolumeExpansion: true
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer

---
# storageclass-nfs.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-storage
provisioner: nfs.csi.k8s.io
parameters:
  server: nfs-server.example.com
  share: /exports/data
reclaimPolicy: Retain
volumeBindingMode: Immediate
```

### Commandes pour les Volumes

```bash
# Lister les PV
kubectl get pv
kubectl get persistentvolumes

# Lister les PVC
kubectl get pvc
kubectl get persistentvolumeclaims

# Détails
kubectl describe pv <nom>
kubectl describe pvc <nom>

# Créer depuis YAML
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml

# Supprimer
kubectl delete pvc <nom>
kubectl delete pv <nom>

# Voir l'utilisation
kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,VOLUME:.spec.volumeName,CAPACITY:.status.capacity.storage

# Étendre un volume (si allowVolumeExpansion: true)
kubectl edit pvc <nom>
# Modifier spec.resources.requests.storage
```

---

## 🔧 Configuration Avancée des Volumes

### StatefulSet avec PVC Templates

```yaml
# statefulset-postgres.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: password
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  # Automatic PVC creation
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: fast-ssd
      resources:
        requests:
          storage: 10Gi
```

### Backup et Restore de Volumes

```yaml
# job-backup.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: backup-data
spec:
  template:
    spec:
      containers:
      - name: backup
        image: busybox
        command:
        - sh
        - -c
        - |
          tar czf /backup/data-$(date +%Y%m%d-%H%M%S).tar.gz -C /data .
        volumeMounts:
        - name: data
          mountPath: /data
          readOnly: true
        - name: backup
          mountPath: /backup
      restartPolicy: OnFailure
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: pvc-data
      - name: backup
        hostPath:
          path: /backups
          type: DirectoryOrCreate
```

---

## 🔗 Guides Spécifiques

Pour des guides détaillés sur des implémentations spécifiques de Kubernetes :

### 📘 [EKS - Amazon Elastic Kubernetes Service](./eks.md)
Guide complet pour déployer Kubernetes sur AWS avec Terraform

### 📗 [Minikube - Kubernetes Local](./minikube.md)
Guide pour installer et utiliser Kubernetes en local pour le développement

### 🐄 [K3s - Kubernetes Léger](./k3s.md)
Guide détaillé pour K3s, parfait pour IoT, Edge et environnements de développement

---

## 📚 Ressources Complémentaires

- [Documentation officielle Kubernetes](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Patterns](https://k8spatterns.io/)
- [Awesome Kubernetes](https://github.com/ramitsurana/awesome-kubernetes)
- [K3s Documentation](https://docs.k3s.io/)
- [Rancher Documentation](https://rancher.com/docs/)
