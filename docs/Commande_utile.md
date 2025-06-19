
# Commandes utiles


### Creation utilisateur
```bash
sudo adduser senan
```


### Ajout aux sudoers
```bash
sudo usermod -aG sudo senan
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

## Docker
### Installation Docker
```bash
sudo apt install docker.io -y
```
### Installation Docker Compose
```bash
sudo apt install docker-compose -y
```

### Lancement Nginx
```bash
docker run -d -p 8080:80 --name webserver nginx
```

### Docker Compose (multi-container)
- Fichier docker-compose.yml avec services : mariadb, phpmyadmin, nginx
Lancement :
```bash
docker compose up -d
```
Arret :
```bash
docker compose down
```
