# ⎈ Helm - Package Manager pour Kubernetes

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Installation](#-installation)
- [Concepts Fondamentaux](#-concepts-fondamentaux)
- [Commandes Essentielles](#-commandes-essentielles)
- [Repositories](#-repositories)
- [Créer un Chart](#-créer-un-chart)
- [Templating](#-templating)
- [Values et Configuration](#-values-et-configuration)
- [Hooks](#-hooks)
- [Helm avec Minikube](#-helm-avec-minikube)
- [Helm avec K3s](#-helm-avec-k3s)
- [Helm avec EKS](#-helm-avec-eks)
- [Bonnes Pratiques](#-bonnes-pratiques)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**Helm** est le gestionnaire de paquets (package manager) pour Kubernetes, souvent appelé "le apt/yum/homebrew de Kubernetes".

### Qu'est-ce que Helm ?

Helm permet de :
- ✅ **Packager** des applications Kubernetes
- ✅ **Déployer** des applications complexes en une commande
- ✅ **Versionner** les déploiements
- ✅ **Partager** des configurations réutilisables
- ✅ **Rollback** facilement en cas de problème
- ✅ **Gérer** les dépendances entre applications

### Pourquoi utiliser Helm ?

**Sans Helm :**
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f pvc.yaml
# ... 20 fichiers plus tard
```

**Avec Helm :**
```bash
helm install mon-app ./mon-chart
```

### Cas d'usage

- 📦 **Déployer des applications** complexes (bases de données, monitoring, etc.)
- 🔄 **Gérer plusieurs environnements** (dev, staging, prod)
- 🎯 **Standardiser** les déploiements dans l'équipe
- 📚 **Réutiliser** des configurations
- 🚀 **CI/CD** automatisés
- 📊 **Marketplace** d'applications (Artifact Hub)

---

## 📥 Installation

### Linux

```bash
# Méthode 1 : Script officiel (Recommandée)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Méthode 2 : Binaire direct
curl -LO https://get.helm.sh/helm-v3.13.3-linux-amd64.tar.gz
tar -zxvf helm-v3.13.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-v3.13.3-linux-amd64.tar.gz

# Méthode 3 : Package manager
# Debian/Ubuntu
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# Arch Linux
sudo pacman -S helm

# Fedora
sudo dnf install helm

# Vérifier
helm version
```

---

### macOS

```bash
# Via Homebrew (Recommandé)
brew install helm

# Ou binaire direct
curl -LO https://get.helm.sh/helm-v3.13.3-darwin-amd64.tar.gz
tar -zxvf helm-v3.13.3-darwin-amd64.tar.gz
sudo mv darwin-amd64/helm /usr/local/bin/helm
rm -rf darwin-amd64 helm-v3.13.3-darwin-amd64.tar.gz

# Vérifier
helm version
```

---

### Windows

```powershell
# Via Chocolatey
choco install kubernetes-helm

# Via Scoop
scoop install helm

# Via Winget
winget install Helm.Helm

# Vérifier
helm version
```

---

### Configuration de l'autocomplétion

```bash
# Bash
echo 'source <(helm completion bash)' >> ~/.bashrc
source ~/.bashrc

# Zsh
echo 'source <(helm completion zsh)' >> ~/.zshrc
source ~/.zshrc

# Fish
helm completion fish | source

# PowerShell
helm completion powershell | Out-String | Invoke-Expression
```

---

### Vérifier l'installation

```bash
# Version de Helm
helm version

# Aide
helm help

# Lister les commandes
helm list

# Configuration
helm env
```

---

## 🧩 Concepts Fondamentaux

### Architecture Helm

```
┌─────────────────────────────────────────┐
│           Helm Client (CLI)             │
│  • Gestion des Charts                   │
│  • Communication avec Kubernetes        │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│       Kubernetes API Server             │
│  • Stockage des releases (Secrets)      │
│  • Déploiement des ressources           │
└─────────────────────────────────────────┘
```

**Note :** Helm 3 n'utilise plus Tiller (composant serveur de Helm 2).

---

### Terminologie

#### Chart
Un **Chart** est un package Helm contenant :
- Templates YAML de ressources Kubernetes
- Fichier `Chart.yaml` (métadonnées)
- Fichier `values.yaml` (configuration par défaut)
- Fichiers helpers et documentation

```
mon-chart/
├── Chart.yaml          # Métadonnées du chart
├── values.yaml         # Valeurs par défaut
├── charts/             # Charts dépendants
├── templates/          # Templates Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── _helpers.tpl    # Helpers de templating
└── README.md
```

#### Release
Une **Release** est une instance d'un Chart déployée dans Kubernetes.

```bash
# Un même chart peut avoir plusieurs releases
helm install blog-prod ./wordpress
helm install blog-staging ./wordpress
helm install blog-dev ./wordpress
```

#### Repository
Un **Repository** est un serveur hébergeant des Charts.

```bash
# Exemples de repositories
https://charts.bitnami.com/bitnami
https://kubernetes.github.io/ingress-nginx
https://prometheus-community.github.io/helm-charts
```

#### Values
Les **Values** sont les variables de configuration d'un Chart.

```yaml
# values.yaml
replicaCount: 3
image:
  repository: nginx
  tag: "1.25"
service:
  type: LoadBalancer
  port: 80
```

---

## 🎮 Commandes Essentielles

### Recherche et Information

```bash
# Rechercher un chart sur Artifact Hub
helm search hub <mot-clé>
helm search hub wordpress
helm search hub prometheus

# Rechercher dans les repos ajoutés
helm search repo <mot-clé>
helm search repo nginx
helm search repo mysql

# Voir toutes les versions d'un chart
helm search repo nginx --versions

# Informations sur un chart
helm show chart bitnami/nginx
helm show values bitnami/nginx
helm show readme bitnami/nginx
helm show all bitnami/nginx
```

---

### Installation et Gestion

```bash
# Installer un chart
helm install <nom-release> <chart>

# Exemples
helm install my-nginx bitnami/nginx
helm install my-db bitnami/postgresql
helm install monitoring prometheus-community/kube-prometheus-stack

# Installer avec un namespace
helm install my-app bitnami/nginx --namespace production --create-namespace

# Installer avec des valeurs personnalisées
helm install my-app bitnami/nginx --set replicaCount=3
helm install my-app bitnami/nginx --values custom-values.yaml
helm install my-app bitnami/nginx -f values-prod.yaml

# Installer depuis un fichier local
helm install my-app ./mon-chart

# Installer depuis une archive
helm install my-app mon-chart-1.0.0.tgz

# Dry-run (tester sans installer)
helm install my-app bitnami/nginx --dry-run --debug
```

---

### Lister et Inspecter

```bash
# Lister les releases
helm list
helm ls

# Lister dans tous les namespaces
helm list --all-namespaces
helm list -A

# Lister dans un namespace spécifique
helm list -n production

# Lister toutes les releases (même celles échouées)
helm list --all

# Voir le statut d'une release
helm status <nom-release>

# Voir l'historique des révisions
helm history <nom-release>

# Voir les valeurs utilisées
helm get values <nom-release>

# Voir les manifests déployés
helm get manifest <nom-release>

# Voir toutes les infos
helm get all <nom-release>
```

---

### Mise à Jour

```bash
# Mettre à jour une release
helm upgrade <nom-release> <chart>

# Exemples
helm upgrade my-nginx bitnami/nginx
helm upgrade my-nginx bitnami/nginx --set replicaCount=5
helm upgrade my-nginx bitnami/nginx -f values-prod.yaml

# Upgrade avec installation si n'existe pas
helm upgrade --install my-app bitnami/nginx

# Force le remplacement
helm upgrade my-app bitnami/nginx --force

# Réutiliser les valeurs précédentes
helm upgrade my-app bitnami/nginx --reuse-values

# Voir les changements avant d'appliquer
helm upgrade my-app bitnami/nginx --dry-run --debug
```

---

### Rollback

```bash
# Rollback à la version précédente
helm rollback <nom-release>

# Rollback à une version spécifique
helm rollback <nom-release> <revision>

# Exemples
helm rollback my-nginx 1
helm rollback my-nginx 3

# Dry-run du rollback
helm rollback my-nginx 2 --dry-run
```

---

### Désinstallation

```bash
# Désinstaller une release
helm uninstall <nom-release>

# Exemples
helm uninstall my-nginx
helm uninstall my-app -n production

# Garder l'historique (pour rollback ultérieur)
helm uninstall my-nginx --keep-history

# Supprimer avec un timeout
helm uninstall my-nginx --timeout 5m
```

---

## 📚 Repositories

### Gestion des Repositories

```bash
# Ajouter un repository
helm repo add <nom> <url>

# Repositories populaires
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add jetstack https://charts.jetstack.io
helm repo add elastic https://helm.elastic.co

# Lister les repositories
helm repo list

# Mettre à jour les repositories
helm repo update

# Supprimer un repository
helm repo remove <nom>

# Chercher dans un repository
helm search repo <nom-repo>/<chart>
```

---

### Repositories Populaires

```bash
# Bitnami - Applications populaires
helm repo add bitnami https://charts.bitnami.com/bitnami
# Charts: WordPress, MySQL, PostgreSQL, Redis, MongoDB, Nginx, Apache

# Ingress NGINX
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# Charts: ingress-nginx

# Prometheus & Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
# Charts: kube-prometheus-stack, prometheus, alertmanager, grafana

# Cert-Manager (Let's Encrypt)
helm repo add jetstack https://charts.jetstack.io
# Charts: cert-manager

# Elastic Stack
helm repo add elastic https://helm.elastic.co
# Charts: elasticsearch, kibana, filebeat, metricbeat

# HashiCorp
helm repo add hashicorp https://helm.releases.hashicorp.com
# Charts: vault, consul

# GitLab
helm repo add gitlab https://charts.gitlab.io
# Charts: gitlab, gitlab-runner

# Mettre à jour après ajout
helm repo update
```

---

### Artifact Hub

[Artifact Hub](https://artifacthub.io/) est le registre central des Charts Helm.

```bash
# Rechercher sur Artifact Hub
helm search hub wordpress
helm search hub nginx
helm search hub postgresql

# Voir les détails
# Ouvrir https://artifacthub.io/
```

---

## 🔨 Créer un Chart

### Créer un Chart depuis zéro

```bash
# Créer la structure d'un chart
helm create mon-app

# Structure générée
mon-app/
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests/
│       └── test-connection.yaml
└── .helmignore
```

---

### Fichier Chart.yaml

```yaml
# Chart.yaml
apiVersion: v2
name: mon-app
description: Une application Node.js
type: application
version: 1.0.0        # Version du chart
appVersion: "2.5.0"   # Version de l'application

keywords:
  - nodejs
  - web
  - api

home: https://github.com/user/mon-app
sources:
  - https://github.com/user/mon-app

maintainers:
  - name: Votre Nom
    email: votre@email.com
    url: https://votresite.com

icon: https://example.com/icon.png

dependencies:
  - name: postgresql
    version: "12.x.x"
    repository: https://charts.bitnami.com/bitnami
    condition: postgresql.enabled
  - name: redis
    version: "17.x.x"
    repository: https://charts.bitnami.com/bitnami
    condition: redis.enabled
```

---

### Fichier values.yaml

```yaml
# values.yaml - Configuration par défaut

# Nombre de réplicas
replicaCount: 3

# Configuration de l'image
image:
  repository: myapp/nodejs-app
  pullPolicy: IfNotPresent
  tag: "2.5.0"

# Pull secrets pour registries privés
imagePullSecrets: []

# Nom personnalisé
nameOverride: ""
fullnameOverride: ""

# Service Account
serviceAccount:
  create: true
  annotations: {}
  name: ""

# Annotations des pods
podAnnotations: {}

# Labels des pods
podLabels: {}

# Security Context
podSecurityContext:
  fsGroup: 2000

securityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000

# Service
service:
  type: ClusterIP
  port: 80
  targetPort: 3000

# Ingress
ingress:
  enabled: false
  className: "nginx"
  annotations: {}
    # cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
  tls: []
    # - secretName: app-tls
    #   hosts:
    #     - app.example.com

# Ressources
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

# Autoscaling
autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80

# Volumes
volumes: []
volumeMounts: []

# Node selector
nodeSelector: {}

# Tolerations
tolerations: []

# Affinity
affinity: {}

# Variables d'environnement
env:
  - name: NODE_ENV
    value: "production"
  - name: PORT
    value: "3000"

# ConfigMaps
configMaps: {}

# Secrets
secrets: {}

# Health checks
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

# Dépendances
postgresql:
  enabled: true
  auth:
    username: myapp
    password: changeme
    database: myapp_db

redis:
  enabled: true
  auth:
    enabled: false
```

---

### Template Deployment

```yaml
# templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mon-app.fullname" . }}
  labels:
    {{- include "mon-app.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "mon-app.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
      {{- with .Values.podAnnotations }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "mon-app.labels" . | nindent 8 }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      serviceAccountName: {{ include "mon-app.serviceAccountName" . }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.securityContext | nindent 12 }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: {{ .Values.service.targetPort }}
          protocol: TCP
        env:
        {{- range .Values.env }}
        - name: {{ .name }}
          value: {{ .value | quote }}
        {{- end }}
        livenessProbe:
          {{- toYaml .Values.livenessProbe | nindent 12 }}
        readinessProbe:
          {{- toYaml .Values.readinessProbe | nindent 12 }}
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
        {{- with .Values.volumeMounts }}
        volumeMounts:
          {{- toYaml . | nindent 12 }}
        {{- end }}
      {{- with .Values.volumes }}
      volumes:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
```

---

### Helpers (_helpers.tpl)

```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "mon-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mon-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mon-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mon-app.labels" -}}
helm.sh/chart: {{ include "mon-app.chart" . }}
{{ include "mon-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mon-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mon-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mon-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mon-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
```

---

## 📝 Templating

### Fonctions de Base

```yaml
# Valeurs
{{ .Values.replicaCount }}
{{ .Values.image.repository }}
{{ .Values.image.tag }}

# Release
{{ .Release.Name }}
{{ .Release.Namespace }}
{{ .Release.Service }}

# Chart
{{ .Chart.Name }}
{{ .Chart.Version }}
{{ .Chart.AppVersion }}

# Kubernetes
{{ .Capabilities.KubeVersion }}

# Fichiers
{{ .Files.Get "config.txt" }}
{{ .Template.BasePath }}
```

---

### Fonctions de Transformation

```yaml
# Quotes
value: {{ .Values.env | quote }}

# Upper/Lower
name: {{ .Values.name | upper }}
name: {{ .Values.name | lower }}

# Default
replicas: {{ .Values.replicaCount | default 3 }}

# ToString
port: {{ .Values.port | toString }}

# Truncate
name: {{ .Values.name | trunc 63 | trimSuffix "-" }}

# Replace
image: {{ .Values.image.name | replace ":" "-" }}

# Indent / nindent
labels:
  {{- toYaml .Values.labels | nindent 4 }}
```

---

### Conditions

```yaml
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
# ...
{{- end }}

{{- if and .Values.postgresql.enabled .Values.redis.enabled }}
# Les deux activés
{{- end }}

{{- if or .Values.service.type "ClusterIP" }}
# Service type est ClusterIP ou non défini
{{- end }}

{{- if not .Values.autoscaling.enabled }}
replicas: {{ .Values.replicaCount }}
{{- end }}
```

---

### Boucles

```yaml
# Range sur une liste
{{- range .Values.env }}
- name: {{ .name }}
  value: {{ .value | quote }}
{{- end }}

# Range sur un dictionnaire
{{- range $key, $value := .Values.annotations }}
{{ $key }}: {{ $value | quote }}
{{- end }}

# Range avec index
{{- range $index, $item := .Values.items }}
- index: {{ $index }}
  value: {{ $item }}
{{- end }}
```

---

### With (Scope)

```yaml
{{- with .Values.ingress }}
  {{- if .enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .name }}
  annotations:
    {{- toYaml .annotations | nindent 4 }}
  {{- end }}
{{- end }}
```

---

## ⚙️ Values et Configuration

### Hiérarchie des Values

```bash
# 1. values.yaml du chart (défauts)
# 2. values.yaml des charts parents
# 3. Fichier -f custom-values.yaml
# 4. Valeurs --set sur la ligne de commande

# Exemple de priorité
helm install my-app ./chart \
  -f values-prod.yaml \          # Priorité 3
  --set replicaCount=5 \          # Priorité 4 (override tout)
  --set image.tag=v2.0.0
```

---

### Fichiers de Values par Environnement

```bash
# Structure
mon-chart/
├── values.yaml              # Défauts
├── values-dev.yaml          # Dev
├── values-staging.yaml      # Staging
└── values-production.yaml   # Production
```

```yaml
# values-dev.yaml
replicaCount: 1
image:
  tag: "latest"
  pullPolicy: Always
ingress:
  enabled: false
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```

```yaml
# values-production.yaml
replicaCount: 5
image:
  tag: "2.5.0"
  pullPolicy: IfNotPresent
ingress:
  enabled: true
  hosts:
    - host: app.production.com
resources:
  requests:
    cpu: 500m
    memory: 512Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

```bash
# Déployer en dev
helm install my-app ./mon-chart -f values-dev.yaml

# Déployer en production
helm install my-app ./mon-chart -f values-production.yaml
```

---

### Overrides avec --set

```bash
# Valeur simple
--set replicaCount=3

# Valeur imbriquée
--set image.tag=v2.0.0
--set image.repository=myregistry/myapp

# Plusieurs valeurs
helm install my-app ./chart \
  --set replicaCount=5 \
  --set image.tag=v2.0.0 \
  --set service.type=LoadBalancer

# Listes
--set  env[0].name=NODE_ENV,env[0].value=production

# Depuis un fichier
--set-file config=/path/to/config.txt

# Depuis JSON
--set-json 'labels={"env":"prod","team":"backend"}'
```

---

## 🪝 Hooks

Les **Hooks** permettent d'exécuter des actions à des moments spécifiques du cycle de vie d'une release.

### Types de Hooks

```yaml
# templates/pre-install-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "mon-app.fullname" . }}-pre-install
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    spec:
      containers:
      - name: pre-install
        image: busybox
        command: ['sh', '-c', 'echo "Pre-install hook"']
      restartPolicy: Never
```

### Hooks disponibles

```yaml
# Installation
helm.sh/hook: pre-install      # Avant l'installation
helm.sh/hook: post-install     # Après l'installation

# Upgrade
helm.sh/hook: pre-upgrade      # Avant la mise à jour
helm.sh/hook: post-upgrade     # Après la mise à jour

# Rollback
helm.sh/hook: pre-rollback     # Avant le rollback
helm.sh/hook: post-rollback    # Après le rollback

# Suppression
helm.sh/hook: pre-delete       # Avant la suppression
helm.sh/hook: post-delete      # Après la suppression

# Tests
helm.sh/hook: test             # Lors de `helm test`
```

### Hook Weight (Ordre d'exécution)

```yaml
annotations:
  "helm.sh/hook-weight": "-5"   # Exécuté en premier
  "helm.sh/hook-weight": "0"    # Par défaut
  "helm.sh/hook-weight": "5"    # Exécuté en dernier
```

### Hook Delete Policy

```yaml
annotations:
  # Supprimer après succès
  "helm.sh/hook-delete-policy": hook-succeeded
  
  # Supprimer après échec
  "helm.sh/hook-delete-policy": hook-failed
  
  # Supprimer avant lancement d'un nouveau hook
  "helm.sh/hook-delete-policy": before-hook-creation
```
