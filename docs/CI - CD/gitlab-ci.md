# CI/CD (Continuous Integration / Continuous Deployment)

## Introduction

Le CI/CD est une approche DevOps qui permet d'automatiser les phases de développement logiciel, depuis l'intégration du code jusqu'au déploiement en production. Cette pratique améliore la qualité du code, accélère les cycles de livraison et réduit les risques liés aux déploiements.

### Principaux avantages

- **Détection précoce des bugs** : Les tests automatisés identifient les problèmes dès l'intégration du code
- **Déploiements fiables** : Processus standardisés et reproductibles
- **Réduction du temps de mise sur le marché** : Automatisation des tâches répétitives
- **Feedback rapide** : Les développeurs sont informés immédiatement des problèmes
- **Traçabilité** : Historique complet des déploiements et modifications

---

## GitLab CI

GitLab CI/CD est la solution d'intégration et de déploiement continus intégrée nativement à GitLab. Elle permet d'automatiser l'ensemble du pipeline de développement via un fichier de configuration `.gitlab-ci.yml` placé à la racine du projet.

### Architecture

GitLab CI/CD fonctionne avec trois composants principaux :

1. **GitLab Server** : Gère les pipelines et coordonne l'exécution
2. **GitLab Runner** : Exécute les jobs définis dans le pipeline
3. **`.gitlab-ci.yml`** : Fichier de configuration définissant le pipeline

### Configuration de base

#### Structure du fichier `.gitlab-ci.yml`

```yaml
# Définition des stages (étapes du pipeline)
stages:
  - build
  - test
  - deploy

# Variables globales
variables:
  DOCKER_DRIVER: overlay2
  APP_NAME: "mon-application"

# Job de build
build-job:
  stage: build
  script:
    - echo "Compilation de l'application..."
    - npm install
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 hour

# Job de tests unitaires
test-unit:
  stage: test
  script:
    - echo "Exécution des tests unitaires..."
    - npm run test:unit
  coverage: '/Coverage: \d+\.\d+%/'

# Job de tests d'intégration
test-integration:
  stage: test
  script:
    - echo "Exécution des tests d'intégration..."
    - npm run test:integration

# Job de déploiement
deploy-production:
  stage: deploy
  script:
    - echo "Déploiement en production..."
    - ./deploy.sh
  only:
    - main
  when: manual
```

### Concepts clés

#### Stages (Étapes)

Les stages définissent l'ordre d'exécution des jobs. Les jobs d'un même stage s'exécutent en parallèle.

```yaml
stages:
  - build      # Construction de l'application
  - test       # Exécution des tests
  - deploy     # Déploiement
  - cleanup    # Nettoyage
```

#### Jobs

Un job est une tâche individuelle exécutée par un runner. Chaque job doit appartenir à un stage.

```yaml
nom-du-job:
  stage: test
  image: node:18
  script:
    - npm install
    - npm test
  tags:
    - docker
  only:
    - develop
    - main
```

#### Artifacts

Les artifacts permettent de partager des fichiers entre jobs ou de les télécharger après l'exécution.

```yaml
build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
      - coverage/
    expire_in: 1 week
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
```

#### Cache

Le cache accélère les pipelines en conservant les dépendances entre les exécutions.

```yaml
variables:
  npm_config_cache: "$CI_PROJECT_DIR/.npm"

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .npm/
    - node_modules/
```

#### Variables

GitLab CI offre des variables prédéfinies et permet de définir des variables personnalisées.

```yaml
variables:
  # Variables personnalisées
  DATABASE_URL: "postgresql://user:pass@localhost/db"
  ENVIRONMENT: "production"

deploy:
  script:
    - echo "Déploiement sur $ENVIRONMENT"
    - echo "URL du projet : $CI_PROJECT_URL"
    - echo "Commit SHA : $CI_COMMIT_SHA"
```

**Variables prédéfinies utiles :**
- `$CI_COMMIT_SHA` : Hash du commit
- `$CI_COMMIT_REF_NAME` : Nom de la branche ou du tag
- `$CI_PROJECT_DIR` : Répertoire du projet
- `$CI_PIPELINE_ID` : ID du pipeline
- `$CI_JOB_TOKEN` : Token pour authentification

