# Commandes Git

## ⚙️ Configuration initiale de Git
```bash
git config --global user.name "Ton Nom"
git config --global user.email "ton@email.com"
git config --global core.editor "code --wait"    # Définir VS Code comme éditeur
git config --global init.defaultBranch main      # Définir 'main' comme branche par défaut
git config --list                                # Voir toute la configuration
```

---

## 📁 Initialisation et Clonage
```bash
git init                          # Initialise un dépôt local
git clone <url_du_repo>          # Clone un dépôt distant
git clone <url> <nom_dossier>    # Clone dans un dossier spécifique
git clone --depth 1 <url>        # Clone uniquement le dernier commit (plus rapide)
```

---

## 📄 Gestion des fichiers
```bash
git status                       # Voir l'état des fichiers
git status -s                    # Version courte du status
git add <fichier>                # Suivre un fichier
git add .                        # Suivre tous les fichiers modifiés
git add *.js                     # Suivre tous les fichiers .js
git reset <fichier>              # Enlever un fichier de l'index
git rm <fichier>                 # Supprimer un fichier du dépôt
git rm --cached <fichier>        # Retirer du suivi sans supprimer
git mv <ancien> <nouveau>        # Renommer un fichier
```

---

## 💬 Commits & Historique
```bash
git commit -m "Message"          # Enregistre les modifications
git commit -am "Message"         # Add + commit en une seule commande
git commit --amend               # Modifier le dernier commit
git commit --amend -m "Nouveau message"  # Modifier le message du dernier commit
git log                          # Historique des commits
git log --oneline                # Historique condensé
git log --graph --oneline --all  # Graphique de l'historique
git log -p                       # Affiche les différences dans chaque commit
git log --author="Nom"           # Commits d'un auteur spécifique
git log --since="2 weeks ago"    # Commits des 2 dernières semaines
git diff                         # Voir les modifications non staged
git diff --staged                # Voir les modifications staged
git show <hash_commit>           # Voir le détail d'un commit
git blame <fichier>              # Voir qui a modifié chaque ligne
```

---

## 🌿 Branches
```bash
git branch                       # Liste les branches locales
git branch -a                    # Liste toutes les branches (locales + distantes)
git branch <nom>                 # Crée une nouvelle branche
git checkout <nom>               # Bascule vers une branche
git checkout -b <nom>            # Crée et bascule en même temps
git switch <nom>                 # Bascule vers une branche (commande moderne)
git switch -c <nom>              # Crée et bascule (commande moderne)
git merge <branche>              # Fusionne une branche
git merge --no-ff <branche>      # Fusion avec commit de merge explicite
git branch -d <nom>              # Supprime une branche locale (safe)
git branch -D <nom>              # Force la suppression d'une branche
git push origin --delete <nom>   # Supprime une branche distante
```

---

## 🔧 Résolution de Conflits
```bash
git status                       # Voir les fichiers en conflit
# Éditer manuellement les fichiers en conflit
git add <fichier_résolu>         # Marquer le conflit comme résolu
git commit                       # Finaliser la résolution
git merge --abort                # Annuler une fusion en cours
git rebase --abort               # Annuler un rebase en cours

# Outils de merge
git mergetool                    # Ouvrir un outil graphique de résolution
git diff --ours                  # Voir la version locale
git diff --theirs                # Voir la version distante
git checkout --ours <fichier>    # Garder la version locale
git checkout --theirs <fichier>  # Garder la version distante
```

---

## 🗂️ Stash (Sauvegardes temporaires)
```bash
git stash                        # Sauvegarder les modifications en cours
git stash save "Message"         # Stash avec un message descriptif
git stash list                   # Liste des stashs
git stash show                   # Voir le contenu du dernier stash
git stash show -p                # Voir les différences du dernier stash
git stash apply                  # Appliquer le dernier stash (le garde)
git stash pop                    # Appliquer et supprimer le dernier stash
git stash drop                   # Supprimer le dernier stash
git stash clear                  # Supprimer tous les stashs
git stash apply stash@{2}        # Appliquer un stash spécifique
```

