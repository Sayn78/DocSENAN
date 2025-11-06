# Jenkins - Guide Complet

## Introduction

Jenkins est un serveur d'automatisation open-source écrit en Java, utilisé pour l'intégration continue (CI) et le déploiement continu (CD). C'est l'un des outils CI/CD les plus populaires et matures de l'industrie, avec une communauté très active et un écosystème riche de plus de 1800 plugins.

### Pourquoi Jenkins ?

- 🔌 **Extensibilité** : Plus de 1800 plugins disponibles
- 🌐 **Multi-plateforme** : Support Linux, Windows, macOS
- 📝 **Pipeline as Code** : Jenkinsfile en Groovy
- 🎨 **Interface moderne** : Blue Ocean disponible
- 👥 **Communauté active** : Documentation abondante et support
- 🔄 **Intégrations** : Git, Docker, Kubernetes, AWS, Azure, GCP
- 💰 **Open-source** : Gratuit et personnalisable

### Architecture Jenkins

```
┌─────────────────────────────────────────────┐
│           Jenkins Master (Controller)       │
│  - Gestion des jobs et pipelines           │
│  - Interface web                            │
│  - Planification des builds                │
│  - Distribution des jobs aux agents         │
└──────────────┬──────────────────────────────┘
               │
       ┌───────┴───────┐
       │               │
┌──────▼─────┐  ┌─────▼──────┐
│  Agent 1   │  │  Agent 2   │
│  (Linux)   │  │  (Windows) │
└────────────┘  └────────────┘
```

---

## Installation

### 🐧 Installation sur Linux (Ubuntu/Debian)

#### Méthode 1 : Via le dépôt officiel (Recommandée)

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation de Java (Jenkins nécessite Java 11 ou 17)
sudo apt install -y openjdk-17-jdk

# Vérification de Java
java -version

# Ajout de la clé GPG Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Ajout du dépôt Jenkins
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Installation de Jenkins
sudo apt update
sudo apt install -y jenkins

# Démarrage et activation de Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Vérification du statut
sudo systemctl status jenkins
```

#### Méthode 2 : Via le fichier WAR (portable)

```bash
# Téléchargement du fichier WAR
wget https://get.jenkins.io/war-stable/latest/jenkins.war

# Lancement de Jenkins
java -jar jenkins.war --httpPort=8080
```

### 🪟 Installation sur Windows

1. **Télécharger l'installeur** : https://www.jenkins.io/download/
2. **Exécuter l'installeur** et suivre les instructions
3. **Choisir le port** (par défaut : 8080)
4. **Installer comme service Windows**

Ou via Chocolatey :
```powershell
choco install jenkins
```

### 🍎 Installation sur macOS

```bash
# Via Homebrew
brew install jenkins-lts

# Démarrage de Jenkins
brew services start jenkins-lts

# Jenkins sera accessible sur http://localhost:8080
```

### 🐳 Installation avec Docker (Recommandée pour les tests)

```bash
# Création d'un réseau Docker
docker network create jenkins

# Volume pour la persistance
docker volume create jenkins-data

# Lancement de Jenkins
docker run -d \
  --name jenkins \
  --network jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

# Récupération du mot de passe initial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Configuration Initiale

1. **Accéder à Jenkins** : `http://localhost:8080`
2. **Débloquer Jenkins** : Entrer le mot de passe initial
   ```bash
   # Sur Linux
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   
   # Sur Docker
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. **Installer les plugins suggérés** ou sélectionner manuellement
4. **Créer le premier utilisateur admin**
5. **Configurer l'URL Jenkins**

---

## Plugins Essentiels

### Installation des plugins

**Via l'interface :**
1. Dashboard → Manage Jenkins → Plugins
2. Available plugins → Rechercher et sélectionner
3. Install

**Via Groovy Script (automatisation) :**
```groovy
def plugins = [
    "git",
    "pipeline-stage-view",
    "docker-plugin",
    "kubernetes",
    "slack"
]

def pluginManager = Jenkins.instance.pluginManager
def updateCenter = Jenkins.instance.updateCenter

