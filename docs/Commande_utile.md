
# Commandes utiles


### Creation utilisateur
```bash
sudo adduser senan
```


### Ajout aux sudoers
```bash
sudo usermod -aG sudo senan
```

### #Générer une clé SSH
```bash
ssh-keygen -t ed25519 -C "ton.email@example.com"  
```

### Ajouter la clé à l’agent SSH
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### UFW (pare-feu)
```bash
sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 8080/tcp
sudo ufw enable
```

### Fail2Ban
```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```