---

## ☁️ Dépôt distant (GitHub/GitLab)
```bash
git remote -v                    # Voir les remotes
git remote add origin <url>      # Ajouter un remote
git remote rename origin upstream # Renommer un remote
git remote remove origin         # Supprimer un remote
git push origin <branche>        # Pousser vers le dépôt distant
git push -u origin <branche>     # Push et définir upstream
git push --all                   # Pousser toutes les branches
git pull origin <branche>        # Récupérer et fusionner les changements
git pull --rebase                # Pull avec rebase au lieu de merge
git fetch                        # Récupère sans fusion
git fetch --all                  # Récupère de tous les remotes
git fetch --prune                # Nettoie les branches distantes supprimées
```

---

## 🏷️ Tags (versions)
```bash
git tag                          # Liste tous les tags
git tag v1.0.0                   # Créer un tag léger
git tag -a v1.0.0 -m "Version 1.0.0"  # Tag annoté avec message
git tag -a v1.0.0 <commit_hash>  # Tag sur un commit spécifique
git push origin v1.0.0           # Envoyer un tag
git push origin --tags           # Envoyer tous les tags
git tag -d v1.0.0                # Supprimer un tag local
git push origin --delete v1.0.0  # Supprimer un tag distant
git show v1.0.0                  # Voir les détails d'un tag
```

---

## 🧼 Annulations & Corrections
```bash
git restore <fichier>            # Annule changements non commités
git restore --staged <fichier>   # Unstage un fichier
git reset HEAD <fichier>         # Unstage un fichier (ancienne méthode)
git reset --soft HEAD~1          # Annule le dernier commit (garde fichiers staged)
git reset --mixed HEAD~1         # Annule commit + unstage (garde modifications)
git reset --hard HEAD~1          # Supprime commit + fichiers (DANGER!)
git reset --hard origin/main     # Reset à l'état du remote
git revert <commit_hash>         # Inverse un commit sans réécrire l'historique
git revert HEAD                  # Inverse le dernier commit
git clean -n                     # Voir les fichiers non suivis à supprimer
git clean -fd                    # Supprimer fichiers et dossiers non suivis
```

---

## 🚀 Commandes Avancées

### Rebase
```bash
git rebase <branche>             # Rebaser sur une autre branche
git rebase -i HEAD~3             # Rebase interactif des 3 derniers commits
git rebase --continue            # Continuer après résolution de conflit
git rebase --skip                # Sauter un commit problématique
git rebase --abort               # Annuler le rebase

# Options du rebase interactif:
# pick   = garder le commit
# reword = modifier le message
# edit   = modifier le commit
# squash = fusionner avec le commit précédent
# drop   = supprimer le commit
```

### Cherry-pick
```bash
git cherry-pick <commit_hash>    # Appliquer un commit spécifique
git cherry-pick <hash1> <hash2>  # Appliquer plusieurs commits
git cherry-pick --continue       # Continuer après résolution
git cherry-pick --abort          # Annuler le cherry-pick
```

### Bisect (Recherche de bugs)
```bash
git bisect start                 # Démarrer la recherche
git bisect bad                   # Marquer le commit actuel comme mauvais
git bisect good <commit_hash>    # Marquer un commit comme bon
# Git va tester automatiquement les commits intermédiaires
git bisect reset                 # Terminer la recherche
```

### Reflog (Historique des actions)
```bash
git reflog                       # Voir l'historique de toutes les actions
git reflog show <branche>        # Reflog d'une branche spécifique
git reset --hard HEAD@{2}        # Revenir à un état antérieur
```

---

## 🔀 Workflows Git

