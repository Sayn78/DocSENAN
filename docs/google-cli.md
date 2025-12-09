# Documentation Google Cloud Platform & CLI gcloud

## Table des matières

1. [Introduction à Google Cloud Platform](#introduction-à-google-cloud-platform)
2. [Installation et Configuration de gcloud CLI](#installation-et-configuration-de-gcloud-cli)
3. [Concepts Fondamentaux](#concepts-fondamentaux)
4. [Gestion des Projets](#gestion-des-projets)
5. [Compute Engine (Machines Virtuelles)](#compute-engine-machines-virtuelles)
6. [Cloud Storage](#cloud-storage)
7. [Kubernetes Engine (GKE)](#kubernetes-engine-gke)
8. [Cloud Functions](#cloud-functions)
9. [Cloud Run](#cloud-run)
10. [Bases de Données](#bases-de-données)
11. [Réseaux et Sécurité](#réseaux-et-sécurité)
12. [Identity and Access Management (IAM)](#identity-and-access-management-iam)
13. [Surveillance et Logging](#surveillance-et-logging)
14. [Facturation et Budget](#facturation-et-budget)
15. [Bonnes Pratiques](#bonnes-pratiques)

---

## Introduction à Google Cloud Platform

Google Cloud Platform (GCP) est une suite de services cloud computing proposée par Google. Elle offre des services d'hébergement, de calcul, de stockage, d'analyse de données et d'apprentissage automatique.

### Services Principaux

- **Compute Engine** : Machines virtuelles
- **App Engine** : Platform as a Service (PaaS)
- **Kubernetes Engine** : Orchestration de conteneurs
- **Cloud Functions** : Serverless computing
- **Cloud Run** : Conteneurs serverless
- **Cloud Storage** : Stockage d'objets
- **BigQuery** : Data warehouse
- **Cloud SQL** : Bases de données relationnelles managées
- **Firestore/Datastore** : Bases de données NoSQL

---

## Installation et Configuration de gcloud CLI

### Installation

#### Linux
```bash
# Télécharger et installer
curl https://sdk.cloud.google.com | bash

# Redémarrer le shell
exec -l $SHELL

# Initialiser gcloud
gcloud init
```

#### macOS
```bash
# Avec Homebrew
brew install --cask google-cloud-sdk

# Ou téléchargement direct
curl https://sdk.cloud.google.com | bash
```

#### Windows
```powershell
# Télécharger l'installateur depuis
# https://cloud.google.com/sdk/docs/install

# Ou avec Chocolatey
choco install gcloudsdk
```

### Configuration Initiale

```bash
# Initialiser gcloud et se connecter
gcloud init

# Authentification
gcloud auth login

# Configurer le projet par défaut
gcloud config set project PROJECT_ID

# Configurer la région par défaut
gcloud config set compute/region europe-west1

# Configurer la zone par défaut
gcloud config set compute/zone europe-west1-b

# Vérifier la configuration
gcloud config list
```

### Gestion des Configurations

```bash
# Créer une nouvelle configuration
gcloud config configurations create dev-config

# Lister les configurations
gcloud config configurations list

# Activer une configuration
gcloud config configurations activate dev-config

# Supprimer une configuration
gcloud config configurations delete dev-config
```

### Mise à Jour

```bash
# Mettre à jour gcloud
gcloud components update

# Lister les composants installés
gcloud components list

# Installer un composant
gcloud components install kubectl
gcloud components install beta
gcloud components install alpha
```

---

## Concepts Fondamentaux

### Hiérarchie des Ressources

```
Organisation
    └── Dossiers (Folders)
        └── Projets (Projects)
            └── Ressources (VMs, Storage, etc.)
```

### Projets

Chaque projet possède :
- Un **ID unique** (immuable)
- Un **nom** (modifiable)
- Un **numéro de projet** (attribué par GCP)

```bash
# Lister les projets
gcloud projects list

# Créer un projet
gcloud projects create PROJECT_ID --name="Mon Projet"

# Obtenir les détails d'un projet
gcloud projects describe PROJECT_ID

# Supprimer un projet
gcloud projects delete PROJECT_ID
```

### Régions et Zones

```bash
# Lister les régions disponibles
gcloud compute regions list

# Lister les zones disponibles
gcloud compute zones list

# Lister les zones d'une région
gcloud compute zones list --filter="region:europe-west1"
```

---

## Gestion des Projets

### Opérations de Base

```bash
# Définir le projet actif
gcloud config set project PROJECT_ID

# Voir le projet actif
gcloud config get-value project

# Lister tous les projets accessibles
gcloud projects list

# Filtrer les projets
gcloud projects list --filter="projectId:prod-*"

# Afficher les détails d'un projet
gcloud projects describe PROJECT_ID
```

### Services API

```bash
# Lister les services activés
gcloud services list --enabled

# Lister tous les services disponibles
gcloud services list --available

# Activer un service
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudfunctions.googleapis.com

# Désactiver un service
gcloud services disable SERVICE_NAME
```

---

## Compute Engine (Machines Virtuelles)

### Création de VMs

```bash
# Créer une VM simple
gcloud compute instances create my-instance \
    --zone=europe-west1-b \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud

# VM avec configuration avancée
gcloud compute instances create web-server \
    --zone=europe-west1-b \
    --machine-type=n1-standard-2 \
    --image-family=ubuntu-2004-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=50GB \
    --boot-disk-type=pd-ssd \
    --tags=http-server,https-server \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install -y nginx
      systemctl start nginx'

# VM avec disque de données
gcloud compute instances create data-server \
    --zone=europe-west1-b \
    --create-disk=size=100GB,type=pd-standard,auto-delete=yes
```

### Gestion des VMs

```bash
# Lister les instances
gcloud compute instances list

# Filtrer les instances
gcloud compute instances list --filter="zone:europe-west1-b"

# Démarrer une instance
gcloud compute instances start INSTANCE_NAME --zone=ZONE

# Arrêter une instance
gcloud compute instances stop INSTANCE_NAME --zone=ZONE

# Redémarrer une instance
gcloud compute instances reset INSTANCE_NAME --zone=ZONE

# Supprimer une instance
gcloud compute instances delete INSTANCE_NAME --zone=ZONE

# Obtenir les détails d'une instance
gcloud compute instances describe INSTANCE_NAME --zone=ZONE
```

### Connexion SSH

```bash
# Se connecter via SSH
gcloud compute ssh INSTANCE_NAME --zone=ZONE

# Se connecter avec un utilisateur spécifique
gcloud compute ssh USER@INSTANCE_NAME --zone=ZONE

# Exécuter une commande à distance
gcloud compute ssh INSTANCE_NAME --zone=ZONE --command="ls -la"

# Copier des fichiers (SCP)
gcloud compute scp LOCAL_FILE INSTANCE_NAME:REMOTE_PATH --zone=ZONE
gcloud compute scp INSTANCE_NAME:REMOTE_FILE LOCAL_PATH --zone=ZONE
```

### Types de Machines

```bash
# Lister les types de machines disponibles
gcloud compute machine-types list

# Filtrer par zone
gcloud compute machine-types list --filter="zone:europe-west1-b"

# Changer le type de machine (VM arrêtée)
gcloud compute instances set-machine-type INSTANCE_NAME \
    --machine-type=n1-standard-4 \
    --zone=ZONE
```

### Disques

```bash
# Créer un disque
gcloud compute disks create DISK_NAME \
    --size=100GB \
    --type=pd-ssd \
    --zone=ZONE

# Lister les disques
gcloud compute disks list

# Attacher un disque à une instance
gcloud compute instances attach-disk INSTANCE_NAME \
    --disk=DISK_NAME \
    --zone=ZONE

# Détacher un disque
gcloud compute instances detach-disk INSTANCE_NAME \
    --disk=DISK_NAME \
    --zone=ZONE

# Créer un snapshot
gcloud compute disks snapshot DISK_NAME \
    --snapshot-names=SNAPSHOT_NAME \
    --zone=ZONE

# Créer un disque depuis un snapshot
gcloud compute disks create NEW_DISK \
    --source-snapshot=SNAPSHOT_NAME \
    --zone=ZONE
```

### Images

```bash
# Lister les images publiques
gcloud compute images list

# Lister les images d'un projet
gcloud compute images list --project=PROJECT_ID

# Créer une image depuis un disque
gcloud compute images create IMAGE_NAME \
    --source-disk=DISK_NAME \
    --source-disk-zone=ZONE

# Créer une image depuis un snapshot
gcloud compute images create IMAGE_NAME \
    --source-snapshot=SNAPSHOT_NAME

# Supprimer une image
gcloud compute images delete IMAGE_NAME
```

### Instance Templates

```bash
# Créer un template
gcloud compute instance-templates create TEMPLATE_NAME \
    --machine-type=n1-standard-1 \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --boot-disk-size=20GB

# Lister les templates
gcloud compute instance-templates list

# Créer une instance depuis un template
gcloud compute instances create INSTANCE_NAME \
    --source-instance-template=TEMPLATE_NAME \
    --zone=ZONE

# Supprimer un template
gcloud compute instance-templates delete TEMPLATE_NAME
```

### Instance Groups

```bash
# Créer un groupe d'instances managé
gcloud compute instance-groups managed create GROUP_NAME \
    --template=TEMPLATE_NAME \
    --size=3 \
    --zone=ZONE

# Autoscaling
gcloud compute instance-groups managed set-autoscaling GROUP_NAME \
    --max-num-replicas=10 \
    --min-num-replicas=2 \
    --target-cpu-utilization=0.6 \
    --zone=ZONE

# Lister les groupes d'instances
gcloud compute instance-groups list

# Mettre à jour le template
gcloud compute instance-groups managed set-instance-template GROUP_NAME \
    --template=NEW_TEMPLATE \
    --zone=ZONE

# Rolling update
gcloud compute instance-groups managed rolling-action start-update GROUP_NAME \
    --version=template=NEW_TEMPLATE \
    --zone=ZONE
```

---

## Cloud Storage

### Buckets

```bash
# Créer un bucket
gsutil mb gs://BUCKET_NAME

# Créer un bucket avec options
gsutil mb -c STANDARD -l europe-west1 gs://BUCKET_NAME

# Lister les buckets
gsutil ls

# Obtenir les informations d'un bucket
gsutil ls -L -b gs://BUCKET_NAME

# Supprimer un bucket (vide)
gsutil rb gs://BUCKET_NAME

# Supprimer un bucket et son contenu
gsutil rm -r gs://BUCKET_NAME
```

### Gestion des Objets

```bash
# Uploader un fichier
gsutil cp FILE.txt gs://BUCKET_NAME/

# Uploader un dossier
gsutil cp -r FOLDER/ gs://BUCKET_NAME/

# Télécharger un fichier
gsutil cp gs://BUCKET_NAME/FILE.txt .

# Télécharger un dossier
gsutil cp -r gs://BUCKET_NAME/FOLDER/ .

# Lister les objets
gsutil ls gs://BUCKET_NAME

# Lister récursivement
gsutil ls -r gs://BUCKET_NAME

# Copier entre buckets
gsutil cp gs://SOURCE_BUCKET/FILE gs://DEST_BUCKET/

# Déplacer un fichier
gsutil mv gs://BUCKET_NAME/OLD_NAME gs://BUCKET_NAME/NEW_NAME

# Supprimer un fichier
gsutil rm gs://BUCKET_NAME/FILE

# Supprimer tous les fichiers d'un dossier
gsutil rm -r gs://BUCKET_NAME/FOLDER/
```

### Synchronisation

```bash
# Synchroniser un dossier local vers un bucket
gsutil rsync -r LOCAL_FOLDER/ gs://BUCKET_NAME/

# Synchroniser un bucket vers un dossier local
gsutil rsync -r gs://BUCKET_NAME/ LOCAL_FOLDER/

# Synchronisation avec suppression des fichiers absents
gsutil rsync -r -d LOCAL_FOLDER/ gs://BUCKET_NAME/

# Synchronisation en excluant certains fichiers
gsutil rsync -r -x ".*\.tmp$" LOCAL_FOLDER/ gs://BUCKET_NAME/
```

### Permissions et ACL

```bash
# Rendre un bucket public
gsutil iam ch allUsers:objectViewer gs://BUCKET_NAME

# Rendre un objet public
gsutil acl ch -u AllUsers:R gs://BUCKET_NAME/FILE

# Ajouter un membre avec un rôle
gsutil iam ch user:USER@example.com:objectAdmin gs://BUCKET_NAME

# Voir les permissions d'un bucket
gsutil iam get gs://BUCKET_NAME

# Voir les ACL d'un objet
gsutil acl get gs://BUCKET_NAME/FILE

# Définir une ACL prédéfinie
gsutil acl set private gs://BUCKET_NAME/FILE
gsutil acl set public-read gs://BUCKET_NAME/FILE
```

### Classes de Stockage

```bash
# Changer la classe de stockage d'un bucket
gsutil defstorageclass set NEARLINE gs://BUCKET_NAME

# Classes disponibles : STANDARD, NEARLINE, COLDLINE, ARCHIVE

# Changer la classe d'un objet
gsutil rewrite -s NEARLINE gs://BUCKET_NAME/FILE

# Configuration du lifecycle
cat > lifecycle.json << EOF
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {"age": 30}
      },
      {
        "action": {"type": "Delete"},
        "condition": {"age": 365}
      }
    ]
  }
}
EOF

gsutil lifecycle set lifecycle.json gs://BUCKET_NAME

# Voir la configuration lifecycle
gsutil lifecycle get gs://BUCKET_NAME
```

### Versioning

```bash
# Activer le versioning
gsutil versioning set on gs://BUCKET_NAME

# Désactiver le versioning
gsutil versioning set off gs://BUCKET_NAME

# Vérifier le statut
gsutil versioning get gs://BUCKET_NAME

# Lister toutes les versions
gsutil ls -a gs://BUCKET_NAME/FILE

# Restaurer une version
gsutil cp gs://BUCKET_NAME/FILE#GENERATION gs://BUCKET_NAME/FILE
```

### CORS et Website Hosting

```bash
# Configurer CORS
cat > cors.json << EOF
[
  {
    "origin": ["https://example.com"],
    "method": ["GET", "POST"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]
EOF

gsutil cors set cors.json gs://BUCKET_NAME

# Configurer en tant que site web statique
gsutil web set -m index.html -e 404.html gs://BUCKET_NAME
```

---

## Kubernetes Engine (GKE)

### Création de Clusters

```bash
# Créer un cluster standard
gcloud container clusters create my-cluster \
    --zone=europe-west1-b \
    --num-nodes=3

# Cluster avec configuration avancée
gcloud container clusters create prod-cluster \
    --zone=europe-west1-b \
    --num-nodes=3 \
    --machine-type=n1-standard-2 \
    --disk-size=50 \
    --disk-type=pd-ssd \
    --enable-autoscaling \
    --min-nodes=3 \
    --max-nodes=10 \
    --enable-autorepair \
    --enable-autoupgrade \
    --network=default \
    --subnetwork=default

# Cluster Autopilot (managé)
gcloud container clusters create-auto autopilot-cluster \
    --region=europe-west1

# Cluster avec node pool personnalisé
gcloud container clusters create custom-cluster \
    --zone=europe-west1-b \
    --num-nodes=1 \
    --no-enable-autoupgrade

gcloud container node-pools create high-mem-pool \
    --cluster=custom-cluster \
    --zone=europe-west1-b \
    --machine-type=n1-highmem-4 \
    --num-nodes=2 \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=5
```

### Gestion des Clusters

```bash
# Lister les clusters
gcloud container clusters list

# Obtenir les détails d'un cluster
gcloud container clusters describe CLUSTER_NAME --zone=ZONE

# Obtenir les credentials pour kubectl
gcloud container clusters get-credentials CLUSTER_NAME --zone=ZONE

# Redimensionner un cluster
gcloud container clusters resize CLUSTER_NAME \
    --num-nodes=5 \
    --zone=ZONE

# Mettre à jour un cluster
gcloud container clusters upgrade CLUSTER_NAME --zone=ZONE

# Supprimer un cluster
gcloud container clusters delete CLUSTER_NAME --zone=ZONE
```

### Node Pools

```bash
# Lister les node pools
gcloud container node-pools list --cluster=CLUSTER_NAME --zone=ZONE

# Créer un node pool
gcloud container node-pools create POOL_NAME \
    --cluster=CLUSTER_NAME \
    --zone=ZONE \
    --machine-type=n1-standard-2 \
    --num-nodes=3

# Supprimer un node pool
gcloud container node-pools delete POOL_NAME \
    --cluster=CLUSTER_NAME \
    --zone=ZONE

# Activer l'autoscaling
gcloud container clusters update CLUSTER_NAME \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=10 \
    --zone=ZONE \
    --node-pool=POOL_NAME
```

### Opérations kubectl

```bash
# Après avoir obtenu les credentials avec get-credentials

# Voir les nodes
kubectl get nodes

# Voir les pods
kubectl get pods --all-namespaces

# Déployer une application
kubectl create deployment nginx --image=nginx

# Exposer un déploiement
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Voir les services
kubectl get services

# Scaler un déploiement
kubectl scale deployment nginx --replicas=5

# Voir les logs
kubectl logs POD_NAME

# Exécuter une commande dans un pod
kubectl exec -it POD_NAME -- /bin/bash
```

---

## Cloud Functions

### Déploiement de Functions

```bash
# Fonction HTTP simple
gcloud functions deploy hello-http \
    --runtime=python39 \
    --trigger-http \
    --allow-unauthenticated \
    --entry-point=hello_http

# Fonction avec trigger Pub/Sub
gcloud functions deploy process-message \
    --runtime=nodejs18 \
    --trigger-topic=my-topic \
    --entry-point=processMessage

# Fonction avec trigger Cloud Storage
gcloud functions deploy process-file \
    --runtime=python39 \
    --trigger-resource=BUCKET_NAME \
    --trigger-event=google.storage.object.finalize

# Fonction avec variables d'environnement
gcloud functions deploy my-function \
    --runtime=python39 \
    --trigger-http \
    --set-env-vars=API_KEY=xxx,DB_URL=yyy

# Fonction avec fichier de config
gcloud functions deploy my-function \
    --runtime=python39 \
    --trigger-http \
    --env-vars-file=.env.yaml

# Spécifier la région
gcloud functions deploy my-function \
    --runtime=python39 \
    --trigger-http \
    --region=europe-west1

# Fonction avec plus de mémoire/timeout
gcloud functions deploy big-function \
    --runtime=python39 \
    --trigger-http \
    --memory=2GB \
    --timeout=540s
```

### Gestion des Functions

```bash
# Lister les functions
gcloud functions list

# Obtenir les détails
gcloud functions describe FUNCTION_NAME

# Voir les logs
gcloud functions logs read FUNCTION_NAME

# Suivre les logs en temps réel
gcloud functions logs read FUNCTION_NAME --limit=50 --follow

# Appeler une fonction HTTP
gcloud functions call FUNCTION_NAME --data='{"key":"value"}'

# Supprimer une fonction
gcloud functions delete FUNCTION_NAME

# Mettre à jour une fonction
gcloud functions deploy FUNCTION_NAME \
    --update-env-vars=NEW_VAR=value
```

### Structure d'une Cloud Function Python

```python
# main.py
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`.
    """
    request_json = request.get_json(silent=True)
    name = request_json.get('name', 'World') if request_json else 'World'
    
    return f'Hello {name}!'

def process_pubsub(event, context):
    """Triggered from a message on a Cloud Pub/Sub topic.
    Args:
        event (dict): Event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """
    import base64
    
    if 'data' in event:
        message = base64.b64decode(event['data']).decode('utf-8')
        print(f'Received message: {message}')
```

```yaml
# requirements.txt
flask>=2.0.0
google-cloud-storage>=2.0.0
```

---

## Cloud Run

### Déploiement

```bash
# Déployer depuis une image
gcloud run deploy SERVICE_NAME \
    --image=gcr.io/PROJECT_ID/IMAGE_NAME \
    --platform=managed \
    --region=europe-west1 \
    --allow-unauthenticated

# Déployer depuis le code source (buildpack)
gcloud run deploy SERVICE_NAME \
    --source=. \
    --platform=managed \
    --region=europe-west1

# Déployer avec variables d'environnement
gcloud run deploy SERVICE_NAME \
    --image=IMAGE \
    --set-env-vars=KEY1=VALUE1,KEY2=VALUE2 \
    --region=europe-west1

# Déployer avec limites de ressources
gcloud run deploy SERVICE_NAME \
    --image=IMAGE \
    --memory=2Gi \
    --cpu=2 \
    --max-instances=10 \
    --region=europe-west1

# Déployer avec concurrency
gcloud run deploy SERVICE_NAME \
    --image=IMAGE \
    --concurrency=80 \
    --region=europe-west1

# Déployer avec Cloud SQL
gcloud run deploy SERVICE_NAME \
    --image=IMAGE \
    --add-cloudsql-instances=PROJECT:REGION:INSTANCE \
    --region=europe-west1
```

### Gestion des Services

```bash
# Lister les services
gcloud run services list

# Obtenir les détails
gcloud run services describe SERVICE_NAME --region=REGION

# Voir les révisions
gcloud run revisions list --service=SERVICE_NAME --region=REGION

# Mettre à jour un service
gcloud run services update SERVICE_NAME \
    --set-env-vars=NEW_VAR=value \
    --region=REGION

# Router le trafic entre révisions
gcloud run services update-traffic SERVICE_NAME \
    --to-revisions=REVISION1=50,REVISION2=50 \
    --region=REGION

# Supprimer un service
gcloud run services delete SERVICE_NAME --region=REGION

# Voir les logs
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=SERVICE_NAME" \
    --limit=50 \
    --format=json
```

### Domaines Personnalisés

```bash
# Mapper un domaine
gcloud run domain-mappings create \
    --service=SERVICE_NAME \
    --domain=example.com \
    --region=REGION

# Lister les mappings
gcloud run domain-mappings list --region=REGION

# Supprimer un mapping
gcloud run domain-mappings delete --domain=example.com --region=REGION
```

### IAM et Authentification

```bash
# Rendre un service public
gcloud run services add-iam-policy-binding SERVICE_NAME \
    --member="allUsers" \
    --role="roles/run.invoker" \
    --region=REGION

# Donner accès à un utilisateur
gcloud run services add-iam-policy-binding SERVICE_NAME \
    --member="user:USER@example.com" \
    --role="roles/run.invoker" \
    --region=REGION

# Voir les permissions
gcloud run services get-iam-policy SERVICE_NAME --region=REGION
```

---

## Bases de Données

### Cloud SQL

```bash
# Créer une instance MySQL
gcloud sql instances create INSTANCE_NAME \
    --database-version=MYSQL_8_0 \
    --tier=db-n1-standard-1 \
    --region=europe-west1

# Créer une instance PostgreSQL
gcloud sql instances create INSTANCE_NAME \
    --database-version=POSTGRES_14 \
    --tier=db-f1-micro \
    --region=europe-west1

# Lister les instances
gcloud sql instances list

# Obtenir les détails
gcloud sql instances describe INSTANCE_NAME

# Créer une base de données
gcloud sql databases create DB_NAME --instance=INSTANCE_NAME

# Créer un utilisateur
gcloud sql users create USER_NAME \
    --instance=INSTANCE_NAME \
    --password=PASSWORD

# Se connecter via proxy Cloud SQL
cloud_sql_proxy -instances=PROJECT:REGION:INSTANCE=tcp:3306

# Exporter une base
gcloud sql export sql INSTANCE_NAME gs://BUCKET/backup.sql \
    --database=DB_NAME

# Importer une base
gcloud sql import sql INSTANCE_NAME gs://BUCKET/backup.sql \
    --database=DB_NAME

# Créer un backup
gcloud sql backups create --instance=INSTANCE_NAME

# Lister les backups
gcloud sql backups list --instance=INSTANCE_NAME

# Restaurer depuis un backup
gcloud sql backups restore BACKUP_ID --backup-instance=INSTANCE_NAME

# Supprimer une instance
gcloud sql instances delete INSTANCE_NAME
```

### Firestore

```bash
# Créer une base Firestore (console ou API)
gcloud firestore databases create --region=europe-west1

# Exporter les données
gcloud firestore export gs://BUCKET/backup

# Importer les données
gcloud firestore import gs://BUCKET/backup

# Créer un index composite
gcloud firestore indexes composite create \
    --collection-group=COLLECTION \
    --field-config field-path=FIELD1,order=ASCENDING \
    --field-config field-path=FIELD2,order=DESCENDING

# Lister les index
gcloud firestore indexes composite list
```

### BigQuery

```bash
# Créer un dataset
bq mk --dataset PROJECT_ID:DATASET_NAME

# Lister les datasets
bq ls

# Créer une table
bq mk --table PROJECT_ID:DATASET.TABLE schema.json

# Charger des données depuis CSV
bq load --source_format=CSV DATASET.TABLE gs://BUCKET/data.csv

# Exécuter une requête
bq query --use_legacy_sql=false 'SELECT * FROM `PROJECT.DATASET.TABLE` LIMIT 10'

# Exporter une table
bq extract --destination_format=CSV \
    DATASET.TABLE \
    gs://BUCKET/export.csv

# Copier une table
bq cp PROJECT:DATASET.SOURCE_TABLE PROJECT:DATASET.DEST_TABLE

# Supprimer une table
bq rm -t DATASET.TABLE

# Supprimer un dataset
bq rm -r -d DATASET
```

---

## Réseaux et Sécurité

### VPC et Réseaux

```bash
# Créer un réseau VPC
gcloud compute networks create NETWORK_NAME --subnet-mode=custom

# Créer un sous-réseau
gcloud compute networks subnets create SUBNET_NAME \
    --network=NETWORK_NAME \
    --range=10.0.0.0/24 \
    --region=europe-west1

# Lister les réseaux
gcloud compute networks list

# Lister les sous-réseaux
gcloud compute networks subnets list

# Supprimer un réseau
gcloud compute networks delete NETWORK_NAME
```

### Règles de Pare-feu

```bash
# Créer une règle (autoriser HTTP)
gcloud compute firewall-rules create allow-http \
    --network=NETWORK_NAME \
    --allow=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server

# Créer une règle (autoriser SSH depuis une IP)
gcloud compute firewall-rules create allow-ssh \
    --network=NETWORK_NAME \
    --allow=tcp:22 \
    --source-ranges=203.0.113.0/24

# Lister les règles
gcloud compute firewall-rules list

# Voir les détails d'une règle
gcloud compute firewall-rules describe RULE_NAME

# Mettre à jour une règle
gcloud compute firewall-rules update RULE_NAME \
    --source-ranges=0.0.0.0/0

# Supprimer une règle
gcloud compute firewall-rules delete RULE_NAME
```

### Load Balancing

```bash
# Créer un health check
gcloud compute health-checks create http http-health-check \
    --port=80 \
    --request-path=/health

# Créer un backend service
gcloud compute backend-services create BACKEND_NAME \
    --protocol=HTTP \
    --health-checks=http-health-check \
    --global

# Ajouter un backend
gcloud compute backend-services add-backend BACKEND_NAME \
    --instance-group=GROUP_NAME \
    --instance-group-zone=ZONE \
    --global

# Créer une URL map
gcloud compute url-maps create URL_MAP_NAME \
    --default-service=BACKEND_NAME

# Créer un proxy HTTP
gcloud compute target-http-proxies create HTTP_PROXY_NAME \
    --url-map=URL_MAP_NAME

# Créer une règle de forwarding
gcloud compute forwarding-rules create HTTP_RULE_NAME \
    --global \
    --target-http-proxy=HTTP_PROXY_NAME \
    --ports=80

# Obtenir l'IP du load balancer
gcloud compute forwarding-rules describe HTTP_RULE_NAME --global
```

### Cloud CDN

```bash
# Activer Cloud CDN sur un backend service
gcloud compute backend-services update BACKEND_NAME \
    --enable-cdn \
    --global

# Configurer le cache
gcloud compute backend-services update BACKEND_NAME \
    --cache-mode=CACHE_ALL_STATIC \
    --default-ttl=3600 \
    --global

# Invalider le cache
gcloud compute url-maps invalidate-cdn-cache URL_MAP_NAME \
    --path="/*"
```

### VPN

```bash
# Créer une gateway VPN
gcloud compute target-vpn-gateways create VPN_GATEWAY \
    --network=NETWORK_NAME \
    --region=REGION

# Réserver une IP statique
gcloud compute addresses create VPN_IP --region=REGION

# Créer un tunnel VPN
gcloud compute vpn-tunnels create VPN_TUNNEL \
    --peer-address=PEER_IP \
    --shared-secret=SHARED_SECRET \
    --target-vpn-gateway=VPN_GATEWAY \
    --region=REGION

# Créer une route
gcloud compute routes create VPN_ROUTE \
    --network=NETWORK_NAME \
    --next-hop-vpn-tunnel=VPN_TUNNEL \
    --next-hop-vpn-tunnel-region=REGION \
    --destination-range=REMOTE_RANGE
```

---

## Identity and Access Management (IAM)

### Rôles et Permissions

```bash
# Lister les rôles prédéfinis
gcloud iam roles list

# Voir les détails d'un rôle
gcloud iam roles describe roles/compute.admin

# Créer un rôle personnalisé
gcloud iam roles create ROLE_ID \
    --project=PROJECT_ID \
    --title="Mon Rôle" \
    --description="Description du rôle" \
    --permissions=compute.instances.get,compute.instances.list

# Mettre à jour un rôle
gcloud iam roles update ROLE_ID \
    --project=PROJECT_ID \
    --add-permissions=compute.instances.start

# Supprimer un rôle
gcloud iam roles delete ROLE_ID --project=PROJECT_ID
```

### Policy IAM

```bash
# Voir la policy IAM du projet
gcloud projects get-iam-policy PROJECT_ID

# Ajouter un binding
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member=user:USER@example.com \
    --role=roles/editor

# Types de membres :
# - user:EMAIL
# - serviceAccount:EMAIL
# - group:EMAIL
# - domain:DOMAIN
# - allUsers
# - allAuthenticatedUsers

# Retirer un binding
gcloud projects remove-iam-policy-binding PROJECT_ID \
    --member=user:USER@example.com \
    --role=roles/editor

# IAM pour une ressource spécifique (ex: bucket)
gsutil iam ch user:USER@example.com:objectViewer gs://BUCKET_NAME
```

### Service Accounts

```bash
# Créer un service account
gcloud iam service-accounts create SA_NAME \
    --display-name="Mon Service Account"

# Lister les service accounts
gcloud iam service-accounts list

# Donner un rôle à un service account
gcloud projects add-iam-policy-binding PROJECT_ID \
    --member=serviceAccount:SA_NAME@PROJECT_ID.iam.gserviceaccount.com \
    --role=roles/storage.objectViewer

# Créer une clé
gcloud iam service-accounts keys create key.json \
    --iam-account=SA_NAME@PROJECT_ID.iam.gserviceaccount.com

# Lister les clés
gcloud iam service-accounts keys list \
    --iam-account=SA_NAME@PROJECT_ID.iam.gserviceaccount.com

# Supprimer une clé
gcloud iam service-accounts keys delete KEY_ID \
    --iam-account=SA_NAME@PROJECT_ID.iam.gserviceaccount.com

# Utiliser un service account
gcloud auth activate-service-account --key-file=key.json

# Impersonation
gcloud compute instances list \
    --impersonate-service-account=SA@PROJECT.iam.gserviceaccount.com
```

---

## Surveillance et Logging

### Cloud Logging

```bash
# Lire les logs
gcloud logging read "resource.type=gce_instance" --limit=10

# Lire avec un filtre
gcloud logging read "resource.type=gce_instance AND severity=ERROR" --limit=50

# Lire les logs récents
gcloud logging read "timestamp>\"2024-01-01T00:00:00Z\"" --limit=100

# Format de sortie
gcloud logging read "resource.type=cloud_run_revision" \
    --format=json \
    --limit=10

# Suivre les logs en temps réel
gcloud logging tail "resource.type=cloud_run_revision"

# Créer un sink (export de logs)
gcloud logging sinks create my-sink \
    storage.googleapis.com/BUCKET_NAME \
    --log-filter='resource.type="gce_instance"'

# Lister les sinks
gcloud logging sinks list

# Supprimer un sink
gcloud logging sinks delete my-sink
```

### Cloud Monitoring

```bash
# Lister les métriques disponibles
gcloud monitoring metric-descriptors list

# Créer une alerte
gcloud alpha monitoring policies create \
    --notification-channels=CHANNEL_ID \
    --display-name="CPU Alert" \
    --condition-threshold-value=0.8 \
    --condition-threshold-duration=300s

# Créer un dashboard (via YAML)
gcloud monitoring dashboards create --config-from-file=dashboard.yaml

# Lister les dashboards
gcloud monitoring dashboards list
```

### Uptime Checks

```bash
# Créer un uptime check
gcloud monitoring uptime create HTTP_CHECK \
    --resource-type=uptime-url \
    --resource-labels=host=example.com,project_id=PROJECT_ID \
    --http-check-path=/health

# Lister les uptime checks
gcloud monitoring uptime list

# Supprimer un uptime check
gcloud monitoring uptime delete CHECK_ID
```

---

## Facturation et Budget

### Consultation de Facturation

```bash
# Lister les comptes de facturation
gcloud billing accounts list

# Lier un projet à un compte de facturation
gcloud billing projects link PROJECT_ID \
    --billing-account=BILLING_ACCOUNT_ID

# Voir la facturation d'un projet
gcloud billing projects describe PROJECT_ID

# Exporter les données de facturation vers BigQuery
# (à configurer via la console)
```

### Budgets et Alertes

```bash
# Créer un budget (via API ou console)
gcloud billing budgets create \
    --billing-account=BILLING_ACCOUNT_ID \
    --display-name="Monthly Budget" \
    --budget-amount=1000USD \
    --threshold-rule=percent=80 \
    --threshold-rule=percent=100
```

### Analyse des Coûts

```bash
# Utiliser BigQuery pour analyser les coûts
bq query --use_legacy_sql=false '
SELECT
  service.description as service,
  SUM(cost) as total_cost
FROM `PROJECT.DATASET.gcp_billing_export_v1_BILLING_ID`
WHERE DATE(usage_start_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY service
ORDER BY total_cost DESC
'
```

---

## Bonnes Pratiques

### Sécurité

1. **Principe du moindre privilège**
   ```bash
   # Utiliser des rôles spécifiques plutôt que Owner/Editor
   gcloud projects add-iam-policy-binding PROJECT_ID \
       --member=user:USER@example.com \
       --role=roles/compute.instanceAdmin.v1
   ```

2. **Service Accounts dédiés**
   ```bash
   # Créer un SA par application/service
   gcloud iam service-accounts create app-backend
   gcloud iam service-accounts create app-frontend
   ```

3. **Rotation des clés**
   ```bash
   # Rotation régulière des clés de service account
   # Supprimer les anciennes clés
   gcloud iam service-accounts keys list --iam-account=SA@PROJECT.iam.gserviceaccount.com
   gcloud iam service-accounts keys delete OLD_KEY_ID --iam-account=SA@PROJECT.iam.gserviceaccount.com
   ```

4. **Secrets Management**
   ```bash
   # Utiliser Secret Manager
   gcloud secrets create API_KEY --data-file=secret.txt
   gcloud secrets versions access latest --secret=API_KEY
   ```

### Organisation

1. **Structure des projets**
   ```
   org-production/
   ├── prod-frontend
   ├── prod-backend
   └── prod-data
   
   org-development/
   ├── dev-frontend
   └── dev-backend
   ```

2. **Labels et Tags**
   ```bash
   # Ajouter des labels pour l'organisation
   gcloud compute instances add-labels INSTANCE \
       --labels=env=prod,team=backend,cost-center=engineering
   
   # Filtrer par labels
   gcloud compute instances list --filter="labels.env=prod"
   ```

3. **Naming Conventions**
   ```
   {environment}-{service}-{resource}-{region}
   prod-api-vm-euw1
   dev-db-sql-euw1
   ```

### Performance

1. **Régions et Zones**
   ```bash
   # Choisir la région la plus proche des utilisateurs
   # Utiliser plusieurs zones pour la haute disponibilité
   gcloud compute instance-groups managed create HA_GROUP \
       --template=TEMPLATE \
       --size=3 \
       --zones=europe-west1-b,europe-west1-c,europe-west1-d
   ```

2. **Caching**
   ```bash
   # Activer Cloud CDN
   gcloud compute backend-services update BACKEND \
       --enable-cdn \
       --cache-mode=CACHE_ALL_STATIC
   ```

3. **Auto-scaling**
   ```bash
   # Configurer l'autoscaling approprié
   gcloud compute instance-groups managed set-autoscaling GROUP \
       --max-num-replicas=10 \
       --min-num-replicas=2 \
       --target-cpu-utilization=0.6 \
       --cool-down-period=60
   ```

### Coûts

1. **Committed Use Discounts**
   ```bash
   # Utiliser des engagements pour réduire les coûts
   gcloud compute commitments create COMMITMENT_NAME \
       --region=REGION \
       --plan=12-month \
       --resources=vcpu=10,memory=40GB
   ```

2. **Preemptible VMs**
   ```bash
   # Pour les workloads tolérants aux pannes
   gcloud compute instances create INSTANCE \
       --preemptible \
       --maintenance-policy=TERMINATE
   ```

3. **Lifecycle Policies**
   ```bash
   # Supprimer/archiver automatiquement les anciennes données
   gsutil lifecycle set lifecycle.json gs://BUCKET
   ```

4. **Monitoring des coûts**
   ```bash
   # Configurer des alertes de budget
   # Exporter vers BigQuery pour analyse
   # Utiliser les recommandations GCP
   ```

### Backup et Disaster Recovery

1. **Snapshots réguliers**
   ```bash
   # Script de backup automatisé
   gcloud compute disks snapshot DISK \
       --snapshot-names=backup-$(date +%Y%m%d) \
       --zone=ZONE
   
   # Politique de rétention
   gcloud compute snapshot-schedules create daily-backup \
       --max-retention-days=14 \
       --schedule-daily \
       --start-time=02:00
   ```

2. **Multi-région**
   ```bash
   # Buckets multi-région pour la résilience
   gsutil mb -c MULTI_REGIONAL -l EU gs://BUCKET
   ```

3. **Exports de données**
   ```bash
   # Cloud SQL
   gcloud sql export sql INSTANCE gs://BUCKET/backup-$(date +%Y%m%d).sql
   
   # Firestore
   gcloud firestore export gs://BUCKET/backup-$(date +%Y%m%d)
   ```

### Automation

1. **Cloud Build**
   ```yaml
   # cloudbuild.yaml
   steps:
   - name: 'gcr.io/cloud-builders/docker'
     args: ['build', '-t', 'gcr.io/$PROJECT_ID/app:$COMMIT_SHA', '.']
   - name: 'gcr.io/cloud-builders/docker'
     args: ['push', 'gcr.io/$PROJECT_ID/app:$COMMIT_SHA']
   - name: 'gcr.io/cloud-builders/gcloud'
     args:
     - 'run'
     - 'deploy'
     - 'app'
     - '--image=gcr.io/$PROJECT_ID/app:$COMMIT_SHA'
     - '--region=europe-west1'
     - '--platform=managed'
   ```

2. **Infrastructure as Code**
   ```bash
   # Utiliser Terraform ou Deployment Manager
   gcloud deployment-manager deployments create DEPLOYMENT \
       --config=config.yaml
   ```

3. **Scripts et CLI**
   ```bash
   # Automatiser les tâches répétitives
   #!/bin/bash
   for instance in $(gcloud compute instances list --format="value(name)"); do
       gcloud compute instances add-labels $instance --labels=backup=true
   done
   ```

---

## Ressources Supplémentaires

### Documentation Officielle
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [gcloud CLI Reference](https://cloud.google.com/sdk/gcloud/reference)
- [Best Practices](https://cloud.google.com/architecture/best-practices)

### Outils Utiles
- [Cloud Console](https://console.cloud.google.com)
- [Cloud Shell](https://shell.cloud.google.com)
- [APIs Explorer](https://cloud.google.com/apis/docs/overview)
- [Pricing Calculator](https://cloud.google.com/products/calculator)

### Support et Communauté
- [Stack Overflow](https://stackoverflow.com/questions/tagged/google-cloud-platform)
- [Google Cloud Community](https://www.googlecloudcommunity.com/)
- [GitHub Samples](https://github.com/GoogleCloudPlatform)

### Certification
- Associate Cloud Engineer
- Professional Cloud Architect
- Professional Data Engineer
- Professional Cloud Developer

---

**Dernière mise à jour** : Décembre 2024

**Note** : Les commandes et les options peuvent évoluer. Consultez toujours la documentation officielle pour les informations les plus récentes.
