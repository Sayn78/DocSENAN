
# Commandes Git :

## Configuration initiale de Git
```bash
git config --global user.name "Ton Nom"
git config --global user.email "ton@email.com"
```

## 📁 Initialisation et Clonage
```bash
git init                          # Initialise un dépôt local
git clone <url_du_repo>          # Clone un dépôt distant
```

## 📄 Gestion des fichiers
```bash
git status                       # Voir l’état des fichiers
git add <fichier>                # Suivre un fichier
git add .                        # Suivre tous les fichiers modifiés
git reset <fichier>              # Enlever un fichier de l’index
```

## 💬 Commits & Historique
```bash
git commit -m "Message"          # Enregistre les modifications
git log                          # Historique des commits
git diff                         # Voir les modifications
git show <hash_commit>          # Voir le détail d’un commit
```

## 🌿 Branches
```bash
git branch                       # Liste les branches
git branch <nom>                # Crée une nouvelle branche
git checkout <nom>              # Bascule vers une branche
git checkout -b <nom>           # Crée et bascule en même temps
git merge <branche>             # Fusionne une branche
git branch -d <nom>             # Supprime une branche locale
```

## ☁️ Dépôt distant (GitHub)
```bash
git remote -v                    # Voir les remotes
git push origin <branche>       # Pousser vers le dépôt distant
git pull origin <branche>       # Récupérer les changements
git fetch                       # Récupère sans fusion
```

## 🏷️ Tags (versions)
```bash
git tag v1.0.0                   # Créer un tag
git push origin v1.0.0          # Envoyer le tag
```

## 🧼 Annulations
```bash
git restore <fichier>           # Annule changements non commités
git reset --soft HEAD~1         # Annule le dernier commit (garde fichiers)
git reset --hard HEAD~1         # Supprime commit + fichiers
git revert <commit_hash>       # Inverse un commit sans réécrire l’historique
```

## 🔄 Passer d’un dépôt HTTPS à SSH
```bash
git remote set-url origin git@github.com:TonUser/nom-du-repo.git
```