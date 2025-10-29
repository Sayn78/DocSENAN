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

📖 [Documentation Kubernetes](docs/Kubernetes/kubernetes.md)

**Contenu :**
- 🔹 Pods, Services, Deployments
- 🔹 ConfigMaps et Secrets
- 🔹 Ingress et Load Balancing
- 🔹 Scaling et monitoring
- 🔹 Helm charts

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