plugins.each { plugin ->
    if (!pluginManager.getPlugin(plugin)) {
        def pluginToInstall = updateCenter.getPlugin(plugin)
        pluginToInstall.deploy()
    }
}
```

### Liste des plugins recommandés

#### Intégration Source Control
- **Git Plugin** : Intégration avec Git
- **GitHub** : Intégration GitHub (webhooks, statuts)
- **GitLab Plugin** : Intégration GitLab
- **Bitbucket** : Intégration Bitbucket

#### Pipeline
- **Pipeline** : Support des pipelines Jenkins
- **Pipeline: Stage View** : Visualisation des stages
- **Blue Ocean** : Interface moderne pour les pipelines
- **Pipeline: Multibranch** : Pipelines multi-branches

#### Conteneurisation
- **Docker Plugin** : Intégration Docker
- **Docker Pipeline** : Étapes Docker dans les pipelines
- **Kubernetes** : Déploiement sur Kubernetes
- **Kubernetes CLI** : Commandes kubectl

#### Cloud
- **Amazon EC2** : Agents sur AWS
- **Azure VM Agents** : Agents sur Azure
- **Google Compute Engine** : Agents sur GCP

#### Notifications
- **Slack Notification** : Notifications Slack
- **Email Extension** : Emails personnalisés
- **Telegram** : Notifications Telegram

#### Qualité & Sécurité
- **SonarQube Scanner** : Analyse de code
- **OWASP Dependency-Check** : Scan de vulnérabilités
- **Warnings Next Generation** : Analyse des warnings
- **Code Coverage API** : Couverture de code

#### Utilitaires
- **Credentials Binding** : Gestion des secrets
- **Configuration as Code** : Configuration via YAML
- **Job DSL** : Création de jobs via code
- **Workspace Cleanup** : Nettoyage automatique

---

## Jenkinsfile - Pipeline as Code

### Types de Pipelines

#### 1. Pipeline Déclaratif (Recommandé)

Syntaxe plus simple et structurée, idéale pour la plupart des cas d'usage.

```groovy
pipeline {
    agent any
    
    environment {
        // Variables d'environnement
        APP_NAME = 'mon-application'
        VERSION = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'npm install'
                sh 'npm run build'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'npm test'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                sh './deploy.sh'
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline terminé'
        }
        success {
            echo 'Build réussi!'
        }
        failure {
            echo 'Build échoué'
        }
    }
}
```

#### 2. Pipeline Scripté

Plus flexible mais plus complexe, basé sur Groovy.

```groovy
node {
    stage('Build') {
        echo 'Building...'
        sh 'npm install'
        sh 'npm run build'
    }
    
    stage('Test') {
        echo 'Testing...'
        sh 'npm test'
    }
    
    stage('Deploy') {
        echo 'Deploying...'
        sh './deploy.sh'
    }
}
```

### Syntaxe du Pipeline Déclaratif

#### Agent

Définit où le pipeline s'exécute.

```groovy
pipeline {
    // Exécution sur n'importe quel agent disponible
    agent any
    
    // Ou agent spécifique
    agent {
        label 'linux'
    }
    
    // Ou dans un conteneur Docker
    agent {
        docker {
            image 'node:18'
            args '-v /tmp:/tmp'
        }
    }
    
    // Ou sur Kubernetes
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.8.6
'''
        }
    }
}
```

#### Environment

Variables d'environnement globales ou par stage.

```groovy
pipeline {
    agent any
    
    environment {
        // Variables globales
        DOCKER_REGISTRY = 'registry.example.com'
        APP_NAME = 'myapp'
        
        // Variables avec credentials
        DOCKER_CREDS = credentials('docker-hub-credentials')
        AWS_CREDS = credentials('aws-credentials')
    }
    
    stages {
        stage('Build') {
            environment {
                // Variables spécifiques au stage
                BUILD_ENV = 'production'
            }
            steps {
                sh 'echo $BUILD_ENV'
            }
        }
    }
}
```

#### Parameters

Paramètres d'entrée pour le pipeline.

```groovy
pipeline {
    agent any
    
    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'staging', description: 'Target environment')
        choice(name: 'DEPLOY_TYPE', choices: ['rolling', 'blue-green', 'canary'], description: 'Deployment strategy')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run tests?')
        text(name: 'RELEASE_NOTES', defaultValue: '', description: 'Release notes')
    }
    
    stages {
        stage('Deploy') {
            when {
                expression { params.RUN_TESTS }
            }
            steps {
                echo "Deploying to ${params.ENVIRONMENT}"
                echo "Using ${params.DEPLOY_TYPE} deployment"
            }
        }
    }
}
```

#### Triggers

Déclencheurs automatiques du pipeline.

```groovy
pipeline {
    agent any
    
    triggers {
        // Poll SCM toutes les 5 minutes
        pollSCM('H/5 * * * *')
        
        // Cron (tous les jours à 2h du matin)
        cron('0 2 * * *')
        
        // Après un autre job
        upstream(upstreamProjects: 'job1,job2', threshold: hudson.model.Result.SUCCESS)
    }
    
    stages {
        // ...
    }
}
```

#### Options

Options de configuration du pipeline.

```groovy
pipeline {
    agent any
    
    options {
        // Timeout global
        timeout(time: 1, unit: 'HOURS')
        
        // Nombre de builds à conserver
        buildDiscarder(logRotator(numToKeepStr: '10'))
        
        // Désactive le checkout automatique
        skipDefaultCheckout()
        
        // Timestamps dans les logs
        timestamps()
        
        // Pas de builds concurrents
        disableConcurrentBuilds()
        
        // Retry automatique
        retry(3)
    }
    
    stages {
        // ...
    }
}
```

#### When

Conditions d'exécution des stages.

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy to Production') {
            when {
                // Seulement sur la branche main
                branch 'main'
            }
            steps {
                echo 'Deploying to production...'
            }
        }
        
        stage('Deploy to Staging') {
            when {
                allOf {
                    // Plusieurs conditions
                    branch 'develop'
                    environment name: 'DEPLOY_ENV', value: 'staging'
                }
            }
            steps {
                echo 'Deploying to staging...'
            }
        }
        
        stage('Manual Approval') {
            when {
                // Basé sur une expression
                expression { params.REQUIRE_APPROVAL == true }
            }
            steps {
                input message: 'Approve deployment?'
            }
        }
    }
}
```

#### Post Actions

Actions à exécuter après le pipeline ou un stage.

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'npm run build'
            }
            post {
                success {
                    echo 'Build stage réussi'
                }
                failure {
                    echo 'Build stage échoué'
                }
            }
        }
    }
    
    post {
        always {
            // Toujours exécuté
            echo 'Pipeline terminé'
            cleanWs()  // Nettoyage du workspace
        }
        success {
            // Si succès
            slackSend(color: 'good', message: "Build réussi: ${env.JOB_NAME} ${env.BUILD_NUMBER}")
        }
        failure {
            // Si échec
            slackSend(color: 'danger', message: "Build échoué: ${env.JOB_NAME} ${env.BUILD_NUMBER}")
            emailext(
                subject: "Build Failed: ${env.JOB_NAME}",
                body: "Check console output at ${env.BUILD_URL}",
                to: 'team@example.com'
            )
        }
        unstable {
            // Si instable (tests échoués mais build ok)
            echo 'Build instable'
        }
        changed {
            // Si le statut a changé par rapport au précédent build
            echo 'Le statut du build a changé'
        }
    }
}
```

---

## Exemples de Pipelines Complets

### Pipeline Node.js avec Tests et Déploiement

```groovy
pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
    environment {
        NODE_ENV = 'production'
        APP_NAME = 'nodejs-app'
        DOCKER_REGISTRY = 'registry.example.com'
        DOCKER_IMAGE = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_NUMBER}"
    }
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm ci --prefer-offline'
            }
        }
        
        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh 'npm run test:unit -- --coverage'
            }
            post {
                always {
                    junit 'test-results/junit.xml'
                    publishHTML([
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
        
        stage('Integration Tests') {
            steps {
                sh 'npm run test:integration'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                sh "trivy image --severity HIGH,CRITICAL ${DOCKER_IMAGE}"
            }
        }
        
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials') {
                        docker.image(DOCKER_IMAGE).push()
                        docker.image(DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                sh """
                    kubectl set image deployment/${APP_NAME} \
                        ${APP_NAME}=${DOCKER_IMAGE} \
                        -n staging
                    kubectl rollout status deployment/${APP_NAME} -n staging
                """
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                sh """
                    kubectl set image deployment/${APP_NAME} \
                        ${APP_NAME}=${DOCKER_IMAGE} \
                        -n production
                    kubectl rollout status deployment/${APP_NAME} -n production
                """
            }
        }
    }
    
    post {
        success {
            slackSend(
                color: 'good',
                message: "✅ Build réussi: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir les détails>"
            )
        }
        failure {
            slackSend(
                color: 'danger',
                message: "❌ Build échoué: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir les détails>"
            )
        }
        always {
            cleanWs()
        }
    }
}
```

### Pipeline Multi-branches avec Matrix

```groovy
pipeline {
    agent none
    
    stages {
        stage('Test') {
            matrix {
                axes {
                    axis {
                        name 'NODE_VERSION'
                        values '16', '18', '20'
                    }
                    axis {
                        name 'OS'
                        values 'linux', 'windows'
                    }
                }
                excludes {
                    exclude {
                        axis {
                            name 'NODE_VERSION'
                            values '16'
                        }
                        axis {
                            name 'OS'
                            values 'windows'
                        }
                    }
                }
                agent {
                    docker {
                        image "node:${NODE_VERSION}"
                        label "${OS}"
                    }
                }
                stages {
                    stage('Build & Test') {
                        steps {
                            sh 'npm ci'
                            sh 'npm test'
                        }
                    }
                }
            }
        }
    }
}
```

### Pipeline avec Stages Parallèles

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        
        stage('Tests Parallèles') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'npm run test:unit'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'npm run test:integration'
                    }
                }
                stage('E2E Tests') {
                    agent {
                        docker {
                            image 'cypress/base:18'
                        }
                    }
                    steps {
                        sh 'npm run test:e2e'
                    }
                }
                stage('Security Scan') {
                    steps {
                        sh 'npm audit'
                        sh 'snyk test'
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
```

### Pipeline Docker Multi-stage avec Kubernetes

```groovy
pipeline {
    agent any
    
    environment {
        REGISTRY = 'docker.io'
        IMAGE_NAME = 'myorg/myapp'
        DOCKER_CREDS = credentials('dockerhub-credentials')
        KUBE_CONFIG = credentials('kubeconfig')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build & Push Docker Image') {
            steps {
                script {
                    def customImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    
                    docker.withRegistry("https://${REGISTRY}", 'dockerhub-credentials') {
                        customImage.push()
                        customImage.push('latest')
                    }
                }
            }
        }
        
        stage('Update Kubernetes Deployment') {
            steps {
                sh """
                    export KUBECONFIG=\$KUBE_CONFIG
                    kubectl set image deployment/myapp \
                        myapp=${IMAGE_NAME}:${BUILD_NUMBER} \
                        --record
                    kubectl rollout status deployment/myapp
                """
            }
        }
        
        stage('Smoke Tests') {
            steps {
                sh """
                    export APP_URL=\$(kubectl get svc myapp -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
                    curl -f http://\$APP_URL/health || exit 1
                """
            }
        }
    }
    
    post {
        failure {
            sh """
                export KUBECONFIG=\$KUBE_CONFIG
                kubectl rollout undo deployment/myapp
            """
        }
    }
}
```

---

## Gestion des Credentials

### Types de Credentials

Jenkins supporte plusieurs types de credentials :

1. **Username with password** : Identifiants classiques
2. **SSH Username with private key** : Pour Git SSH
3. **Secret text** : Tokens, API keys
4. **Secret file** : Fichiers de configuration
5. **Certificate** : Certificats SSL/TLS

### Ajouter des Credentials

**Via l'interface :**
1. Dashboard → Manage Jenkins → Credentials
2. Stores scoped to Jenkins → System → Global credentials
3. Add Credentials

**Via Groovy Script :**

```groovy
import jenkins.model.Jenkins
import com.cloudbees.plugins.credentials.domains.Domain
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import com.cloudbees.plugins.credentials.CredentialsScope

def jenkins = Jenkins.getInstance()
def domain = Domain.global()
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

def credentials = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "my-credentials-id",
    "Description",
    "username",
    "password"
)

store.addCredentials(domain, credentials)
jenkins.save()
```

### Utiliser les Credentials dans un Pipeline

```groovy
pipeline {
    agent any
    
    environment {
        // Credentials comme variable d'environnement
        DOCKER_CREDS = credentials('dockerhub-credentials')
    }
    
    stages {
        stage('Example 1: Environment variable') {
            steps {
                sh '''
                    echo "Username: $DOCKER_CREDS_USR"
                    echo "Password: $DOCKER_CREDS_PSW"
                    docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW
                '''
            }
        }
        
        stage('Example 2: withCredentials') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-credentials',
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PASS'
                    )
                ]) {
                    sh 'git clone https://$GIT_USER:$GIT_PASS@github.com/user/repo.git'
                }
            }
        }
        
        stage('Example 3: SSH Key') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ssh-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh 'ssh -i $SSH_KEY $SSH_USER@server.com "ls -la"'
                }
            }
        }
        
        stage('Example 4: Secret Text') {
            steps {
                withCredentials([
                    string(credentialsId: 'api-token', variable: 'API_TOKEN')
                ]) {
                    sh 'curl -H "Authorization: Bearer $API_TOKEN" https://api.example.com'
                }
            }
        }
        
        stage('Example 5: Secret File') {
            steps {
                withCredentials([
                    file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')
                ]) {
                    sh 'kubectl --kubeconfig=$KUBECONFIG get pods'
                }
            }
        }
        
        stage('Example 6: Multiple Credentials') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'db-creds', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS'),
                    string(credentialsId: 'api-key', variable: 'API_KEY'),
                    file(credentialsId: 'config-file', variable: 'CONFIG')
                ]) {
                    sh '''
                        echo "Connecting to database..."
                        mysql -u $DB_USER -p$DB_PASS < schema.sql
                        
                        echo "Calling API..."
                        curl -H "X-API-Key: $API_KEY" https://api.example.com
                        
                        echo "Using config file..."
                        cp $CONFIG /etc/app/config.yaml
                    '''
                }
            }
        }
    }
}
```

---

## Jenkins Agents (Nodes)

### Configuration d'un Agent SSH

**Master Configuration :**
1. Manage Jenkins → Manage Nodes and Clouds → New Node
2. Remplir les informations :
   - **Name** : agent-linux-1
   - **Remote root directory** : /home/jenkins
   - **Launch method** : Launch agents via SSH
   - **Host** : IP ou hostname de l'agent
   - **Credentials** : SSH credentials

**Agent Setup (Linux) :**

```bash
# Créer l'utilisateur jenkins
sudo useradd -m -s /bin/bash jenkins

# Installer Java
sudo apt update
sudo apt install -y openjdk-17-jdk

# Créer le répertoire de travail
sudo mkdir -p /home/jenkins/workspace
sudo chown -R jenkins:jenkins /home/jenkins

# Configurer SSH
sudo -u jenkins mkdir -p /home/jenkins/.ssh
sudo -u jenkins chmod 700 /home/jenkins/.ssh

# Copier la clé publique du master
echo "ssh-rsa AAAA... jenkins@master" | sudo tee -a /home/jenkins/.ssh/authorized_keys
sudo -u jenkins chmod 600 /home/jenkins/.ssh/authorized_keys
```

### Agent Docker

```groovy
pipeline {
    agent {
        docker {
            image 'maven:3.8.6-openjdk-17'
            args '-v $HOME/.m2:/root/.m2'
            // Ou avec un Dockerfile personnalisé
            // dockerfile true
            // dir 'docker'
        }
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

### Agent Kubernetes

```groovy
pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: agent
spec:
  containers:
  - name: maven
    image: maven:3.8.6-openjdk-17
    command:
    - cat
    tty: true
    volumeMounts:
    - name: maven-cache
      mountPath: /root/.m2
  - name: docker
    image: docker:24-dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
  volumes:
  - name: maven-cache
    emptyDir: {}
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
"""
        }
    }
    
    stages {
        stage('Build with Maven') {
            steps {
                container('maven') {
                    sh 'mvn clean package'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh 'docker build -t myapp:${BUILD_NUMBER} .'
                }
            }
        }
    }
}
```

---

## Blue Ocean

Blue Ocean est une interface moderne pour Jenkins qui offre une expérience utilisateur améliorée.

### Installation

1. Dashboard → Manage Jenkins → Plugins
2. Rechercher "Blue Ocean"
3. Installer et redémarrer

### Accès

- URL : `http://jenkins-url/blue`
- Ou cliquer sur "Open Blue Ocean" dans le menu latéral

### Fonctionnalités

- 🎨 **Interface moderne** : Design épuré et intuitif
- 📊 **Visualisation claire** : Vue graphique des pipelines
- 🔍 **Analyse facile** : Logs structurés par étape
- ✏️ **Éditeur visuel** : Création de pipelines sans code
- 🌿 **Support multi-branches** : Gestion simplifiée des branches

### Exemple d'utilisation

```groovy
// Blue Ocean optimise l'affichage de ce pipeline
pipeline {
    agent any
    
    stages {
        stage('Build') {
            parallel {
                stage('Linux Build') {
                    steps {
                        echo 'Building on Linux'
                    }
                }
                stage('Windows Build') {
                    steps {
                        echo 'Building on Windows'
                    }
                }
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing'
            }
        }
        
        stage('Deploy') {
            input {
                message 'Deploy to production?'
            }
            steps {
                echo 'Deploying'
            }
        }
    }
}
```

---

## Configuration as Code (JCasC)

Jenkins Configuration as Code permet de configurer Jenkins via YAML au lieu de l'interface graphique.

### Installation du Plugin

1. Manage Jenkins → Plugins
2. Rechercher "Configuration as Code"
3. Installer

### Fichier de Configuration

Créer `/var/lib/jenkins/jenkins.yaml` :

```yaml
jenkins:
  systemMessage: "Jenkins configuré via JCasC"
  numExecutors: 5
  mode: NORMAL
  
  securityRealm:
    local:
      allowsSignup: false
      users:
       - id: "admin"
         password: "${JENKINS_ADMIN_PASSWORD}"
       - id: "developer"
         password: "${JENKINS_DEV_PASSWORD}"
  
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
        - "Job/Build:developer"
        - "Job/Read:developer"
  
  crumbIssuer:
    standard:
      excludeClientIPFromCrumb: false

credentials:
  system:
    domainCredentials:
      - credentials:
          - usernamePassword:
              scope: GLOBAL
              id: "dockerhub-credentials"
              username: "${DOCKER_USERNAME}"
              password: "${DOCKER_PASSWORD}"
              description: "Docker Hub credentials"
          - string:
              scope: GLOBAL
              id: "github-token"
              secret: "${GITHUB_TOKEN}"
              description: "GitHub API Token"

unclassified:
  location:
    url: "https://jenkins.example.com"
    adminAddress: "admin@example.com"
  
  slackNotifier:
    teamDomain: "myteam"
    tokenCredentialId: "slack-token"
    botUser: true
  
  gitHubPluginConfig:
    configs:
      - name: "GitHub"
        apiUrl: "https://api.github.com"
        credentialsId: "github-token"

tool:
  git:
    installations:
      - name: "Default"
        home: "/usr/bin/git"
  
  maven:
    installations:
      - name: "Maven 3.8"
        properties:
          - installSource:
              installers:
                - maven:
                    id: "3.8.6"
  
  jdk:
    installations:
      - name: "Java 17"
        properties:
          - installSource:
              installers:
                - jdkInstaller:
                    id: "jdk-17.0.5"

jobs:
  - script: >
      pipelineJob('example-pipeline') {
        definition {
          cpsScm {
            scm {
              git {
                remote {
                  url('https://github.com/example/repo.git')
                  credentials('github-token')
                }
                branch('*/main')
              }
            }
            scriptPath('Jenkinsfile')
          }
        }
      }
```

### Variables d'Environnement

```bash
# Définir les variables avant de démarrer Jenkins
export JENKINS_ADMIN_PASSWORD="admin123"
export JENKINS_DEV_PASSWORD="dev123"
export DOCKER_USERNAME="myuser"
export DOCKER_PASSWORD="mypassword"
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxx"
export CASC_JENKINS_CONFIG="/var/lib/jenkins/jenkins.yaml"
```

### Appliquer la Configuration

1. Via l'interface : Manage Jenkins → Configuration as Code → Reload existing configuration
2. Via l'API :
```bash
curl -X POST http://jenkins-url/configuration-as-code/reload \
  --user admin:token
```

---

## Intégrations

### GitHub

#### Configuration

1. **Installer le plugin GitHub**
2. **Créer un Personal Access Token sur GitHub**
   - Settings → Developer settings → Personal access tokens
   - Permissions : `repo`, `admin:repo_hook`

3. **Configurer dans Jenkins**
   - Manage Jenkins → System → GitHub
   - Add GitHub Server
   - Credentials : Secret text (le token)

#### Webhook

```bash
# URL du webhook Jenkins
https://jenkins.example.com/github-webhook/
```

Dans GitHub :
- Settings → Webhooks → Add webhook
- Payload URL : URL ci-dessus
- Content type : application/json
- Events : Push, Pull requests

#### Jenkinsfile avec GitHub

```groovy
pipeline {
    agent any
    
    environment {
        GITHUB_TOKEN = credentials('github-token')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/user/repo.git',
                        credentialsId: 'github-token'
                    ]]
                ])
            }
        }
        
        stage('Update Status') {
            steps {
                // Mise à jour du statut du commit
                githubNotify(
                    status: 'PENDING',
                    description: 'Build en cours',
                    context: 'continuous-integration/jenkins'
                )
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm install && npm run build'
            }
        }
    }
    
    post {
        success {
            githubNotify(
                status: 'SUCCESS',
                description: 'Build réussi',
                context: 'continuous-integration/jenkins'
            )
        }
        failure {
            githubNotify(
                status: 'FAILURE',
                description: 'Build échoué',
                context: 'continuous-integration/jenkins'
            )
        }
    }
}
```

### Docker

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'registry.example.com'
        IMAGE_NAME = 'myapp'
        DOCKER_CREDS = credentials('docker-credentials')
    }
    
    stages {
        stage('Build Image') {
            steps {
                script {
                    // Méthode 1 : Docker plugin
                    def customImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    
                    // Méthode 2 : Shell
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
        
        stage('Test Image') {
            steps {
                script {
                    // Lancer un conteneur pour tester
                    docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").inside {
                        sh 'npm test'
                    }
                }
            }
        }
        
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials') {
                        def image = docker.image("${IMAGE_NAME}:${BUILD_NUMBER}")
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                sh """
                    docker rmi ${IMAGE_NAME}:${BUILD_NUMBER}
                    docker system prune -f
                """
            }
        }
    }
}
```

### Kubernetes

```groovy
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true
  - name: helm
    image: alpine/helm:latest
    command:
    - cat
    tty: true
'''
        }
    }
    
    environment {
        KUBE_NAMESPACE = 'production'
        APP_NAME = 'myapp'
    }
    
    stages {
        stage('Deploy with kubectl') {
            steps {
                container('kubectl') {
                    withKubeConfig([credentialsId: 'kubeconfig']) {
                        sh """
                            kubectl set image deployment/${APP_NAME} \
                                ${APP_NAME}=myregistry/myapp:${BUILD_NUMBER} \
                                -n ${KUBE_NAMESPACE}
                            kubectl rollout status deployment/${APP_NAME} -n ${KUBE_NAMESPACE}
                        """
                    }
                }
            }
        }
        
        stage('Deploy with Helm') {
            steps {
                container('helm') {
                    withKubeConfig([credentialsId: 'kubeconfig']) {
                        sh """
                            helm upgrade --install ${APP_NAME} ./helm-chart \
                                --namespace ${KUBE_NAMESPACE} \
                                --set image.tag=${BUILD_NUMBER} \
                                --wait
                        """
                    }
                }
            }
        }
    }
}
```

### Slack

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                // Notification de début
                slackSend(
                    color: '#0000FF',
                    message: "🚀 Build démarré: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir les détails>"
                )
                
                sh 'npm run build'
            }
        }
    }
    
    post {
        success {
            slackSend(
                color: 'good',
                message: "✅ Build réussi: ${env.JOB_NAME} #${env.BUILD_NUMBER}\nDurée: ${currentBuild.durationString}\n<${env.BUILD_URL}|Voir les détails>"
            )
        }
        failure {
            slackSend(
                color: 'danger',
                message: "❌ Build échoué: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n<${env.BUILD_URL}console|Voir les logs>"
            )
        }
        unstable {
            slackSend(
                color: 'warning',
                message: "⚠️ Build instable: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
            )
        }
    }
}
```

