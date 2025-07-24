# 🐧 Linux – Commandes Essentielles

## 📁 Navigation & Fichiers

```bash
pwd                         # Affiche le chemin du dossier courant
ls                          # Liste les fichiers du répertoire
ls -l                       # Liste détaillée
cd <dossier>                # Se déplacer dans un dossier
cd ..                       # Revenir au dossier parent
cd ~                        # Aller dans le home
mkdir <nom>                # Créer un dossier
touch <fichier>            # Créer un fichier vide
rm <fichier>               # Supprimer un fichier
rm -r <dossier>            # Supprimer un dossier
cp <src> <dest>            # Copier fichier/dossier
mv <src> <dest>            # Déplacer ou renommer
```

---

## 🔎 Recherche & Affichage

```bash
cat <fichier>              # Affiche le contenu d’un fichier
less <fichier>             # Lecture page par page
head <fichier>             # Les 10 premières lignes
tail <fichier>             # Les 10 dernières lignes
grep "mot" <fichier>       # Recherche un mot
find . -name "<fichier>"   # Recherche un fichier
```

---

## 👥 Gestion des utilisateurs

```bash
whoami                     # Nom de l’utilisateur actuel
su <utilisateur>           # Se connecter à un autre utilisateur
sudo su - <utilisateur>    # Avec privilèges sudo
adduser <nom>              # Ajouter un utilisateur
passwd <nom>               # Changer son mot de passe
sudo usermod -aG sudo senan # Ajout aux sudoers
```

---

## ⚙️ Système & Processus

```bash
top                        # Affiche les processus en temps réel
htop                       # (version améliorée de top)
ps aux                     # Liste des processus
kill <PID>                 # Tuer un processus
df -h                      # Espace disque
du -sh *                   # Taille des fichiers
free -h                   # Mémoire disponible
uptime                     # Durée depuis dernier démarrage
uname -a                   # Infos système
```

---

## 📦 Gestion des paquets (Debian/Ubuntu)

```bash
sudo apt update            # Met à jour la liste des paquets
sudo apt upgrade           # Met à jour les paquets installés
sudo apt install <nom>     # Installer un paquet
sudo apt remove <nom>      # Supprimer un paquet
```

---

## 🌐 Réseau

```bash
ip a                       # Adresse IP
ping google.com            # Vérifier la connexion
curl <url>                 # Requête HTTP simple
wget <url>                 # Télécharger un fichier
netstat -tuln              # Ports ouverts
ss -tuln                   # (remplaçant de netstat)
```

---

## 🔐 Droits & Permissions

```bash
chmod +x <fichier>         # Rendre un script exécutable
chown user:group <fichier> # Changer le propriétaire
chmod 755 <fichier>        # Modifier les permissions
```

---

## 🧹 Nettoyage

```bash
clear                      # Nettoyer le terminal
history                    # Historique des commandes
```

## UFW (pare-feu)
```bash
sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 8080/tcp
sudo ufw enable
```

## Fail2Ban
```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

## #Générer une clé SSH
```bash
ssh-keygen -t ed25519 -C "ton.email@example.com"  
```

## Ajouter la clé à l’agent SSH
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519