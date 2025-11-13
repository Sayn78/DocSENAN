# 🔄 Shift Left - Bonnes Pratiques DevOps

## 📋 Table des Matières
- [Qu'est-ce que le Shift Left ?](#quest-ce-que-le-shift-left)
- [Principes fondamentaux](#principes-fondamentaux)
- [Pre-commit Hooks Git](#pre-commit-hooks-git)
- [Outils de qualité de code](#outils-de-qualité-de-code)
- [Tests automatisés](#tests-automatisés)
- [Sécurité (SAST)](#sécurité-sast)
- [Infrastructure as Code](#infrastructure-as-code)
- [Documentation automatique](#documentation-automatique)
- [Workflow complet](#workflow-complet)
- [Ressources](#ressources)

---

## Qu'est-ce que le Shift Left ?

### Définition

Le **Shift Left** est une approche DevOps qui consiste à déplacer les tests, la sécurité et le contrôle qualité **le plus tôt possible** dans le cycle de développement.

### Objectifs

```
Traditionnelle:  Développement → Tests → Sécurité → Production ❌
Shift Left:      Tests + Sécurité + Qualité dès le développement ✅
```

### Avantages

- 🚀 **Détection précoce des bugs** : Correction 10x moins coûteuse
- 🔒 **Sécurité intégrée** : Vulnérabilités détectées avant le commit
- 💰 **Réduction des coûts** : Moins de bugs en production
- ⚡ **Déploiements plus rapides** : Pipeline CI/CD plus fluide
- 👥 **Collaboration améliorée** : Standards partagés par l'équipe

---

## Principes fondamentaux

### 1. Automatisation

```yaml
# Tout doit être automatique
✅ Formatage du code
✅ Tests unitaires
✅ Analyse de sécurité
✅ Validation des commits
❌ Processus manuels
```

### 2. Feedback rapide

```
Idéal : < 5 secondes pour les checks locaux
Acceptable : < 2 minutes pour les tests complets
```

### 3. Fail Fast

```bash
# Bloquer le commit si erreurs
git commit → Pre-commit hooks → ❌ Échec → Correction
                              → ✅ Succès → Push
```

### 4. Standards d'équipe

```
Toute l'équipe utilise les mêmes :
- Hooks Git
- Formatters
- Linters
- Configuration
```

---

## Pre-commit Hooks Git

### Installation du framework pre-commit

```bash
# Installation
pip install pre-commit

# Vérification
pre-commit --version
```

### Configuration de base

**`.pre-commit-config.yaml`**
```yaml
# Voir https://pre-commit.com/hooks.html pour plus de hooks
repos:
  # Hooks génériques
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace       # Supprime espaces en fin de ligne
      - id: end-of-file-fixer        # Ajoute newline en fin de fichier
      - id: check-yaml                # Valide syntaxe YAML
      - id: check-json                # Valide syntaxe JSON
      - id: check-added-large-files  # Bloque fichiers > 500KB
        args: ['--maxkb=500']
      - id: check-merge-conflict     # Détecte marqueurs de conflit
      - id: detect-private-key       # Détecte clés privées
      - id: check-case-conflict      # Vérifie conflits de casse
      - id: mixed-line-ending        # Normalise fins de ligne

  # Secrets et sécurité
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']

  # Commitizen pour conventional commits
  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
```

### Installation dans le projet

```bash
# Créer le fichier de config
touch .pre-commit-config.yaml

# Installer les hooks
pre-commit install

# Installer pour commit-msg aussi
pre-commit install --hook-type commit-msg

# Tester sur tous les fichiers
pre-commit run --all-files
```

### Commandes utiles

```bash
# Lancer manuellement les hooks
pre-commit run --all-files

# Lancer un hook spécifique
pre-commit run trailing-whitespace

# Mettre à jour les versions des hooks
pre-commit autoupdate

# Désinstaller
pre-commit uninstall

# Bypass temporaire (à éviter !)
git commit --no-verify -m "message"
```

---

## Outils de qualité de code

### Python

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Black - Formatage automatique
  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black
        language_version: python3.11

  # isort - Tri des imports
  - repo: https://github.com/PyCQA/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: ["--profile", "black"]

  # Flake8 - Linting
  - repo: https://github.com/PyCQA/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
        args: ['--max-line-length=88', '--extend-ignore=E203']

  # Pylint - Analyse approfondie
  - repo: https://github.com/PyCQA/pylint
    rev: v3.0.3
    hooks:
      - id: pylint
        args: ['--disable=C0111,R0903']

  # MyPy - Type checking
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies: [types-requests]
```

**Configuration Black** - `pyproject.toml`
```toml
[tool.black]
line-length = 88
target-version = ['py311']
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.venv
  | build
  | dist
)/
'''
```

**Configuration isort** - `pyproject.toml`
```toml
[tool.isort]
profile = "black"
multi_line_output = 3
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true
ensure_newline_before_comments = true
line_length = 88
```

### JavaScript/TypeScript

**`.pre-commit-config.yaml`**
```yaml
repos:
  # ESLint
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.56.0
    hooks:
      - id: eslint
        files: \.(js|jsx|ts|tsx)$
        types: [file]
        additional_dependencies:
          - eslint@8.56.0
          - eslint-config-airbnb@19.0.4
          - eslint-plugin-react@7.33.2

  # Prettier
  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v3.1.0
    hooks:
      - id: prettier
        types_or: [javascript, jsx, ts, tsx, json, yaml, markdown]
```

**Configuration ESLint** - `.eslintrc.json`
```json
{
  "extends": ["airbnb", "prettier"],
  "plugins": ["react", "prettier"],
  "rules": {
    "prettier/prettier": "error",
    "no-console": "warn",
    "no-unused-vars": "error"
  },
  "env": {
    "browser": true,
    "node": true,
    "es6": true
  }
}
```

**Configuration Prettier** - `.prettierrc`
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

### Java

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Google Java Format
  - repo: https://github.com/macisamuele/language-formatters-pre-commit-hooks
    rev: v2.12.0
    hooks:
      - id: pretty-format-java
        args: [--autofix]

  # Checkstyle
  - repo: local
    hooks:
      - id: checkstyle
        name: checkstyle
        entry: bash -c 'java -jar checkstyle.jar -c google_checks.xml src/'
        language: system
        types: [java]
```

### Go

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Go format
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: v0.5.1
    hooks:
      - id: go-fmt
      - id: go-vet
      - id: go-imports
      - id: go-cyclo
        args: [-over=15]
      - id: golangci-lint
```

---

## Tests automatisés

### Configuration pour Python

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Pytest
  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: pytest
        language: system
        pass_filenames: false
        always_run: true
        args: ['-v', '--tb=short', '--cov=src', '--cov-fail-under=80']

  # Coverage
  - repo: local
    hooks:
      - id: coverage
        name: coverage
        entry: bash -c 'coverage run -m pytest && coverage report --fail-under=80'
        language: system
        pass_filenames: false
        always_run: true
```

### Configuration pour JavaScript

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Jest
  - repo: local
    hooks:
      - id: jest
        name: jest
        entry: npm test
        language: system
        pass_filenames: false
        always_run: true
```

### Tests seulement sur fichiers modifiés

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: local
    hooks:
      - id: pytest-quick
        name: pytest-quick
        entry: bash -c 'pytest --picked --testmon'
        language: system
        pass_filenames: false
        stages: [commit]
```

---

## Sécurité (SAST)

### Detect Secrets - Détection de secrets

**Installation et configuration**
```bash
# Installation
pip install detect-secrets

# Créer un baseline
detect-secrets scan > .secrets.baseline

# Scanner manuellement
detect-secrets scan --baseline .secrets.baseline
```

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
        exclude: package-lock.json
```

### Bandit - Analyse de sécurité Python

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.6
    hooks:
      - id: bandit
        args: ['-r', 'src/', '-f', 'json', '-o', 'bandit-report.json']
```

**Configuration** - `.bandit`
```yaml
exclude_dirs:
  - /tests/
  - /venv/

tests:
  - B201  # Flask debug mode
  - B301  # Pickle usage
  - B501  # Request with verify=False
```

### Semgrep - Analyse multi-langages

```bash
# Installation
pip install semgrep

# Scanner le code
semgrep --config=auto .
```

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/returntocorp/semgrep
    rev: v1.52.0
    hooks:
      - id: semgrep
        args: ['--config', 'auto', '--error']
```

### Trivy - Scan des dépendances

```bash
# Scanner les vulnérabilités
trivy fs --security-checks vuln,config .

# Scanner une image Docker
trivy image myimage:latest
```

### Gitleaks - Détection de fuites

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.1
    hooks:
      - id: gitleaks
```

**Configuration** - `.gitleaks.toml`
```toml
title = "Gitleaks Config"

[[rules]]
id = "aws-access-key"
description = "AWS Access Key"
regex = '''AKIA[0-9A-Z]{16}'''

[[rules]]
id = "github-token"
description = "GitHub Token"
regex = '''ghp_[0-9a-zA-Z]{36}'''
```

---

## Infrastructure as Code

### Terraform

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.86.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_docs
      - id: terraform_tflint
        args:
          - --args=--config=__GIT_WORKING_DIR__/.tflint.hcl
      - id: terraform_tfsec
      - id: terraform_checkov
```

**Configuration TFLint** - `.tflint.hcl`
```hcl
plugin "aws" {
  enabled = true
  version = "0.28.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_type" {
  enabled = true
}
```

### Ansible

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/ansible/ansible-lint
    rev: v6.22.1
    hooks:
      - id: ansible-lint
        files: \.(yaml|yml)$
```

### Dockerfile

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/hadolint/hadolint
    rev: v2.12.0
    hooks:
      - id: hadolint-docker
```

### Kubernetes

**`.pre-commit-config.yaml`**
```yaml
repos:
  - repo: https://github.com/gruntwork-io/pre-commit
    rev: v0.1.23
    hooks:
      - id: helmlint
      - id: kubeval
```

---

## Documentation automatique

### Conventional Commits

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Commitizen pour format standardisé
  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
```

**Format des commits**
```bash
# Types de commits
feat:     Nouvelle fonctionnalité
fix:      Correction de bug
docs:     Documentation
style:    Formatage (pas de changement de code)
refactor: Refactoring
test:     Ajout de tests
chore:    Maintenance

# Exemples
git commit -m "feat: ajout authentification OAuth2"
git commit -m "fix: correction calcul TVA"
git commit -m "docs: mise à jour README"
git commit -m "feat(api)!: changement breaking de l'endpoint users"
```

### Génération automatique de CHANGELOG

```bash
# Installation
pip install commitizen

# Générer le CHANGELOG
cz changelog

# Bump version et changelog
cz bump --changelog
```

### Documentation du code

**`.pre-commit-config.yaml`**
```yaml
repos:
  # Pydocstyle pour Python
  - repo: https://github.com/PyCQA/pydocstyle
    rev: 6.3.0
    hooks:
      - id: pydocstyle
        args: [--convention=google]
```

---

## Workflow complet

### 1. Configuration initiale du projet

```bash
# Créer le projet
mkdir mon-projet && cd mon-projet
git init

# Installer pre-commit
pip install pre-commit

# Créer la configuration
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: detect-private-key
  
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
  
  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
        stages: [commit-msg]
EOF

# Installer les hooks
pre-commit install
pre-commit install --hook-type commit-msg

# Créer baseline pour secrets
pip install detect-secrets
detect-secrets scan > .secrets.baseline

# Créer .gitignore
cat > .gitignore << EOF
# Python
venv/
__pycache__/
*.pyc
.pytest_cache/

# IDEs
.vscode/
.idea/

# Secrets
.env
*.pem
*.key
EOF
```

### 2. Configuration spécifique au langage

**Pour Python**
```bash
# Ajouter les hooks Python
cat >> .pre-commit-config.yaml << EOF
  - repo: https://github.com/psf/black
    rev: 23.12.1
    hooks:
      - id: black

  - repo: https://github.com/PyCQA/isort
    rev: 5.13.2
    hooks:
      - id: isort

  - repo: https://github.com/PyCQA/flake8
    rev: 7.0.0
    hooks:
      - id: flake8

  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.6
    hooks:
      - id: bandit
EOF

# Installer les outils
pip install black isort flake8 bandit pytest

# Créer pyproject.toml
cat > pyproject.toml << EOF
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 88

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
EOF
```

### 3. Workflow quotidien

```bash
# 1. Créer une branche
git checkout -b feature/nouvelle-fonctionnalite

# 2. Développer
# ... écrire du code ...

# 3. Lancer les checks manuellement (optionnel)
pre-commit run --all-files

# 4. Commit (hooks lancés automatiquement)
git add .
git commit -m "feat: ajout nouvelle fonctionnalité"
# → Les hooks s'exécutent automatiquement
# → Si échec, corriger et recommit

# 5. Push
git push origin feature/nouvelle-fonctionnalite
```

### 4. Pipeline CI/CD complet

**`.gitlab-ci.yml`**
```yaml
stages:
  - quality
  - security
  - test
  - build
  - deploy

# Quality checks
quality:
  stage: quality
  image: python:3.11
  before_script:
    - pip install pre-commit
  script:
    - pre-commit run --all-files

# Security scan
security:
  stage: security
  image: python:3.11
  script:
    - pip install bandit detect-secrets
    - bandit -r src/
    - detect-secrets scan --baseline .secrets.baseline

# Unit tests
test:
  stage: test
  image: python:3.11
  script:
    - pip install -r requirements.txt
    - pytest --cov=src --cov-report=xml
  coverage: '/(?i)total.*? (100(?:\.0+)?\%|[1-9]?\d(?:\.\d+)?\%)$/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml

# SAST with Semgrep
sast:
  stage: security
  image: returntocorp/semgrep
  script:
    - semgrep scan --config=auto --json --output=semgrep.json
  artifacts:
    reports:
      sast: semgrep.json

# Build Docker
build:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  script:
    - docker build -t myapp:$CI_COMMIT_SHA .
    - docker scan myapp:$CI_COMMIT_SHA  # Scan Trivy
```

---

## Ressources

### Documentation officielle
- 📖 [Pre-commit Framework](https://pre-commit.com/)
- 📖 [Conventional Commits](https://www.conventionalcommits.org/)
- 📖 [Commitizen](https://commitizen-tools.github.io/commitizen/)

### Outils de sécurité
- 🔒 [Detect Secrets](https://github.com/Yelp/detect-secrets)
- 🔒 [Bandit](https://bandit.readthedocs.io/)
- 🔒 [Semgrep](https://semgrep.dev/)
- 🔒 [Trivy](https://aquasecurity.github.io/trivy/)
- 🔒 [Gitleaks](https://github.com/gitleaks/gitleaks)

### Quality tools
- 🎨 [Black](https://black.readthedocs.io/)
- 🎨 [Prettier](https://prettier.io/)
- 🔍 [ESLint](https://eslint.org/)
- 🐍 [Flake8](https://flake8.pycqa.org/)

### Infrastructure
- 🏗️ [TFLint](https://github.com/terraform-linters/tflint)
- 🏗️ [TFSec](https://aquasecurity.github.io/tfsec/)
- 🏗️ [Checkov](https://www.checkov.io/)
- 🏗️ [Ansible Lint](https://ansible-lint.readthedocs.io/)


---

[⬆ Retour en haut](#-shift-left---bonnes-pratiques-devops)