---

## Shared Libraries

Les Shared Libraries permettent de réutiliser du code Groovy entre plusieurs pipelines.

### Structure

```
jenkins-shared-library/
├── vars/
│   ├── buildDockerImage.groovy
│   ├── deployToK8s.groovy
│   └── notifySlack.groovy
├── src/
│   └── org/
│       └── mycompany/
│           └── Utils.groovy
└── resources/
    └── templates/
        └── Dockerfile.template
```

### Configuration

1. **Manage Jenkins → System → Global Pipeline Libraries**
2. **Add** :
   - Name : `my-shared-library`
   - Default version : `main`
   - Retrieval method : Modern SCM → Git
   - Project Repository : URL du repo Git

### Exemple de Shared Library

**vars/buildDockerImage.groovy :**
```groovy
def call(Map config) {
    def imageName = config.imageName ?: 'myapp'
    def tag = config.tag ?: env.BUILD_NUMBER
    def registry = config.registry ?: 'docker.io'
    def dockerfile = config.dockerfile ?: 'Dockerfile'
    
    script {
        def image = docker.build("${registry}/${imageName}:${tag}", "-f ${dockerfile} .")
        
        if (config.push) {
            docker.withRegistry("https://${registry}", config.credentials) {
                image.push()
                if (config.pushLatest) {
                    image.push('latest')
                }
            }
        }
        
        return image
    }
}
```