### Exemple de pipeline complet

#### Application Node.js

```yaml
image: node:18

stages:
  - install
  - lint
  - test
  - build
  - deploy

# Cache pour accélérer les builds
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
    - .npm/

# Installation des dépendances
install:
  stage: install
  script:
    - npm ci --cache .npm --prefer-offline
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 day

# Vérification du code
lint:
  stage: lint
  script:
    - npm run lint
    - npm run format:check
  needs:
    - install

# Tests unitaires
test:unit:
  stage: test
  script:
    - npm run test:unit -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
      junit: junit.xml
  needs:
    - install

# Tests E2E
test:e2e:
  stage: test
  services:
    - postgres:14
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: test_user
    POSTGRES_PASSWORD: test_password
  script:
    - npm run test:e2e
  needs:
    - install

# Build de l'application
build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
  needs:
    - lint
    - test:unit
    - test:e2e

# Déploiement en staging (automatique)
deploy:staging:
  stage: deploy
  script:
    - echo "Déploiement en staging..."
    - npm run deploy:staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop
  needs:
    - build

# Déploiement en production (manuel)
deploy:production:
  stage: deploy
  script:
    - echo "Déploiement en production..."
    - npm run deploy:production
  environment:
    name: production
    url: https://example.com
  only:
    - main
  when: manual
  needs:
    - build
```

#### Application Docker

```yaml
stages:
  - build
  - test
  - release
  - deploy

variables:
  DOCKER_REGISTRY: registry.gitlab.com
  IMAGE_NAME: $CI_REGISTRY_IMAGE
  DOCKER_TLS_CERTDIR: "/certs"

services:
  - docker:24-dind

before_script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

# Build de l'image Docker
build:
  stage: build
  image: docker:24
  script:
    - docker build -t $IMAGE_NAME:$CI_COMMIT_SHA .
    - docker push $IMAGE_NAME:$CI_COMMIT_SHA
  tags:
    - docker

# Tests de sécurité avec Trivy
security-scan:
  stage: test
  image: aquasec/trivy:latest
  script:
    - trivy image --severity HIGH,CRITICAL $IMAGE_NAME:$CI_COMMIT_SHA
  allow_failure: true

# Tag de l'image pour la release
release:
  stage: release
  image: docker:24
  script:
    - docker pull $IMAGE_NAME:$CI_COMMIT_SHA
    - docker tag $IMAGE_NAME:$CI_COMMIT_SHA $IMAGE_NAME:latest
    - docker tag $IMAGE_NAME:$CI_COMMIT_SHA $IMAGE_NAME:$CI_COMMIT_REF_NAME
    - docker push $IMAGE_NAME:latest
    - docker push $IMAGE_NAME:$CI_COMMIT_REF_NAME
  only:
    - main
    - tags

# Déploiement Kubernetes
deploy:k8s:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context $KUBE_CONTEXT
    - kubectl set image deployment/app app=$IMAGE_NAME:$CI_COMMIT_SHA -n production
    - kubectl rollout status deployment/app -n production
  environment:
    name: production
    kubernetes:
      namespace: production
  only:
    - main
  when: manual
```

### GitLab Runner

#### Installation d'un Runner

**Sur Linux (Ubuntu/Debian) :**

```bash
# Ajout du dépôt officiel
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# Installation
sudo apt-get install gitlab-runner

# Enregistrement du runner
sudo gitlab-runner register
```

**Sur Docker :**

```bash
docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```

#### Configuration du Runner

```toml
# /etc/gitlab-runner/config.toml
concurrent = 4

[[runners]]
  name = "docker-runner"
  url = "https://gitlab.com/"
  token = "YOUR_RUNNER_TOKEN"
  executor = "docker"
  [runners.docker]
    image = "node:18"
    privileged = true
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
  [runners.cache]
    Type = "s3"
    Shared = true
```

#### Types d'executors

