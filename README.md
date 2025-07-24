
## Documentation

- [Terraform](docs/terraform/terraform.md)
- [Ansible](docs/Ansible/ansible.md)
- [Docker](docs/Docker/docker.md)
- [Kubernetes](docs/Kubernetes/kubernetes.md)

## Commandes

- [Git](docs/Commande_Git.md)
- [Utile](docs/Commande_utile.md)
  

## ✅ Optimisation DevOps - Checklist

### 🔐 Sécurité
- [ ] Ajouter HTTPS (Let's Encrypt ou proxy Cloudflare)
- [ ] Désactiver l’indexation des dossiers dans NGINX
- [ ] Restreindre l’accès SSH (clé uniquement, fail2ban, etc.)

### 🧪 Qualité du code & tests
- [x] Analyse de code avec SonarCloud
- [ ] Ajouter des tests unitaires (ex: Jest pour JS simple)
- [ ] Générer un rapport de couverture de code

### 📈 Monitoring & alertes
- [ ] Uptime Monitoring (UptimeRobot, StatusCake ou script cron)
- [ ] Mise en place de Prometheus + Grafana (optionnel)
- [ ] Logs centralisés (ex: Loki, ELK)

### 📦 Optimisation des assets
- [ ] Minifier CSS/JS (si applicables)
- [ ] Compresser les images (WebP ou imagemin)
- [ ] Ajouter `robots.txt` et `sitemap.xml`

### 📝 Documentation & structure
- [x] README.md documenté
- [ ] Ajouter un fichier `docs/deploiement.md`
- [ ] Créer un fichier `CONTRIBUTING.md`
- [ ] Réorganiser les dossiers (`infra/`, `html/`, `ansible/`, etc.)

### 🚀 Pipeline Jenkins avancé
- [x] Tests & SonarCloud dans la CI
- [x] Build & Push Docker automatisé
- [x] Déploiement sur AWS via Ansible
- [ ] Étapes conditionnelles (tests OK → push → déploiement)
- [ ] Ajouter des badges Jenkins, DockerHub
- [ ] Notification (Slack, email) en cas d’échec

### 🔄 Automatisation (bonus)
- [ ] Déploiement auto via [Watchtower](https://containrrr.dev/watchtower/) (nouvelle image Docker)
- [ ] GitOps : déclenchement de pipeline à chaque `git push` sur `main`

---

🛠️ *Avancement :*  