**vars/deployToK8s.groovy :**
```groovy
def call(Map config) {
    def namespace = config.namespace ?: 'default'
    def deployment = config.deployment
    def image = config.image
    def kubeconfig = config.kubeconfig ?: 'kubeconfig'
    
    withKubeConfig([credentialsId: kubeconfig]) {
        sh """
            kubectl set image deployment/${deployment} \
                ${deployment}=${image} \
                -n ${namespace}
            kubectl rollout status deployment/${deployment} -n ${namespace}
        """
    }
}
```

**vars/notifySlack.groovy :**
```groovy
def call(String message, String color = 'good') {
    slackSend(
        color: color,
        message: "${message}\nJob: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n<${env.BUILD_URL}|Voir les détails>"
    )
}
```

**src/org/mycompany/Utils.groovy :**
```groovy
package org.mycompany

class Utils {
    static String getGitCommitHash() {
        return 'git rev-parse --short HEAD'.execute().text.trim()
    }
    
    static String getGitBranch() {
        return 'git rev-parse --abbrev-ref HEAD'.execute().text.trim()
    }
    
    static boolean isMainBranch() {
        return getGitBranch() in ['main', 'master']
    }
}
```

### Utilisation dans un Pipeline

```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    // Utilisation des fonctions de la shared library
                    def image = buildDockerImage(
                        imageName: 'myapp',
                        tag: env.BUILD_NUMBER,
                        registry: 'registry.example.com',
                        push: true,
                        pushLatest: true,
                        credentials: 'docker-credentials'
                    )
                    
                    // Utilisation de la classe Utils
                    def gitHash = org.mycompany.Utils.getGitCommitHash()
                    echo "Git commit: ${gitHash}"
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression {
                    return org.mycompany.Utils.isMainBranch()
                }
            }
            steps {
                script {
                    deployToK8s(
                        namespace: 'production',
                        deployment: 'myapp',
                        image: "registry.example.com/myapp:${env.BUILD_NUMBER}",
                        kubeconfig: 'kubeconfig-prod'
                    )
                }
            }
        }
    }
    
    post {
        success {
            script {
                notifySlack("✅ Déploiement réussi", "good")
            }
        }
        failure {
            script {
                notifySlack("❌ Déploiement échoué", "danger")
            }
        }
    }
}
```

