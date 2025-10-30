# ☸️ EKS – Amazon Elastic Kubernetes Service

## 📋 Table des Matières
- [Introduction](#-introduction)
- [Architecture EKS](#-architecture-eks)
- [Prérequis](#-prérequis)
- [Installation des outils](#-installation-des-outils)
- [Structure du projet Terraform](#-structure-du-projet-terraform)
- [Configuration IAM](#-configuration-iam)
- [Déploiement du cluster EKS](#-déploiement-du-cluster-eks)
- [Configuration kubectl](#-configuration-kubectl)
- [Déploiement d'applications](#-déploiement-dapplications)
- [Gestion du cluster](#-gestion-du-cluster)
- [Monitoring et Logs](#-monitoring-et-logs)
- [Scaling](#-scaling)
- [Sécurité](#-sécurité)
- [Coûts et optimisation](#-coûts-et-optimisation)
- [Dépannage](#-dépannage)

---

## 🎯 Introduction

**Amazon EKS** (Elastic Kubernetes Service) est le service Kubernetes managé d'AWS qui simplifie le déploiement, la gestion et la mise à l'échelle d'applications conteneurisées.

### Avantages d'EKS
- ✅ **Managé** : Control plane géré par AWS
- ✅ **Haute disponibilité** : Multi-AZ automatique
- ✅ **Intégration AWS** : IAM, VPC, ELB, CloudWatch
- ✅ **Conformité** : Certifié Kubernetes
- ✅ **Sécurité** : Chiffrement, IAM, Security Groups
- ✅ **Scalabilité** : Auto-scaling natif

### Cas d'usage
- Applications microservices en production
- Workloads nécessitant haute disponibilité
- Applications nécessitant l'écosystème AWS
- Migration d'applications conteneurisées vers le cloud

---

## 🏗️ Architecture EKS

```
┌─────────────────── AWS Cloud ───────────────────────┐
│                                                      │
│  ┌────────────── EKS Control Plane ──────────────┐  │
│  │  (Managé par AWS - Multi-AZ automatique)      │  │
│  │                                                │  │
│  │  • API Server                                 │  │
│  │  • etcd                                       │  │
│  │  • Controller Manager                         │  │
│  │  • Scheduler                                  │  │
│  └────────────────────────────────────────────────┘  │
│                         │                            │
│                         ↓                            │
│  ┌─────────────── VPC (10.0.0.0/16) ─────────────┐  │
│  │                                                │  │
│  │  ┌─── AZ-A ───┐    ┌─── AZ-B ───┐            │  │
│  │  │ Public      │    │ Public      │            │  │
│  │  │ Subnet      │    │ Subnet      │            │  │
│  │  │ 10.0.1.0/24 │    │ 10.0.2.0/24 │            │  │
│  │  │             │    │             │            │  │
│  │  │  ┌───────┐  │    │  ┌───────┐  │            │  │
│  │  │  │ Node  │  │    │  │ Node  │  │            │  │
│  │  │  │ Group │  │    │  │ Group │  │            │  │
│  │  │  │ (EC2) │  │    │  │ (EC2) │  │            │  │
│  │  │  └───────┘  │    │  └───────┘  │            │  │
│  │  └─────────────┘    └─────────────┘            │  │
│  │         │                  │                    │  │
│  │         └────── IGW ───────┘                    │  │
│  └──────────────────────────────────────────────────┘  │
│                                                      │
│  Services AWS :                                     │
│  • CloudWatch (Logs & Metrics)                     │
│  • ECR (Container Registry)                        │
│  • ELB (Load Balancer)                             │
│  • IAM (Authentication)                            │
└──────────────────────────────────────────────────────┘
```

---

## 🔧 Prérequis

### Compte et accès AWS
- Compte AWS actif
- Utilisateur IAM avec permissions :
  - `AmazonEKSClusterPolicy`
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEC2FullAccess`
  - `IAMFullAccess`
  - `AmazonVPCFullAccess`

### Outils requis
- ✅ **Terraform** >= 1.0
- ✅ **AWS CLI** v2
- ✅ **kubectl**
- ✅ Éditeur de texte / IDE

---

## 📥 Installation des Outils

### AWS CLI v2

```bash
# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Vérifier
aws --version

# Configuration
aws configure
# AWS Access Key ID: AKIAIOSFODNN7EXAMPLE
# AWS Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Default region name: eu-west-3
# Default output format: json
```

### kubectl

```bash
# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Vérifier
kubectl version --client

# Autocomplétion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
source ~/.bashrc
```

### Terraform

```bash
# Voir le guide Terraform pour l'installation complète
wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip
unzip terraform_1.7.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

---

## 📂 Structure du Projet Terraform

```
eks-terraform-project/
├── terraform/
│   ├── main.tf           # Ressources principales (VPC, EKS, Nodes)
│   ├── eks_iam.tf        # Rôles et politiques IAM
│   ├── variables.tf      # Variables de configuration
│   ├── outputs.tf        # Sorties (endpoint, etc.)
│   ├── providers.tf      # Configuration AWS provider
│   ├── versions.tf       # Versions Terraform et providers
│   └── terraform.tfvars  # Valeurs des variables (ne pas commiter si secrets)
├── kubernetes/
│   ├── deployment.yaml   # Déploiement de l'application
│   ├── service.yaml      # Service LoadBalancer
│   └── ingress.yaml      # Ingress (optionnel)
├── scripts/
│   ├── deploy.sh         # Script de déploiement
│   └── cleanup.sh        # Script de nettoyage
└── README.md
```

---

## 🔐 Configuration IAM

### Fichier `eks_iam.tf`

```hcl
# Rôle pour le cluster EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  
  tags = {
    Name        = "${var.cluster_name}-cluster-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Politique pour le cluster EKS
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Politique VPC pour le cluster
resource "aws_iam_role_policy_attachment" "eks_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

# Rôle pour les worker nodes
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  
  tags = {
    Name        = "${var.cluster_name}-node-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Politique Worker Node
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

# Politique CNI (réseau)
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# Politique ECR (Container Registry)
resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# Politique pour CloudWatch (optionnel mais recommandé)
resource "aws_iam_role_policy_attachment" "eks_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_node_role.name
}
```

---

## 🏗️ Déploiement du Cluster EKS

### Fichier `variables.tf`

```hcl
variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "mon-cluster-eks"
}

variable "environment" {
  description = "Environnement (dev, staging, production)"
  type        = string
  default     = "dev"
}

variable "kubernetes_version" {
  description = "Version de Kubernetes"
  type        = string
  default     = "1.29"
}

variable "node_instance_types" {
  description = "Types d'instances pour les nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Nombre souhaité de nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Nombre minimum de nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Nombre maximum de nodes"
  type        = number
  default     = 4
}
```

---

### Fichier `main.tf`

```hcl
provider "aws" {
  region = var.aws_region
}

# Data source pour les AZ disponibles
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC pour EKS
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name                                        = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Environment                                 = var.environment
    ManagedBy                                   = "Terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  
  tags = {
    Name        = "${var.cluster_name}-igw"
    Environment = var.environment
  }
}

# Subnet publique AZ-A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-a"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    Environment                                 = var.environment
  }
}

# Subnet publique AZ-B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  
  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-b"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
    Environment                                 = var.environment
  }
}

# Table de routage
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
  
  tags = {
    Name        = "${var.cluster_name}-public-rt"
    Environment = var.environment
  }
}

# Associations route table
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group pour le cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group pour le cluster EKS"
  vpc_id      = aws_vpc.eks_vpc.id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.cluster_name}-cluster-sg"
    Environment = var.environment
  }
}

# Security Group pour les nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group pour les worker nodes EKS"
  vpc_id      = aws_vpc.eks_vpc.id
  
  # Communication entre nodes
  ingress {
    description = "Allow nodes to communicate"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }
  
  # Communication depuis le cluster
  ingress {
    description     = "Allow cluster to communicate with nodes"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.cluster_name}-nodes-sg"
    Environment = var.environment
  }
}

# Cluster EKS
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.eks_cluster_role.arn
  
  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
  
  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16"
  }
  
  # Logs CloudWatch
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_policy
  ]
  
  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Node Group
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
  
  instance_types = var.node_instance_types
  
  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }
  
  update_config {
    max_unavailable = 1
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_registry_policy
  ]
  
  tags = {
    Name        = "${var.cluster_name}-node-group"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

---

### Fichier `outputs.tf`

```hcl
output "cluster_id" {
  description = "ID du cluster EKS"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_name" {
  description = "Nom du cluster EKS"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_security_group_id" {
  description = "Security group du cluster"
  value       = aws_security_group.eks_cluster_sg.id
}

output "cluster_certificate_authority_data" {
  description = "Certificat d'autorité du cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive   = true
}

output "cluster_region" {
  description = "Région AWS du cluster"
  value       = var.aws_region
}

output "configure_kubectl" {
  description = "Commande pour configurer kubectl"
  value       = "aws eks --region ${var.aws_region} update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name}"
}
```

---

### Fichier `terraform.tfvars`

```hcl
aws_region           = "eu-west-3"
cluster_name         = "mon-cluster-eks"
environment          = "production"
kubernetes_version   = "1.29"
node_instance_types  = ["t3.medium"]
node_desired_size    = 2
node_min_size        = 1
node_max_size        = 4
```

---

## 🚀 Déploiement

### Étapes de déploiement

```bash
# 1. Aller dans le dossier Terraform
cd terraform/

# 2. Initialiser Terraform
terraform init

# 3. Valider la configuration
terraform validate

# 4. Voir le plan d'exécution
terraform plan

# 5. Appliquer la configuration
terraform apply

# Confirmer avec 'yes'
```

**⏱️ Temps de déploiement** : 15-20 minutes

---

## 🔌 Configuration kubectl

### Récupérer le kubeconfig

```bash
# Configuration automatique
aws eks --region eu-west-3 update-kubeconfig --name mon-cluster-eks

# Ou utiliser la commande depuis l'output Terraform
terraform output -raw configure_kubectl | bash

# Vérifier la connexion
kubectl cluster-info
kubectl get nodes
kubectl get pods --all-namespaces
```

### Configuration manuelle (si nécessaire)

```bash
# Créer le fichier kubeconfig
cat > ~/.kube/config-eks << EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: <CA_DATA>
    server: <CLUSTER_ENDPOINT>
  name: eks-cluster
contexts:
- context:
    cluster: eks-cluster
    user: eks-user
  name: eks
current-context: eks
kind: Config
users:
- name: eks-user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --cluster-name
        - mon-cluster-eks
        - --region
        - eu-west-3
EOF

# Utiliser ce config
export KUBECONFIG=~/.kube/config-eks
kubectl get nodes
```

---

## 📦 Déploiement d'Applications

### Exemple : Application Node.js depuis Docker Hub

#### Fichier `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-app
  labels:
    app: node-app
    environment: production
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
        image: <votre_dockerhub_user>/<votre_app>:latest
        ports:
        - containerPort: 3000
          protocol: TCP
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "3000"
        resources:
          requests:
            memory: "128Mi"
            cpu: "250m"
          limits:
            memory: "256Mi"
            cpu: "500m"
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
```

#### Fichier `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: node-app-service
  labels:
    app: node-app
spec:
  type: LoadBalancer
  selector:
    app: node-app
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 3000
  sessionAffinity: None
```

#### Déploiement

```bash
# Appliquer les manifests
kubectl apply -f kubernetes/deployment.yaml
kubectl apply -f kubernetes/service.yaml

# Vérifier le déploiement
kubectl get deployments
kubectl get pods
kubectl get services

# Obtenir l'URL du LoadBalancer
kubectl get service node-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Attendre que le LoadBalancer soit prêt (peut prendre 2-3 minutes)
kubectl wait --for=condition=Ready pod -l app=node-app --timeout=300s

# Tester l'application
curl http://$(kubectl get service node-app-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

---

## 🔧 Gestion du Cluster

### Mise à l'échelle

```bash
# Scaler le deployment
kubectl scale deployment node-app --replicas=5

# Scaler le node group (via Terraform)
# Modifier terraform.tfvars
node_desired_size = 3
node_max_size     = 6

# Appliquer
terraform apply

# Ou via AWS CLI
aws eks update-nodegroup-config \
    --cluster-name mon-cluster-eks \
    --nodegroup-name mon-cluster-eks-node-group \
    --scaling-config desiredSize=3,minSize=1,maxSize=6 \
    --region eu-west-3
```

### Mise à jour de l'application

```bash
# Mettre à jour l'image
kubectl set image deployment/node-app node-app=<votre_user>/<votre_app>:v2.0

# Suivre le rollout
kubectl rollout status deployment/node-app

# Historique
kubectl rollout history deployment/node-app

# Rollback si nécessaire
kubectl rollout undo deployment/node-app
```

### Mise à jour du cluster Kubernetes

```bash
# Via Terraform
# Modifier variables.tf
kubernetes_version = "1.30"

# Appliquer
terraform apply

# Ou via AWS CLI
aws eks update-cluster-version \
    --name mon-cluster-eks \
    --kubernetes-version 1.30 \
    --region eu-west-3
```

---

## 📊 Monitoring et Logs

### CloudWatch Logs

```bash
# Les logs sont automatiquement envoyés à CloudWatch
# Voir dans AWS Console : CloudWatch > Log groups > /aws/eks/mon-cluster-eks/cluster

# Via AWS CLI
aws logs tail /aws/eks/mon-cluster-eks/cluster --follow --region eu-west-3
```

### Métriques Kubernetes

```bash
# Installer metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Voir les métriques
kubectl top nodes
kubectl top pods
```

### CloudWatch Container Insights

```bash
# Installer CloudWatch agent
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml

# Installer Fluentd
kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluentd/fluentd.yaml
```

---

## 🔐 Sécurité

### RBAC (Role-Based Access Control)

```yaml
# serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: default

---
# role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]

---
# rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rolebinding
subjects:
- kind: ServiceAccount
  name: app-sa
roleRef:
  kind: Role
  name: app-role
  apiGroup: rbac.authorization.k8s.io
```

### Secrets Manager Integration

```bash
# Installer AWS Secrets Manager CSI Driver
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/rbac-secretproviderclass.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/csidriver.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/secrets-store.csi.x-k8s.io_secretproviderclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/secrets-store.csi.x-k8s.io_secretproviderclasspodstatuses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/main/deploy/secrets-store-csi-driver.yaml
```

---

## 💰 Coûts et Optimisation

### Estimation des coûts (eu-west-3)

| Ressource | Coût approximatif |
|-----------|-------------------|
| Cluster EKS | $0.10/heure ($73/mois) |
| 2x t3.medium nodes | ~$60/mois |
| Load Balancer | ~$20/mois |
| Data transfer | Variable |
| **Total estimé** | **~$153/mois** |

### Optimisations
