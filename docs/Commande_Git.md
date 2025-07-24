
## Commandes GitHub sur une VM Linux :

Configuration initiale de Git
```bash
git config --global user.name "Ton Nom"
git config --global user.email "ton@email.com"
```

Cloner un dépôt GitHub
```bash
git init                          # Initialise un dépôt local
git clone <url_du_repo>          # Clone un dépôt distant
```

Créer un nouveau dépôt local
```bash
mkdir mon-projet
cd mon-projet
git init
```
Ajouter un dépôt distant
```bash
git remote add origin https://github.com/utilisateur/nom-du-repo.git
```
Ajouter, valider et pousser du code
```bash
git add .
git commit -m "Message de commit"
git push origin main
```
Récupérer les dernières modifications
```bash
git pull origin main
```
Créer et changer de branche
```bash
git branch ma-branche
git checkout ma-branche
```
Voir le statut du dépôt
```bash
git status
```
Historique des commits
```bash
git log
```