---

## Bonnes Pratiques

### 1. Structure du Jenkinsfile

```groovy
// ✅ Bon : Structure claire et organisée
pipeline {
    agent any
    
    // Variables au début
    environment {
        APP_NAME = 'myapp'
        VERSION = "${env.BUILD_NUMBER}"
    }
    
    // Options de configuration
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
        timeout(time: 1, unit: 'HOURS')
    }
    
    // Stages logiques et séquentiels
    stages {
        stage('Checkout') { /* ... */ }
        stage('Build') { /* ... */ }
        stage('Test') { /* ... */ }
        stage('Deploy') { /* ... */ }
    }
    
    // Gestion des post-actions
    post {
        always { cleanWs() }
        success { /* ... */ }
        failure { /* ... */ }
    }
}
```

### 2. Gestion des Secrets

```groovy
// ❌ Mauvais : Secrets en dur
pipeline {
    stages {
        stage('Deploy') {
            steps {
                sh 'docker login -u admin -p password123'
            }
        }
    }
}

// ✅ Bon : Utilisation de credentials
pipeline {
    stages {
        stage('Deploy') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-creds',
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )
                ]) {
                    sh 'docker login -u $USER -p $PASS'
                }
            }
        }
    }
}
```

### 3. Utiliser des Agents Spécifiques

