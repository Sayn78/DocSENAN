# Documentation AWS et AWS CLI

## Table des matières

1. [Introduction à AWS](#introduction-à-aws)
2. [AWS CLI - Installation et Configuration](#aws-cli---installation-et-configuration)
3. [Commandes AWS CLI essentielles](#commandes-aws-cli-essentielles)
4. [Services AWS principaux](#services-aws-principaux)
5. [Bonnes pratiques](#bonnes-pratiques)
6. [Exemples pratiques](#exemples-pratiques)

---

## Introduction à AWS

Amazon Web Services (AWS) est la plateforme cloud la plus complète et la plus largement adoptée au monde. Elle offre plus de 200 services complets depuis des centres de données du monde entier.

### Concepts clés

**Régions et Zones de disponibilité**
- **Région** : Zone géographique contenant plusieurs centres de données
- **Zone de disponibilité (AZ)** : Un ou plusieurs centres de données dans une région
- **Edge Locations** : Points de présence pour la distribution de contenu

**Modèle de responsabilité partagée**
- AWS gère la sécurité "du" cloud (infrastructure)
- Le client gère la sécurité "dans" le cloud (données, applications)

---

## AWS CLI - Installation et Configuration

### Installation

**Linux/macOS**
```bash
# Téléchargement et installation
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Vérification
aws --version
```

**Windows**
```powershell
# Télécharger l'installateur MSI depuis:
# https://awscli.amazonaws.com/AWSCLIV2.msi

# Vérification
aws --version
```

**Via pip (ancienne méthode)**
```bash
pip install awscli --upgrade --user
```

### Configuration initiale

```bash
# Configuration interactive
aws configure

# Vous serez invité à entrer:
# AWS Access Key ID: VOTRE_ACCESS_KEY
# AWS Secret Access Key: VOTRE_SECRET_KEY
# Default region name: eu-west-1
# Default output format: json
```

### Profils multiples

```bash
# Créer un profil nommé
aws configure --profile production

# Utiliser un profil spécifique
aws s3 ls --profile production

# Définir un profil par défaut
export AWS_PROFILE=production
```

### Fichiers de configuration

**~/.aws/credentials**
```ini
[default]
aws_access_key_id = VOTRE_ACCESS_KEY
aws_secret_access_key = VOTRE_SECRET_KEY

[production]
aws_access_key_id = AUTRE_ACCESS_KEY
aws_secret_access_key = AUTRE_SECRET_KEY
```

**~/.aws/config**
```ini
[default]
region = eu-west-1
output = json

[profile production]
region = us-east-1
output = table
```

---

## Commandes AWS CLI essentielles

### Syntaxe générale

```bash
aws <service> <commande> [options] [paramètres]
```

### Aide et documentation

```bash
# Aide générale
aws help

# Aide sur un service
aws s3 help

# Aide sur une commande
aws s3 cp help
```

### Options communes

```bash
--region          # Spécifier une région
--profile         # Utiliser un profil spécifique
--output          # Format de sortie (json, text, table)
--query           # Filtrer les résultats avec JMESPath
--dry-run         # Simuler l'action sans l'exécuter
--debug           # Afficher les informations de débogage
```

### Exemples de filtrage avec --query

```bash
# Lister uniquement les noms des instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId'

# Filtrer par tags
aws ec2 describe-instances --query 'Reservations[*].Instances[?Tags[?Key==`Name` && Value==`WebServer`]]'
```

---

## Services AWS principaux

### 1. Amazon S3 (Simple Storage Service)

Service de stockage d'objets scalable et durable.

**Commandes essentielles**

```bash
# Lister les buckets
aws s3 ls

# Créer un bucket
aws s3 mb s3://mon-bucket-unique

# Copier un fichier vers S3
aws s3 cp fichier.txt s3://mon-bucket/

# Copier un dossier récursivement
aws s3 cp monDossier/ s3://mon-bucket/monDossier/ --recursive

# Synchroniser un dossier
aws s3 sync monDossier/ s3://mon-bucket/monDossier/

# Télécharger depuis S3
aws s3 cp s3://mon-bucket/fichier.txt ./

# Supprimer un fichier
aws s3 rm s3://mon-bucket/fichier.txt

# Supprimer un bucket (doit être vide)
aws s3 rb s3://mon-bucket

# Supprimer un bucket avec son contenu
aws s3 rb s3://mon-bucket --force

# Définir les permissions publiques
aws s3api put-bucket-acl --bucket mon-bucket --acl public-read

# Activer le versioning
aws s3api put-bucket-versioning --bucket mon-bucket --versioning-configuration Status=Enabled
```

### 2. Amazon EC2 (Elastic Compute Cloud)

Service de calcul avec des serveurs virtuels redimensionnables.

**Commandes essentielles**

```bash
# Lister les instances
aws ec2 describe-instances

# Lancer une instance
aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.micro \
    --key-name ma-cle \
    --security-group-ids sg-123456 \
    --subnet-id subnet-123456

# Démarrer une instance
aws ec2 start-instances --instance-ids i-1234567890abcdef0

# Arrêter une instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# Redémarrer une instance
aws ec2 reboot-instances --instance-ids i-1234567890abcdef0

# Terminer (supprimer) une instance
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

# Lister les images AMI
aws ec2 describe-images --owners self

# Créer une AMI depuis une instance
aws ec2 create-image \
    --instance-id i-1234567890abcdef0 \
    --name "Mon Image" \
    --description "Description de l'image"

# Lister les security groups
aws ec2 describe-security-groups

# Créer un security group
aws ec2 create-security-group \
    --group-name mon-sg \
    --description "Mon security group" \
    --vpc-id vpc-123456

# Ajouter une règle au security group
aws ec2 authorize-security-group-ingress \
    --group-id sg-123456 \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
```

### 3. Amazon RDS (Relational Database Service)

Service de base de données relationnelle managée.

**Commandes essentielles**

```bash
# Lister les instances de base de données
aws rds describe-db-instances

# Créer une instance RDS
aws rds create-db-instance \
    --db-instance-identifier ma-db \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password MonMotDePasse123! \
    --allocated-storage 20

# Créer un snapshot
aws rds create-db-snapshot \
    --db-snapshot-identifier mon-snapshot \
    --db-instance-identifier ma-db

# Restaurer depuis un snapshot
aws rds restore-db-instance-from-db-snapshot \
    --db-instance-identifier ma-db-restauree \
    --db-snapshot-identifier mon-snapshot

# Supprimer une instance
aws rds delete-db-instance \
    --db-instance-identifier ma-db \
    --skip-final-snapshot
```

### 4. Amazon Lambda

Service de calcul serverless qui exécute du code en réponse à des événements.

**Commandes essentielles**

```bash
# Lister les fonctions
aws lambda list-functions

# Créer une fonction
aws lambda create-function \
    --function-name ma-fonction \
    --runtime python3.9 \
    --role arn:aws:iam::123456789012:role/lambda-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://function.zip

# Invoquer une fonction
aws lambda invoke \
    --function-name ma-fonction \
    --payload '{"key": "value"}' \
    response.json

# Mettre à jour le code
aws lambda update-function-code \
    --function-name ma-fonction \
    --zip-file fileb://function.zip

# Supprimer une fonction
aws lambda delete-function --function-name ma-fonction
```

### 5. Amazon IAM (Identity and Access Management)

Gestion des accès et des identités AWS.

**Commandes essentielles**

```bash
# Lister les utilisateurs
aws iam list-users

# Créer un utilisateur
aws iam create-user --user-name nouveau-utilisateur

# Créer une clé d'accès
aws iam create-access-key --user-name nouveau-utilisateur

# Attacher une politique à un utilisateur
aws iam attach-user-policy \
    --user-name nouveau-utilisateur \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Lister les rôles
aws iam list-roles

# Créer un rôle
aws iam create-role \
    --role-name mon-role \
    --assume-role-policy-document file://trust-policy.json

# Lister les politiques
aws iam list-policies --scope Local
```

### 6. Amazon CloudFormation

Infrastructure as Code pour provisionner des ressources AWS.

**Commandes essentielles**

```bash
# Créer une stack
aws cloudformation create-stack \
    --stack-name ma-stack \
    --template-body file://template.yaml \
    --parameters ParameterKey=KeyName,ParameterValue=ma-cle

# Lister les stacks
aws cloudformation list-stacks

# Décrire une stack
aws cloudformation describe-stacks --stack-name ma-stack

# Mettre à jour une stack
aws cloudformation update-stack \
    --stack-name ma-stack \
    --template-body file://template.yaml

# Supprimer une stack
aws cloudformation delete-stack --stack-name ma-stack
```

### 7. Amazon CloudWatch

Service de monitoring et d'observabilité.

**Commandes essentielles**

```bash
# Lister les métriques
aws cloudwatch list-metrics --namespace AWS/EC2

# Obtenir des statistiques
aws cloudwatch get-metric-statistics \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-01-01T23:59:59Z \
    --period 3600 \
    --statistics Average

# Créer une alarme
aws cloudwatch put-metric-alarm \
    --alarm-name cpu-alarm \
    --alarm-description "Alerte CPU > 80%" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold

# Lister les logs groups
aws logs describe-log-groups

# Récupérer les logs
aws logs tail /aws/lambda/ma-fonction --follow
```

### 8. Amazon VPC (Virtual Private Cloud)

Réseau virtuel isolé dans le cloud AWS.

**Commandes essentielles**

```bash
# Créer un VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Créer un subnet
aws ec2 create-subnet \
    --vpc-id vpc-123456 \
    --cidr-block 10.0.1.0/24

# Créer une Internet Gateway
aws ec2 create-internet-gateway

# Attacher l'IGW au VPC
aws ec2 attach-internet-gateway \
    --internet-gateway-id igw-123456 \
    --vpc-id vpc-123456

# Créer une route table
aws ec2 create-route-table --vpc-id vpc-123456

# Ajouter une route
aws ec2 create-route \
    --route-table-id rtb-123456 \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id igw-123456
```

---

## Bonnes pratiques

### Sécurité

1. **Ne jamais hardcoder les credentials**
   - Utiliser IAM roles pour EC2
   - Utiliser des variables d'environnement ou le fichier credentials

2. **Principe du moindre privilège**
   - Donner uniquement les permissions nécessaires
   - Utiliser des politiques IAM restrictives

3. **Activer MFA**
   ```bash
   aws iam enable-mfa-device \
       --user-name mon-utilisateur \
       --serial-number arn:aws:iam::123456789012:mfa/device \
       --authentication-code-1 123456 \
       --authentication-code-2 789012
   ```

4. **Rotation des clés**
   - Changer régulièrement les access keys
   - Supprimer les clés non utilisées

5. **Chiffrement**
   - Activer le chiffrement S3 par défaut
   - Utiliser KMS pour les données sensibles

### Performance et coûts

1. **Utiliser les tags**
   ```bash
   aws ec2 create-tags \
       --resources i-1234567890abcdef0 \
       --tags Key=Environnement,Value=Production Key=Projet,Value=WebApp
   ```

2. **Surveillance des coûts**
   ```bash
   aws ce get-cost-and-usage \
       --time-period Start=2024-01-01,End=2024-01-31 \
       --granularity MONTHLY \
       --metrics BlendedCost
   ```

3. **Utiliser les instances Spot pour les workloads non critiques**

4. **Automatiser les arrêts/démarrages**
   - Arrêter les instances de dev/test en dehors des heures de travail

### Automation et scripting

1. **Utiliser des scripts bash**
   ```bash
   #!/bin/bash
   # Script pour backup quotidien
   DATE=$(date +%Y-%m-%d)
   aws s3 sync /data s3://mon-backup-bucket/$DATE/
   ```

2. **Gestion des erreurs**
   ```bash
   if ! aws s3 ls s3://mon-bucket; then
       echo "Erreur: Le bucket n'existe pas"
       exit 1
   fi
   ```

3. **Utiliser jq pour parser le JSON**
   ```bash
   aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'
   ```

---

## Exemples pratiques

### Exemple 1: Déploiement automatique d'une application web

```bash
#!/bin/bash

# Variables
REGION="eu-west-1"
AMI_ID="ami-0c55b159cbfafe1f0"
INSTANCE_TYPE="t2.micro"
KEY_NAME="ma-cle"
SG_NAME="web-sg"

# Créer le security group
SG_ID=$(aws ec2 create-security-group \
    --group-name $SG_NAME \
    --description "Security group pour serveur web" \
    --region $REGION \
    --query 'GroupId' \
    --output text)

# Autoriser HTTP et SSH
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region $REGION

aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --region $REGION

# Lancer l'instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --region $REGION \
    --user-data file://user-data.sh \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instance lancée: $INSTANCE_ID"

# Attendre que l'instance soit en cours d'exécution
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

# Obtenir l'IP publique
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --region $REGION \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "Instance accessible à: http://$PUBLIC_IP"
```

### Exemple 2: Backup automatique de bases de données RDS

```bash
#!/bin/bash

# Variables
DB_INSTANCE="ma-base-de-donnees"
SNAPSHOT_NAME="backup-$(date +%Y%m%d-%H%M%S)"

# Créer le snapshot
aws rds create-db-snapshot \
    --db-instance-identifier $DB_INSTANCE \
    --db-snapshot-identifier $SNAPSHOT_NAME

# Attendre que le snapshot soit terminé
aws rds wait db-snapshot-completed \
    --db-snapshot-identifier $SNAPSHOT_NAME

echo "Snapshot créé: $SNAPSHOT_NAME"

# Supprimer les anciens snapshots (garder les 7 derniers)
aws rds describe-db-snapshots \
    --db-instance-identifier $DB_INSTANCE \
    --query 'DBSnapshots[?starts_with(DBSnapshotIdentifier, `backup-`)].DBSnapshotIdentifier' \
    --output text | \
    tr '\t' '\n' | \
    sort -r | \
    tail -n +8 | \
    while read snapshot; do
        echo "Suppression de: $snapshot"
        aws rds delete-db-snapshot --db-snapshot-identifier $snapshot
    done
```

### Exemple 3: Synchronisation S3 avec notifications

```bash
#!/bin/bash

# Variables
SOURCE_DIR="/var/www/html"
BUCKET="mon-site-web"
LOG_FILE="/var/log/s3-sync.log"

# Fonction de logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# Synchroniser
log "Début de la synchronisation"
if aws s3 sync $SOURCE_DIR s3://$BUCKET/ --delete; then
    log "Synchronisation réussie"
    # Invalider le cache CloudFront si nécessaire
    aws cloudfront create-invalidation \
        --distribution-id E1234567890ABC \
        --paths "/*"
else
    log "ERREUR: Échec de la synchronisation"
    exit 1
fi
```

### Exemple 4: Monitoring et alertes

```bash
#!/bin/bash

# Vérifier l'utilisation CPU de toutes les instances
aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=running" \
    --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0]]' \
    --output text | \
while read instance_id name; do
    cpu_usage=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/EC2 \
        --metric-name CPUUtilization \
        --dimensions Name=InstanceId,Value=$instance_id \
        --start-time $(date -u -d '5 minutes ago' +%Y-%m-%dT%H:%M:%S) \
        --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
        --period 300 \
        --statistics Average \
        --query 'Datapoints[0].Average' \
        --output text)
    
    if [ "$cpu_usage" != "None" ]; then
        echo "Instance: $name ($instance_id) - CPU: ${cpu_usage}%"
        
        # Alerte si CPU > 80%
        if (( $(echo "$cpu_usage > 80" | bc -l) )); then
            echo "ALERTE: CPU élevé sur $name"
            # Envoyer une notification SNS
            aws sns publish \
                --topic-arn arn:aws:sns:eu-west-1:123456789012:alertes \
                --message "CPU élevé sur $name: ${cpu_usage}%"
        fi
    fi
done
```

---

## Ressources supplémentaires

### Documentation officielle
- [AWS Documentation](https://docs.aws.amazon.com/)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)

### Outils complémentaires
- **aws-shell**: Shell interactif avec auto-complétion
- **awslogs**: Outil pour consulter les logs CloudWatch
- **aws-vault**: Gestion sécurisée des credentials
- **Terraform**: Infrastructure as Code multi-cloud
- **Ansible**: Automatisation et configuration management

### Commandes utiles pour dépannage

```bash
# Obtenir l'identité courante
aws sts get-caller-identity

# Vérifier les permissions
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/mon-user \
    --action-names s3:GetObject

# Lister toutes les ressources d'une région
aws resourcegroupstaggingapi get-resources --region eu-west-1

# Obtenir les limites de service
aws service-quotas list-service-quotas --service-code ec2
```

---

## Conclusion

AWS CLI est un outil puissant pour automatiser et gérer vos ressources AWS. Cette documentation couvre les bases et les cas d'usage courants. Pour aller plus loin, n'hésitez pas à consulter la documentation officielle et à expérimenter avec les différentes commandes.

**Points clés à retenir:**
- Toujours sécuriser vos credentials
- Utiliser des tags pour organiser vos ressources
- Automatiser les tâches répétitives avec des scripts
- Surveiller les coûts et les performances
- Suivre le principe du moindre privilège pour les permissions IAM
