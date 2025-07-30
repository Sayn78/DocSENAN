# ☸️ Kubernetes – Installation & Configuration (EKS AWS via Terraform)

Déploiement d'un cluster Kubernetes EKS sur AWS avec Terraform et déploiement d'une application Docker

Ce guide explique comment déployer un cluster Amazon EKS sur AWS à l'aide de Terraform, configurer kubectl pour interagir avec le cluster, et déployer une application stockée sur Docker Hub.

## 🔧 Prérequis

Outils installés localement

Terraform

AWS CLI v2

kubectl

Un compte AWS avec des droits suffisants pour créer des ressources EKS, IAM, VPC, EC2, etc.

## 📂 Structure des fichiers Terraform

Projet2/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── eks_iam.tf


## Créer un fichier "eks_iam.tf" pour les rôles IAM

```bash

resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name = "eksNodeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

```


## Créer le fichier main.tf (luster EKS)

Inclut la création de VPC, sous-réseaux publics dans 2 AZ, le cluster EKS et le Node Group.)

```bash

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Projet2-VPC"
  }
}

# Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "Projet2-Subnet"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}b"

  tags = {
    Name = "Projet2-Subnet-2"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Projet2-IGW"
  }
}

# Route Table
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Projet2-RouteTable"
  }
}

# Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "projet2-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.main_subnet.id,
      aws_subnet.secondary_subnet.id
    ]
    security_group_ids = [aws_security_group.eks_nodes.id]
  }


  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16"
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

```


## 💡 Initialisation du cluster EKS

```bash
cd terraform
terraform init
terraform apply
```

## 📂 Récupération du contexte kubeconfig

```bash
aws eks --region eu-west-3 update-kubeconfig --name projet2-eks-cluster
```

## 🚀 Déploiement d'une application depuis Docker Hub

Exemple de fichier deployment.yaml

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: projet2-node-app
spec:
  replicas: 1
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
        image: sayn78300/projet2-node-app:latest
        ports:
        - containerPort: 3000
```

Exemple de fichier service.yaml

```bash
apiVersion: v1
kind: Service
metadata:
  name: node-app-service
spec:
  type: LoadBalancer
  selector:
    app: node-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
```

## Déploiement

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```