```groovy
// ✅ Bon : Agents adaptés par stage
pipeline {
    agent none
    
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:18'
                }
            }
            steps {
                sh 'npm install && npm run build'
            }
        }
        
        stage('Test E2E') {
            agent {
                docker {
                    image 'cypress/base:18'
                }
            }
            steps {
                sh 'npm run test:e2e'
            }
        }
    }
}
```

### 4. Parallélisation

```groovy
// ✅ Bon : Tests en parallèle
pipeline {
    agent any
    
    stages {
        stage('Tests') {
            parallel {
                stage('Unit Tests') {
                    steps { sh 'npm run test:unit' }
                }
                stage('Integration Tests') {
                    steps { sh 'npm run test:integration' }
                }
                stage('Lint') {
                    steps { sh 'npm run lint' }
                }
            }
        }
    }
}
```

### 5. Gestion des Erreurs

```groovy
// ✅ Bon : Gestion appropriée des erreurs
pipeline {
    agent any
    
    stages {
        stage('Tests') {
            steps {
                script {
                    try {
                        sh 'npm test'
                    } catch (Exception e) {
                        currentBuild.result = 'UNSTABLE'
                        echo "Tests échoués mais le build continue: ${e.message}"
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression { currentBuild.result != 'UNSTABLE' }
            }
            steps {
                sh './deploy.sh'
            }
        }
    }
}
```

### 6. Nettoyage du Workspace

