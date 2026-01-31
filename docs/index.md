# 📚 Documentation Hub

Bienvenue dans mon hub de documentation technique ! Vous trouverez ici toutes les ressources nécessaires pour configurer, déployer et gérer vos environnements de développement et de production.

---

# 📖 Table des Matières

## [🛠️ Environnements de Développement](#️-environnements-de-développement)
- [Node.js & NPM](docs/Development_Environment_Setup_Guide.md#nodejs--npm)
- [Python & Flask](docs/Development_Environment_Setup_Guide.md#python--flask)
- [Java & Maven](docs/Development_Environment_Setup_Guide.md#java--maven)
- [.NET Core](docs/Development_Environment_Setup_Guide.md#net-core)
- [PHP & Composer](docs/Development_Environment_Setup_Guide.md#php--composer)
- [Go](docs/Development_Environment_Setup_Guide.md#go)
- [Rust](docs/Development_Environment_Setup_Guide.md#rust)

## [🗄️ Bases de Données](#️-bases-de-données)
- [PostgreSQL](docs/DatabaseGuide.md#postgresql)
- [MariaDB/MySQL](docs/DatabaseGuide.md#mariadbmysql)
- [MongoDB](docs/DatabaseGuide.md#mongodb)
- [Redis](docs/DatabaseGuide.md#redis)
- [Comparaison & Choix](docs/DatabaseGuide.md#comparaison--choix)

## [🐍 Python & Outils](#-python--outils)
- [Environnements virtuels (venv)](docs/venv.md)

## [🔄 DevOps & Best Practices](#-devops--best-practices)
- [Shift Left & Pre-commit](docs/shift-left.md)
  - Configuration pre-commit
  - Qualité de code
  - Sécurité SAST
  - Conventional Commits

## [🔄 CI/CD](#-cicd-continuous-integration--continuous-deployment)
- [GitLab CI](docs/CI-CD/gitlab-ci.md)
  - Configuration & Pipelines
  - Runners & Artifacts
  - Docker & Kubernetes
- [Jenkins](docs/CI-CD/jenkins.md)
  - Installation & Plugins
  - Jenkinsfile & Pipelines
  - Shared Libraries

## [⚙️ Infrastructure as Code](#️-infrastructure-as-code)
- [Terraform](docs/terraform/terraform.md)
  - Installation & Configuration AWS
  - Ressources & Modules
  - State Management
  - Workspaces & Environments
- [Ansible](docs/Ansible/ansible.md)
  - Playbooks & Roles
  - Inventory & Variables
  - Ansible Vault
  - Exemples pratiques

## [☁️ Cloud Providers](#️-cloud-providers)

### AWS (Amazon Web Services)
- [AWS & AWS CLI](docs/aws-cli.md)
  - Introduction à AWS
  - Installation & Configuration AWS CLI
  - Services principaux (S3, EC2, RDS, Lambda, IAM)
  - CloudFormation & Infrastructure as Code
  - CloudWatch & Monitoring
  - VPC & Networking
  - Bonnes pratiques & Sécurité
  - Scripts d'automatisation

### Google Cloud Platform
- [GCP & gcloud CLI](docs/google-cli.md)
  - Installation & Configuration gcloud CLI
  - Compute Engine (Machines Virtuelles)
  - Cloud Storage (gsutil)
  - Kubernetes Engine (GKE)
  - Cloud Functions & Cloud Run
  - Bases de données (Cloud SQL, Firestore, BigQuery)
  - Réseaux, VPC & Load Balancing
  - Identity and Access Management (IAM)
  - Cloud Logging & Monitoring
  - Facturation & Budgets
  - Bonnes pratiques de sécurité et performance

## [🐳 Containerisation & Orchestration](#-containerisation--orchestration)
- [Docker](docs/Docker/docker.md)
  - Images & Conteneurs
  - Volumes & Réseaux
  - Dockerfile & Multi-stage
  - Docker Compose
- [Docker Swarm](docs/Docker/docker-swarm.md)
  - Introduction & Concepts fondamentaux
  - Installation & Configuration du cluster
  - **Déploiement avec docker-compose**
    - Différences docker-compose vs docker stack
    - Section deploy complète
    - Gestion des secrets et configs
    - Exemples pratiques (WordPress, microservices)
    - Variables d'environnement
    - Mises à jour et rollback
  - Services et stacks
  - Réseaux overlay et volumes
  - Mise à l'échelle et rolling updates
  - Monitoring et maintenance
  - Bonnes pratiques production
- [Kubernetes](docs/Kubernetes/kubernetes.md)
  - Concepts & Architecture
  - kubectl Commands
  - Objets & Networking
- [Minikube](docs/Kubernetes/minikube.md) - Développement local
- [K3s](docs/Kubernetes/k3s.md) - IoT & Edge Computing
- [EKS](docs/Kubernetes/eks.md) - Production AWS
- [Helm](docs/Kubernetes/helm.md) - Package Manager

  ## [📊 Observabilité & Monitoring](#-observabilité--monitoring)
- [Prometheus & Grafana](docs/monitoring.md)
  - Installation & Configuration
  - PromQL & Métriques
  - Exporters
  - AlertManager
  - Dashboards Grafana
  - Stack complète

## [💻 Commandes Essentielles](#-commandes-essentielles)
- [Git](docs/Commande_Git.md)
  - Configuration & Branches
  - Commits & Historique
  - Workflows avancés
- [Commandes Utiles](docs/Commande_utile.md)
  - Système & Processus
  - Réseau & Sécurité
  - Maintenance

---

## 🌐 Site de Documentation

Un site web de documentation est disponible et peut être généré avec MkDocs.

### Installation des dépendances

```bash
pip install mkdocs mkdocs-material
```

### Visualisation locale

Pour lancer le serveur de documentation en local :

```bash
mkdocs serve
```
Le site sera alors accessible à l'adresse `http://127.0.0.1:8000`.

### Génération du site statique

Pour générer les fichiers HTML statiques (dans le dossier `site/`) :

```bash
mkdocs build
```

---

<div align="center">

*Si ce repository vous a aidé, n'oubliez pas de laisser une ⭐*

[⬆ Retour en haut](#-documentation-hub)

</div>