- **Shell** : Exécute les jobs directement sur la machine hôte
- **Docker** : Utilise des conteneurs Docker (recommandé)
- **Kubernetes** : Déploie les jobs sur un cluster Kubernetes
- **SSH** : Exécute les jobs sur une machine distante via SSH

### Bonnes pratiques

#### 1. Utiliser des images Docker spécifiques

```yaml
# ❌ Mauvais
image: node:latest

# ✅ Bon
image: node:18.17.0-alpine
```

#### 2. Optimiser le cache

```yaml
cache:
  key:
    files:
      - package-lock.json  # Cache invalidé si package-lock change
  paths:
    - node_modules/
  policy: pull-push  # pull pour les jobs, push uniquement pour install
```

#### 3. Utiliser des templates pour éviter la répétition

```yaml
.test-template:
  stage: test
  image: node:18
  before_script:
    - npm ci
  only:
    - merge_requests
    - main

test:unit:
  extends: .test-template
  script:
    - npm run test:unit

test:integration:
  extends: .test-template
  script:
    - npm run test:integration
```

#### 4. Sécuriser les variables sensibles

Utilisez les variables protégées et masquées dans les paramètres du projet GitLab :
- Settings → CI/CD → Variables
- Cochez "Protected" pour les branches protégées uniquement
- Cochez "Masked" pour masquer dans les logs

```yaml
deploy:
  script:
    - echo "Déploiement avec $SECRET_KEY"  # Sera masqué dans les logs
```

#### 5. Utiliser les environments pour le suivi des déploiements

```yaml
deploy:staging:
  environment:
    name: staging
    url: https://staging.example.com
    on_stop: stop:staging
    auto_stop_in: 1 week

stop:staging:
  stage: deploy
  script:
    - ./stop-staging.sh
  environment:
    name: staging
    action: stop
  when: manual
```

#### 6. Définir des règles d'exécution précises

```yaml
job:
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH == "main"'
    - if: '$CI_COMMIT_TAG'
    - changes:
        - src/**/*
        - package.json
```

#### 7. Paralléliser les tests

```yaml
test:
  stage: test
  parallel: 4
  script:
    - npm run test -- --shard=$CI_NODE_INDEX/$CI_NODE_TOTAL
```

### Debugging et dépannage

#### Activer le mode debug

```yaml
variables:
  CI_DEBUG_TRACE: "true"  # Affiche toutes les commandes exécutées
```

#### Tester localement avec gitlab-runner

```bash
# Exécution locale d'un job spécifique
gitlab-runner exec docker nom-du-job

# Avec des variables personnalisées
gitlab-runner exec docker --env "VAR=value" nom-du-job
```

#### Analyser les logs du runner

```bash
# Logs en temps réel
sudo gitlab-runner --debug run

# Vérifier le statut
sudo gitlab-runner status
```

### Intégrations utiles

#### Notifications Slack

```yaml
notify:slack:
  stage: .post
  script:
    - 'curl -X POST -H "Content-type: application/json" 
      --data "{\"text\":\"Pipeline $CI_PIPELINE_ID terminé avec le statut: $CI_JOB_STATUS\"}" 
      $SLACK_WEBHOOK_URL'
  when: on_failure
```

#### Merge Request Pipelines

```yaml
workflow:
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    - if: '$CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS'
      when: never
    - if: '$CI_COMMIT_BRANCH'
```

#### Code Quality Reports

```yaml
code_quality:
  stage: test
  image: docker:stable
  services:
    - docker:stable-dind
  script:
    - docker run --rm 
        --volume "$PWD":/code 
        --volume /var/run/docker.sock:/var/run/docker.sock 
        registry.gitlab.com/gitlab-org/ci-cd/codequality:latest /code
  artifacts:
    reports:
      codequality: gl-code-quality-report.json
```

### Ressources

- [Documentation officielle GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [GitLab CI/CD Examples](https://docs.gitlab.com/ee/ci/examples/)
- [GitLab Runner Documentation](https://docs.gitlab.com/runner/)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)

---

**Prochaines étapes :**
- Configuration avancée avec des includes et des templates
- Utilisation de GitLab Container Registry
- Mise en place de Review Apps
- Auto DevOps pour une automatisation complète