```groovy
// ✅ Bon : Toujours nettoyer
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
    }
    
    post {
        always {
            cleanWs()  // Nettoie le workspace
        }
    }
}
```

### 7. Versioning et Tags

```groovy
// ✅ Bon : Versioning sémantique
pipeline {
    agent any
    
    environment {
        VERSION = sh(
            script: "git describe --tags --always",
            returnStdout: true
        ).trim()
    }
    
    stages {
        stage('Build') {
            steps {
                sh "docker build -t myapp:${VERSION} ."
                sh "docker tag myapp:${VERSION} myapp:latest"
            }
        }
    }
}
```

### 8. Documentation du Pipeline

```groovy
// ✅ Bon : Pipeline bien documenté
/**
 * Pipeline de déploiement pour l'application MyApp
 * 
 * Ce pipeline effectue les étapes suivantes :
 * 1. Checkout du code
 * 2. Build de l'application
 * 3. Tests unitaires et d'intégration
 * 4. Build de l'image Docker
 * 5. Déploiement sur Kubernetes
 * 
 * Variables requises :
 * - DOCKER_REGISTRY : URL du registry Docker
 * - KUBE_NAMESPACE : Namespace Kubernetes cible
 * 
 * Credentials requis :
 * - docker-credentials : Accès au registry
 * - kubeconfig : Config Kubernetes
 */
pipeline {
    agent any
    
    stages {
        // ...
    }
}
```

### 9. Timeouts

```groovy
// ✅ Bon : Timeouts appropriés
pipeline {
    agent any
    
    options {
        timeout(time: 1, unit: 'HOURS')  // Timeout global
    }
    
    stages {
        stage('Tests') {
            options {
                timeout(time: 30, unit: 'MINUTES')  // Timeout par stage
            }
            steps {
                sh 'npm test'
            }
        }
    }
}
```

### 10. Retry sur Échec

```groovy
// ✅ Bon : Retry pour opérations instables
pipeline {
    agent any
    
    stages {
        stage('Deploy') {
            steps {
                retry(3) {
                    sh './deploy.sh'
                }
            }
        }
        
        stage('Tests E2E') {
            options {
                retry(2)
            }
            steps {
                sh 'npm run test:e2e'
            }
        }
    }
}
```

---

## Sécurité

### 1. Utilisateurs et Permissions

**Stratégies d'autorisation :**

```groovy
// Configuration via JCasC
jenkins:
  authorizationStrategy:
    globalMatrix:
      permissions:
        # Administrateurs
        - "Overall/Administer:admin"
        - "Overall/Read:admin"
        
        # Développeurs
        - "Overall/Read:authenticated"
        - "Job/Build:developers"
        - "Job/Read:developers"
        - "Job/Cancel:developers"
        
        # Lecture seule
        - "Overall/Read:viewers"
        - "Job/Read:viewers"
```

### 2. CSRF Protection

Toujours activer la protection CSRF :
- Manage Jenkins → Security → Prevent Cross Site Request Forgery exploits

### 3. Script Security

```groovy
// ❌ Mauvais : Script non approuvé
@NonCPS
def dangerousMethod() {
    // Code non sécurisé
}

// ✅ Bon : Utiliser les méthodes approuvées
pipeline {
    agent any
    stages {
        stage('Safe Operations') {
            steps {
                // Méthodes sécurisées approuvées
                sh 'echo "Hello"'
                echo 'World'
            }
        }
    }
}
```

### 4. Audit Logging

Activer l'audit des actions :
- Installer le plugin "Audit Trail"
- Manage Jenkins → System → Audit Trail

```groovy
// Configuration JCasC
unclassified:
  auditTrail:
    loggers:
      - logFile:
          log: /var/log/jenkins/audit.log
          limit: 10
          count: 5
```

### 5. Sécurité des Agents

```groovy
// ✅ Bon : Agents avec restrictions
pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsUser: 1000
    runAsNonRoot: true
    fsGroup: 1000
  containers:
  - name: maven
    image: maven:3.8.6
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
"""
        }
    }
}
```

---

## Monitoring et Maintenance

### 1. Monitoring de Jenkins

#### Prometheus Metrics

```bash
# Installer le plugin Prometheus
# Manage Jenkins → Plugins → Prometheus metrics

# Métriques disponibles sur
http://jenkins-url/prometheus/
```

#### Exemple de configuration Prometheus

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'jenkins'
    metrics_path: '/prometheus/'
    static_configs:
      - targets: ['jenkins.example.com:8080']
```

### 2. Backup Jenkins

```bash
#!/bin/bash
# Script de backup Jenkins

JENKINS_HOME="/var/lib/jenkins"
BACKUP_DIR="/backups/jenkins"
DATE=$(date +%Y%m%d_%H%M%S)

# Créer le répertoire de backup
mkdir -p $BACKUP_DIR

# Backup des fichiers importants
tar -czf $BACKUP_DIR/jenkins_backup_$DATE.tar.gz \
    $JENKINS_HOME/config.xml \
    $JENKINS_HOME/jobs \
    $JENKINS_HOME/users \
    $JENKINS_HOME/plugins \
    $JENKINS_HOME/secrets \
    $JENKINS_HOME/credentials.xml

# Garder seulement les 7 derniers backups
find $BACKUP_DIR -name "jenkins_backup_*.tar.gz" -mtime +7 -delete