### GitFlow
```bash
# Branches principales
main (ou master)                 # Version production
develop                          # Branche de développement

# Démarrer une feature
git checkout -b feature/nom-feature develop
# ... développement ...
git checkout develop
git merge --no-ff feature/nom-feature
git branch -d feature/nom-feature

# Créer une release
git checkout -b release/1.0.0 develop
# ... corrections mineures ...
git checkout main
git merge --no-ff release/1.0.0
git tag -a v1.0.0
git checkout develop
git merge --no-ff release/1.0.0
git branch -d release/1.0.0

# Hotfix
git checkout -b hotfix/1.0.1 main
# ... correction urgente ...
git checkout main
git merge --no-ff hotfix/1.0.1
git tag -a v1.0.1
git checkout develop
git merge --no-ff hotfix/1.0.1
git branch -d hotfix/1.0.1
```

### Feature Branch Workflow
```bash
# Créer une branche pour chaque feature
git checkout -b feature/nouvelle-fonctionnalite main
# ... développement ...
git push -u origin feature/nouvelle-fonctionnalite
# Créer une Pull Request sur GitHub/GitLab
# Après review et approbation:
git checkout main
git pull origin main
git merge feature/nouvelle-fonctionnalite
git push origin main
git branch -d feature/nouvelle-fonctionnalite
```

### Trunk-Based Development
```bash
# Commits fréquents directement sur main
git checkout main
git pull origin main
# ... petites modifications ...
git add .
git commit -m "feat: petite amélioration"
git push origin main
```

---

## 🔄 Passer d'un dépôt HTTPS à SSH
```bash
# Vérifier l'URL actuelle
git remote -v

# Changer pour SSH
git remote set-url origin git@github.com:TonUser/nom-du-repo.git

# Vérifier le changement
git remote -v
```

---

## 🔍 Recherche & Investigation
```bash
git grep "mot-clé"               # Rechercher dans le code
git log -S "fonction"            # Trouver quand une fonction a été ajoutée/supprimée
git log --grep="bug"             # Rechercher dans les messages de commit
git shortlog                     # Résumé des commits par auteur
git shortlog -sn                 # Nombre de commits par auteur
```

---

## 📊 Statistiques & Informations
```bash
git log --stat                   # Stats de chaque commit
git diff --stat                  # Statistiques des modifications
git show --stat                  # Stats d'un commit
git ls-files                     # Liste tous les fichiers suivis
git count-objects -vH            # Taille du dépôt
```

---

## 🛡️ .gitignore
```bash
# Créer un .gitignore
touch .gitignore

# Exemples de contenu:
node_modules/
*.log
.env
.DS_Store
dist/
build/

# Ignorer un fichier déjà suivi
git rm --cached <fichier>
echo "<fichier>" >> .gitignore
git commit -m "Ignore <fichier>"
```

---

## 💡 Astuces & Raccourcis
```bash
# Alias utiles à ajouter dans ~/.gitconfig
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.last 'log -1 HEAD'
git config --global alias.unstage 'reset HEAD --'
git config --global alias.visual 'log --graph --oneline --all'

# Utilisation:
git st                           # Équivalent de git status
git co main                      # Équivalent de git checkout main
git visual                       # Graphique de l'historique
```

---

## 🚨 Commandes de Secours

### Récupérer un commit supprimé
```bash
git reflog                       # Trouver le hash du commit
git cherry-pick <hash>           # Récupérer le commit
# ou
git reset --hard <hash>          # Revenir à cet état
```

### Récupérer un fichier supprimé
```bash
git checkout <commit_hash> -- <fichier>  # Restaurer depuis un commit
git restore --source=HEAD~2 <fichier>    # Restaurer depuis 2 commits avant
```

### Annuler un push (DANGEREUX!)
```bash
git reset --hard HEAD~1          # Annuler localement
git push --force origin <branche> # Force push (à éviter en équipe!)
```

---

## 📚 Ressources Supplémentaires
- [Documentation officielle Git](https://git-scm.com/doc)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Learn Git Branching (interactif)](https://learngitbranching.js.org/)
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Solutions aux problèmes courants
