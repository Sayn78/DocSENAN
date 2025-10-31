# 📚 Documentation Hub

Bienvenue dans mon hub de documentation technique ! Vous trouverez ici toutes les ressources nécessaires pour configurer, déployer et gérer vos environnements de développement et de production.

---

## 🚀 Démarrage Rapide

### Pour les Débutants
Commencez par le [Guide de Configuration des Environnements de Développement](docs/Development_Environment_Setup_Guide.md) pour installer vos premiers outils.

### Pour les DevOps
Explorez les sections [Infrastructure as Code](#-infrastructure-as-code) et [Containerisation](#-containerisation--orchestration) pour automatiser vos déploiements.

---

## 📖 Table des Matières

- [🛠️ Environnements de Développement](#️-environnements-de-développement)
- [⚙️ Infrastructure as Code](#️-infrastructure-as-code)
- [🐳 Containerisation & Orchestration](#-containerisation--orchestration)
- [💻 Commandes Essentielles](#-commandes-essentielles)
  
---

### 🛠️ Environnements de Développement

Guides d'installation et de configuration pour tous les langages et frameworks populaires.

📖 [Documentation Development Environment](docs/Development_Environment_Setup_Guide.md)

**Contenu :**
- ✅ Node.js & NPM
- ✅ Python & Flask
- ✅ Java & Maven
- ✅ .NET Core
- ✅ PHP & Composer
- ✅ Go
- ✅ Rust

---

### 🗄️ Bases de Données
Guide complet pour installer et gérer vos bases de données SQL et NoSQL.

📖 [Documentation Bases de Données](docs/DatabaseGuide.md)

**Contenu :**
- 🐘 **PostgreSQL** - Base relationnelle avancée
  - Installation & configuration
  - Gestion des utilisateurs et privilèges
  - Dumps & restauration
  - Commandes et requêtes utiles
- 🦭 **MariaDB/MySQL** - Base relationnelle populaire
  - Installation (MariaDB & MySQL)
  - Gestion des utilisateurs et hôtes
  - Sauvegarde & restauration
  - Optimisation et monitoring
- 🍃 **MongoDB** - Base NoSQL orientée documents
  - Installation et configuration
  - CRUD et requêtes
  - Gestion des utilisateurs
  - Import/Export de données
- 🔴 **Redis** - Cache et stockage en mémoire
  - Installation et commandes de base
  - Gestion des clés et TTL
  - Persistence et sauvegarde
- 🔄 **Comparaison & Choix** - Quand utiliser quoi ?
- 🔒 **Sécurité** - Bonnes pratiques communes

---

## ⚙️ Infrastructure as Code

Automatisez la gestion de votre infrastructure avec les meilleurs outils du marché.

### 🏗️ Terraform
Infrastructure as Code pour provisionner et gérer vos ressources cloud.

📖 [Documentation Terraform](docs/terraform/terraform.md)

**Contenu :**
- 🎯 **Introduction aux concepts** (Provider, Resource, State, Module)
- 📥 **Installation**
  - Méthode manuelle (version spécifique)
  - Via dépôt HashiCorp (recommandée)
  - Configuration de l'autocomplétion
- ☁️ **Configuration AWS complète**
  - Installation AWS CLI
  - Création utilisateur IAM
  - Configuration des credentials (3 méthodes)
  - Gestion des clés SSH
  - Import de clés dans AWS
- 🚀 **Premiers pas**
  - Structure de projet
  - Fichier main.tf complet (EC2 + Security Groups)
  - Variables et outputs
- 🎮 **Commandes essentielles**
  - Cycle de vie (init, plan, apply, destroy)
  - Commandes avancées (import, taint, graph)
- 📁 **Structure de fichiers**
  - Organisation recommandée
  - variables.tf, outputs.tf, versions.tf
  - .gitignore pour Terraform
- 🔧 **Ressources avancées**
  - VPC complet
  - RDS (bases de données)
  - Load Balancer + Auto Scaling
- 💾 **State Management**
  - Backend S3 + DynamoDB
  - Verrouillage d'état
- 📦 **Modules réutilisables**
  - Création de modules
  - Utilisation et partage
- 🎯 **Cas d'usage pratiques**
  - Stack LAMP complète
  - Application avec Load Balancer
  - Infrastructure multi-environnements
- 🔄 **Workspaces** (gestion d'environnements)
- 🔐 **Gestion des secrets** (Secrets Manager, env vars)
- 📈 **Monitoring & Logging** (CloudWatch)
- 🧪 **Tests & Validation** (TFLint, Terratest)
- 🔄 **CI/CD** (GitHub Actions, GitLab CI)
- 📊 **AMI IDs par région**
- 🔌 **Connexion SSH aux instances**
- 🚨 **Dépannage complet**
- ✅ **Bonnes pratiques de sécurité**

---

### 🔧 Ansible
Automatisez la configuration et le déploiement de vos serveurs.

📖 [Documentation Ansible](docs/Ansible/ansible.md)

**Ce que vous apprendrez :**
- Playbooks et rôles
- Gestion des inventaires
- Déploiement automatisé
- Configuration management

---

## 🐳 Containerisation & Orchestration

Maîtrisez les technologies de conteneurisation et d'orchestration modernes.

### 🐋 Docker
Guide complet pour conteneuriser et déployer vos applications avec Docker.

📖 [Documentation Docker](docs/Docker/docker.md)

**Contenu :**
- 🛠️ Installation & Configuration (méthode officielle)
- 📦 Gestion des images (pull, build, tag, save/load)
- 🚀 Gestion des conteneurs (run, exec, logs, stats)
- 🧱 Volumes & persistance des données
- 🌐 Réseaux Docker (bridge, host, overlay)
- 🏗️ Dockerfile & création d'images
- 🎯 Multi-stage builds (optimisation)
- 🐳 Docker Compose (orchestration multi-conteneurs)
- 🔒 Sécurité & bonnes pratiques
- 🔧 Dépannage (troubleshooting)
- 📊 Monitoring & performance
- 🧹 Nettoyage & maintenance
- 💡 Cas d'usage pratiques (Nginx, PostgreSQL, LAMP)

---

### ☸️ Kubernetes
Orchestrez vos conteneurs à grande échelle avec Kubernetes.

📖 [Documentation Kubernetes - Guide Général](docs/Kubernetes/kubernetes.md)

**Vue d'ensemble :**
Le guide principal couvre tous les concepts fondamentaux de Kubernetes :
- 🏗️ Architecture complète (Control Plane, Worker Nodes)
- 🧩 Concepts fondamentaux (Pods, Services, Deployments, etc.)
- 📥 Installation kubectl (Linux, macOS, Windows)
- 🎮 Commandes kubectl essentielles (200+ commandes)
- 📦 Objets Kubernetes détaillés (Pods, Deployments, Services, StatefulSet, etc.)
- 🌐 Networking (Ingress, NetworkPolicy)
- 💾 Storage (PV, PVC, StorageClass)
- 🔐 ConfigMaps & Secrets
- ✅ Bonnes pratiques

---

**Guides d'Installation Spécifiques :**

Choisissez le guide adapté à votre environnement :

| Guide | Description | Cas d'usage | Lien |
|-------|-------------|-------------|------|
| 📗 **Minikube** | Kubernetes local sur votre machine | Développement, apprentissage, tests | [Guide Minikube](docs/Kubernetes/minikube.md) |
| 🐄 **K3s** | Kubernetes léger et rapide | IoT, Edge, Raspberry Pi, serveurs légers | [Guide K3s](docs/Kubernetes/k3s.md) |
| 📘 **EKS** | Kubernetes managé sur AWS | Production, cloud AWS, haute disponibilité | [Guide EKS](docs/Kubernetes/eks.md) |
| ⎈ **Helm** | Package Manager pour Kubernetes | Déploiement simplifié, gestion d'applications | [Guide Helm](docs/Kubernetes/helm.md) |

#### 📗 Minikube - Kubernetes Local
**Pour le développement local et l'apprentissage**

Contenu :
- Installation multi-plateformes (Linux, macOS, Windows)
- Tous les drivers (Docker, VirtualBox, KVM, Hyper-V)
- Gestion des images Docker (3 méthodes)
- Addons (Dashboard, Ingress, Metrics, Registry)
- Multi-clusters avec profiles
- Tunneling pour LoadBalancer
- Monitoring et Dashboard intégré
- Déploiement avec Helm
- Dépannage complet

#### 🐄 K3s - Kubernetes Léger
**Pour IoT, Edge Computing et environnements contraints**

Contenu :
- Installation ultra-rapide (1 commande)
- Configuration server et agents
- **Gestion des images Docker** :
  - `docker save` → `k3s ctr images import`
  - Toutes les commandes `k3s ctr`
  - Registry privé local
- Cluster multi-nodes
- High Availability (HA)
- Stockage avec Local Path Provisioner
- Optimisation pour faible consommation RAM
- Déploiement avec Helm

#### 📘 EKS - Amazon Elastic Kubernetes Service
**Pour la production sur AWS avec Terraform**

Contenu :
- Installation complète des outils (AWS CLI, kubectl, Terraform)
- Configuration IAM détaillée
- Infrastructure Terraform complète :
  - VPC, Subnets, Security Groups
  - Cluster EKS et Node Groups
  - Variables et outputs
- Configuration kubectl pour EKS
- Déploiement d'applications depuis Docker Hub
- Scaling (cluster et applications)
- Monitoring avec CloudWatch
- Sécurité (RBAC, Secrets Manager)
- Déploiement avec Helm (AWS Load Balancer Controller, etc.)
- Optimisation des coûts
- Dépannage spécifique EKS

#### ⎈ Helm - Package Manager pour Kubernetes
**Le gestionnaire de paquets pour Kubernetes**

Contenu :
- 📥 Installation (Linux, macOS, Windows)
- 🧩 Concepts fondamentaux (Charts, Releases, Repositories)
- 🎮 Commandes essentielles (install, upgrade, rollback)
- 📚 Repositories populaires (Bitnami, Prometheus, Ingress NGINX)
- 🔨 Créer ses propres Charts
- 📝 Templating avancé (values, conditions, boucles)
- ⚙️ Gestion des Values par environnement
- 🪝 Hooks (pre-install, post-upgrade, etc.)
- 📗 **Utilisation avec Minikube**
- 🐄 **Utilisation avec K3s**
- 📘 **Utilisation avec EKS**
- ✅ Bonnes pratiques
- 🔧 Dépannage

---

**Tableau Comparatif :**

| Critère | Minikube | K3s | EKS |
|---------|----------|-----|-----|
| **Environnement** | Local | Local/Serveur | AWS Cloud |
| **Complexité** | 🟢 Simple | 🟢 Simple | 🟡 Moyenne |
| **Coût** | Gratuit | Gratuit | ~$150/mois |
| **RAM minimale** | 2GB | 512MB | N/A (cloud) |
| **Production** | ❌ Non | ✅ Oui | ✅ Oui |
| **Installation** | 5 min | 1 min | 20 min |
| **Multi-nodes** | ✅ Oui | ✅ Oui | ✅ Oui |
| **Dashboard** | ✅ Intégré | ❌ Non | ⚠️ Optionnel |
| **Helm compatible** | ✅ Oui | ✅ Oui | ✅ Oui |

---

## 💻 Commandes Essentielles

### 🔀 Git
Guide complet des commandes Git, des bases aux techniques avancées.

📖 [Commandes Git](docs/Commande_Git.md)

**Contenu :**
- ⚙️ Configuration initiale
- 📁 Initialisation et clonage
- 📄 Gestion des fichiers (add, status, reset)
- 💬 Commits & Historique détaillé
- 🌿 Gestion des branches
- 🔧 Résolution de conflits
- 🗂️ Stash (sauvegardes temporaires)
- ☁️ Dépôts distants (push, pull, fetch)
- 🏷️ Tags et versions
- 🧼 Annulations et corrections
- 🚀 Commandes avancées (rebase, cherry-pick, bisect, reflog)
- 🔀 Workflows (GitFlow, Feature Branch, Trunk-Based)
- 🔄 Migration HTTPS → SSH
- 🔍 Recherche & Investigation
- 💡 Astuces, alias et raccourcis
- 🚨 Commandes de secours

---

### 🛠️ Commandes Utiles
Collection de commandes shell pratiques pour votre quotidien.

📖 [Commandes Utiles](docs/Commande_utile.md)

**Catégories :**
- 📁 Navigation & Gestion des fichiers
- 🔎 Recherche & Affichage
- 👥 Gestion des utilisateurs
- ⚙️ Système & Processus
- 📦 Gestion des paquets (apt)
- 🌐 Réseau & Connectivité
- 🔐 Droits & Permissions
- 🔒 Sécurité (UFW, Fail2Ban, SSH)
- 🧹 Maintenance & Nettoyage

---

## ⭐ Remerciements

Un grand merci à tous les contributeurs qui ont participé à ce projet !

---

<div align="center">

*Si ce repository vous a aidé, n'oubliez pas de laisser une ⭐*

[⬆ Retour en haut](#-documentation-hub)

</div>