echo "Backup terminé: $BACKUP_DIR/jenkins_backup_$DATE.tar.gz"
```

### 3. Nettoyage Automatique

```groovy
// Pipeline de nettoyage (à planifier quotidiennement)
pipeline {
    agent any
    
    triggers {
        cron('0 2 * * *')  // Tous les jours à 2h
    }
    
    stages {
        stage('Cleanup Old Builds') {
            steps {
                script {
                    // Nettoyer les vieux builds
                    Jenkins.instance.getAllItems(Job.class).each { job ->
                        job.builds.findAll { build ->
                            build.number < (job.lastSuccessfulBuild?.number ?: 0) - 10
                        }.each { build ->
                            build.delete()
                        }
                    }
                }
            }
        }
        
        stage('Cleanup Workspaces') {
            steps {
                cleanWs()
                sh '''
                    # Nettoyer les workspaces inutilisés
                    find /var/lib/jenkins/workspace -type d -mtime +30 -exec rm -rf {} +
                '''
            }
        }
    }
}
```

### 4. Health Checks

```groovy
// Pipeline de health check
pipeline {
    agent any
    
    triggers {
        cron('*/15 * * * *')  // Toutes les 15 minutes
    }
    
    stages {
        stage('Check Jenkins Health') {
            steps {
                script {
                    def jenkins = Jenkins.instance
                    
                    // Vérifier l'espace disque
                    def freeSpace = jenkins.getRootPath().diskUsage.available
                    if (freeSpace < 5 * 1024 * 1024 * 1024) {  // < 5GB
                        error "Espace disque faible: ${freeSpace / 1024 / 1024 / 1024}GB"
                    }
                    
                    // Vérifier les agents
                    def offlineNodes = jenkins.nodes.findAll { !it.computer.online }
                    if (!offlineNodes.isEmpty()) {
                        echo "Agents hors ligne: ${offlineNodes.collect { it.name }}"
                    }
                    
                    // Vérifier les jobs échoués
                    def failedJobs = jenkins.getAllItems(Job.class).findAll {
                        it.lastBuild?.result == Result.FAILURE
                    }
                    echo "Jobs échoués: ${failedJobs.size()}"
                }
            }
        }
    }
}
```

---

## Dépannage

### Problèmes Courants

#### 1. "Waiting for next available executor"

**Cause :** Pas d'agents disponibles

**Solution :**
```groovy
// Vérifier les agents
Jenkins.instance.computers.each {
    println("${it.name}: ${it.online ? 'online' : 'offline'}")
}

// Ou augmenter le nombre d'executors
pipeline {
    agent {
        label 'any'
    }
}
```

#### 2. "java.lang.OutOfMemoryError"

**Cause :** Mémoire insuffisante

**Solution :**
```bash
# Augmenter la mémoire Java
# Dans /etc/default/jenkins (Linux)
JAVA_ARGS="-Xmx4g -XX:MaxPermSize=512m"

# Ou dans la ligne de commande
java -Xmx4g -jar jenkins.war
```

#### 3. Credentials non trouvés

**Cause :** Mauvais credentialsId ou scope

**Solution :**
```groovy
// Lister tous les credentials
import com.cloudbees.plugins.credentials.CredentialsProvider

def creds = CredentialsProvider.lookupCredentials(
    com.cloudbees.plugins.credentials.Credentials.class
)

creds.each {
    println("ID: ${it.id}, Description: ${it.description}")
}
```

#### 4. Pipeline bloqué

**Cause :** Input step ou problème de concurrence

**Solution :**
```groovy
// Ajouter un timeout
pipeline {
    options {
        timeout(time: 1, unit: 'HOURS')
    }
    
    stages {
        stage('Approval') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: 'Approve?'
                }
            }
        }
    }
}
```

### Logs et Debug

```groovy
// Activer le debug
pipeline {
    agent any
    
    options {
        // Logs détaillés
        timestamps()
    }
    
    stages {
        stage('Debug') {
            steps {
                script {
                    // Afficher toutes les variables d'environnement
                    sh 'env | sort'
                    
                    // Afficher les propriétés du build
                    echo "Build Number: ${env.BUILD_NUMBER}"
                    echo "Job Name: ${env.JOB_NAME}"
                    echo "Workspace: ${env.WORKSPACE}"
                    
                    // Afficher les credentials (masqués)
                    withCredentials([string(credentialsId: 'my-secret', variable: 'SECRET')]) {
                        echo "Secret length: ${SECRET.length()}"  // Ne pas afficher le secret
                    }
                }
            }
        }
    }
}
```

---

## Ressources

### Documentation Officielle
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Plugins](https://plugins.jenkins.io/)
- [Jenkins User Handbook](https://www.jenkins.io/doc/book/)

### Guides et Tutoriels
- [Pipeline Examples](https://www.jenkins.io/doc/pipeline/examples/)
- [Best Practices](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/)
- [Groovy Syntax](http://groovy-lang.org/documentation.html)

### Communauté
- [Jenkins Community](https://www.jenkins.io/participate/)
- [Stack Overflow - Jenkins](https://stackoverflow.com/questions/tagged/jenkins)
- [Jenkins Users Mailing List](https://www.jenkins.io/mailing-lists/)
- [GitHub - Jenkins](https://github.com/jenkinsci/jenkins)

### Plugins Populaires
- [Blue Ocean](https://plugins.jenkins.io/blueocean/)
- [Docker Plugin](https://plugins.jenkins.io/docker-plugin/)
- [Kubernetes Plugin](https://plugins.jenkins.io/kubernetes/)
- [Configuration as Code](https://plugins.jenkins.io/configuration-as-code/)

---

## Conclusion

Jenkins est un outil CI/CD puissant et flexible qui s'adapte à presque tous les workflows de développement. Avec sa grande communauté, son écosystème riche de plugins et sa capacité à s'intégrer avec pratiquement tous les outils DevOps, Jenkins reste un choix solide pour l'automatisation de vos pipelines.

**Points clés à retenir :**
- ✅ Utilisez les pipelines déclaratifs pour plus de clarté
- ✅ Gérez vos secrets avec le système de credentials
- ✅ Exploitez les shared libraries pour la réutilisation de code
- ✅ Configurez Jenkins as Code (JCasC) pour la portabilité
- ✅ Surveillez et maintenez régulièrement votre instance
- ✅ Suivez les bonnes pratiques de sécurité

**Prochaines étapes :**
1. Installer Jenkins et configurer votre premier pipeline
2. Explorer Blue Ocean pour une meilleure visualisation
3. Créer des shared libraries pour votre organisation
4. Mettre en place la configuration as code
5. Intégrer avec vos outils existants (Git, Docker, K8s)
