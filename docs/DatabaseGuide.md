# 🗄️ Bases de Données – Guide Complet

## 📋 Table des Matières
- [PostgreSQL](#-postgresql)
- [MariaDB/MySQL](#-mariadbmysql)
- [MongoDB](#-mongodb)
- [Redis](#-redis)
- [Comparaison & Choix](#-comparaison--choix)

---

## 🐘 PostgreSQL

### 📥 Installation
```bash
# Mettre à jour les paquets
sudo apt update

# Installer PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Vérifier la version
sudo -u postgres psql --version

# Vérifier le statut du service
sudo systemctl status postgresql

# Démarrer/Arrêter/Redémarrer
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql

# Activer au démarrage
sudo systemctl enable postgresql
```

---

### 👤 Gestion des Utilisateurs

#### Connexion en tant que super-utilisateur
```bash
# Connexion avec l'utilisateur système postgres
sudo -u postgres psql

# Ou directement
sudo -i -u postgres
psql
```

#### Créer un utilisateur
```sql
-- Dans le shell PostgreSQL
CREATE USER <nom_utilisateur> WITH ENCRYPTED PASSWORD '<mot_de_passe>';

-- Exemples
CREATE USER developer WITH ENCRYPTED PASSWORD 'SecurePassword123!';
CREATE USER app_user WITH ENCRYPTED PASSWORD 'MyP@ssw0rd';

-- Avec des privilèges spécifiques
CREATE USER admin_user WITH ENCRYPTED PASSWORD 'AdminPass!' CREATEDB CREATEROLE;

-- Lister les utilisateurs
\du

-- Modifier un mot de passe
ALTER USER <nom_utilisateur> WITH PASSWORD '<nouveau_mot_de_passe>';
```

#### Supprimer un utilisateur
```sql
DROP USER <nom_utilisateur>;
```

---

### 🗃️ Gestion des Bases de Données

#### Créer une base de données
```sql
-- Créer une base
CREATE DATABASE <nom_base>;

-- Exemples
CREATE DATABASE myapp_db;
CREATE DATABASE production_db;

-- Créer avec un propriétaire spécifique
CREATE DATABASE <nom_base> OWNER <nom_utilisateur>;

-- Lister les bases de données
\l
```

#### Accorder des privilèges
```sql
-- Tous les privilèges sur une base
GRANT ALL PRIVILEGES ON DATABASE <nom_base> TO <nom_utilisateur>;

-- Exemples
GRANT ALL PRIVILEGES ON DATABASE myapp_db TO developer;
GRANT ALL PRIVILEGES ON DATABASE production_db TO app_user;

-- Changer le propriétaire
ALTER DATABASE <nom_base> OWNER TO <nom_utilisateur>;

-- Révoquer des privilèges
REVOKE ALL PRIVILEGES ON DATABASE <nom_base> FROM <nom_utilisateur>;
```

#### Supprimer une base de données
```sql
DROP DATABASE <nom_base>;
```

---

### 🔌 Connexion à la Base

#### Connexion avec un utilisateur
```bash
# Format général
psql -U <nom_utilisateur> -h <hôte> -d <nom_base>

# Exemples
psql -U developer -h 127.0.0.1 -d myapp_db
psql -U app_user -h localhost -d production_db

# Avec mot de passe dans la commande (non recommandé en production)
PGPASSWORD='<mot_de_passe>' psql -U <nom_utilisateur> -h 127.0.0.1 -d <nom_base>

# Connexion à distance
psql -U <nom_utilisateur> -h <ip_serveur> -p 5432 -d <nom_base>
```

#### Variables d'environnement
```bash
# Définir pour éviter de taper le mot de passe
export PGUSER=developer
export PGPASSWORD='SecurePassword123!'
export PGHOST=127.0.0.1
export PGDATABASE=myapp_db

# Puis connexion simple
psql
```

---

### 💾 Sauvegarde & Restauration (Dumps)

#### Créer un dump (sauvegarde)
```bash
# Format général
pg_dump -U <nom_utilisateur> -h <hôte> --format=p --file=<fichier_dump>.sql <nom_base>

# Exemples
pg_dump -U developer -h 127.0.0.1 --format=p --file=backup_myapp.sql myapp_db
pg_dump -U app_user -h localhost --format=p --file=prod_backup_$(date +%Y%m%d).sql production_db

# Format compressé (custom)
pg_dump -U developer -h 127.0.0.1 -Fc --file=myapp_db.dump myapp_db

# Dump de toutes les bases
pg_dumpall -U postgres --file=all_databases.sql

# Dump avec structure seulement (sans données)
pg_dump -U developer -h 127.0.0.1 --schema-only --file=schema.sql myapp_db

# Dump des données seulement (sans structure)
pg_dump -U developer -h 127.0.0.1 --data-only --file=data.sql myapp_db
```

#### Restaurer un dump
```bash
# Format général
psql -U <nom_utilisateur> -h <hôte> -d <nom_base> -f <fichier_dump>.sql

# Exemples
psql -U developer -h 127.0.0.1 -d myapp_db -f backup_myapp.sql
psql -U app_user -h localhost -d production_db -f prod_backup_20250124.sql

# Restaurer un dump compressé
pg_restore -U developer -h 127.0.0.1 -d myapp_db myapp_db.dump

# Restaurer avec suppression des données existantes
pg_restore -U developer -h 127.0.0.1 -d myapp_db --clean --if-exists myapp_db.dump
```

---

### 🛠️ Commandes Utiles PostgreSQL

#### Vérifier le status de la connection :
```bash
pg_isready
```

#### Dans le shell psql
```sql
-- Connexion
\c <nom_base>                    -- Se connecter à une base
\c myapp_db                      -- Exemple

-- Informations
\l                               -- Lister les bases
\du                              -- Lister les utilisateurs
\dt                              -- Lister les tables
\d <nom_table>                   -- Décrire une table
\df                              -- Lister les fonctions
\dn                              -- Lister les schémas

-- Aide
\?                               -- Aide sur les commandes
\h <commande_sql>                -- Aide sur une commande SQL

-- Fichiers
\i <fichier>.sql                 -- Exécuter un fichier SQL
\o <fichier>.txt                 -- Rediriger la sortie vers un fichier

-- Quitter
\q                               -- Quitter psql
```

#### Requêtes SQL courantes
```sql
-- Voir les tables et leur taille
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Voir les connexions actives
SELECT * FROM pg_stat_activity;

-- Tuer une connexion
SELECT pg_terminate_backend(<pid>);

-- Voir la taille de la base
SELECT pg_size_pretty(pg_database_size('<nom_base>'));
```

---

## 🦭 MariaDB/MySQL

### 📥 Installation

#### MariaDB
```bash
# Mettre à jour les paquets
sudo apt update

# Installer MariaDB
sudo apt install -y mariadb-server mariadb-client

# Vérifier la version
mariadb --version

# Vérifier le statut
sudo systemctl status mariadb

# Démarrer/Arrêter/Redémarrer
sudo systemctl start mariadb
sudo systemctl stop mariadb
sudo systemctl restart mariadb

# Activer au démarrage
sudo systemctl enable mariadb
```

#### MySQL
```bash
# Installer MySQL
sudo apt install -y mysql-server

# Vérifier la version
mysql --version

# Configuration initiale sécurisée
sudo mysql_secure_installation
```

---

### 👤 Gestion des Utilisateurs

#### Connexion en tant que root
```bash
# MariaDB
sudo mariadb -u root

# MySQL (après installation)
sudo mysql -u root

# Avec mot de passe
mysql -u root -p
```

#### Créer un utilisateur
```sql
-- Format général
CREATE USER '<nom_utilisateur>'@'<hôte>' IDENTIFIED BY '<mot_de_passe>';

-- Exemples
CREATE USER 'developer'@'localhost' IDENTIFIED BY 'DevPassword123!';
CREATE USER 'app_user'@'%' IDENTIFIED BY 'AppP@ssw0rd';
CREATE USER 'readonly'@'192.168.1.%' IDENTIFIED BY 'ReadOnly123';

-- Lister les utilisateurs
SELECT User, Host FROM mysql.user;

-- Modifier un mot de passe
ALTER USER '<nom_utilisateur>'@'<hôte>' IDENTIFIED BY '<nouveau_mot_de_passe>';

-- Supprimer un utilisateur
DROP USER '<nom_utilisateur>'@'<hôte>';
```

**Explications des hôtes :**
- `'localhost'` : Connexion locale uniquement
- `'%'` : Connexion depuis n'importe quelle IP
- `'192.168.1.%'` : Connexion depuis le réseau 192.168.1.x
- `'192.168.1.100'` : Connexion depuis une IP spécifique

---

### 🗃️ Gestion des Bases de Données

#### Créer une base de données
```sql
-- Créer une base
CREATE DATABASE <nom_base>;

-- Exemples
CREATE DATABASE myapp_db;
CREATE DATABASE ecommerce_db;

-- Avec encodage spécifique
CREATE DATABASE <nom_base> CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Lister les bases
SHOW DATABASES;

-- Utiliser une base
USE <nom_base>;
```

#### Accorder des privilèges
```sql
-- Tous les privilèges sur une base
GRANT ALL PRIVILEGES ON <nom_base>.* TO '<nom_utilisateur>'@'<hôte>';

-- Exemples
GRANT ALL PRIVILEGES ON myapp_db.* TO 'developer'@'localhost';
GRANT ALL PRIVILEGES ON ecommerce_db.* TO 'app_user'@'%';

-- Privilèges spécifiques
GRANT SELECT, INSERT, UPDATE ON <nom_base>.* TO '<nom_utilisateur>'@'<hôte>';
GRANT SELECT ON <nom_base>.* TO 'readonly'@'localhost';

-- Appliquer les changements
FLUSH PRIVILEGES;

-- Voir les privilèges d'un utilisateur
SHOW GRANTS FOR '<nom_utilisateur>'@'<hôte>';

-- Révoquer des privilèges
REVOKE ALL PRIVILEGES ON <nom_base>.* FROM '<nom_utilisateur>'@'<hôte>';
```

#### Supprimer une base de données
```sql
DROP DATABASE <nom_base>;
```

---

### 🔌 Connexion à la Base

#### Connexion avec un utilisateur
```bash
# Format général
mysql -h <hôte> -u <nom_utilisateur> -p<mot_de_passe> <nom_base>
# ou (recommandé, demande le mot de passe)
mysql -h <hôte> -u <nom_utilisateur> -p <nom_base>

# Exemples
mariadb -h 127.0.0.1 -u developer -p myapp_db
mysql -h localhost -u app_user -p ecommerce_db

# Avec port spécifique
mysql -h <hôte> -P 3306 -u <nom_utilisateur> -p <nom_base>

# Connexion à distance
mysql -h 192.168.1.100 -u developer -p myapp_db
```

#### Fichier de configuration (.my.cnf)
```bash
# Créer ~/.my.cnf pour éviter de taper le mot de passe
cat > ~/.my.cnf << EOF
[client]
user=developer
password=SecurePassword123!
host=127.0.0.1
database=myapp_db
EOF

chmod 600 ~/.my.cnf

# Connexion simple après
mysql
```

---

### 💾 Sauvegarde & Restauration (Dumps)

#### Créer un dump (sauvegarde)
```bash
# Format général
mysqldump -u <nom_utilisateur> -p <nom_base> > <fichier_dump>.sql

# Exemples
mysqldump -u developer -p myapp_db > backup_myapp_$(date +%Y%m%d).sql
mysqldump -u app_user -p ecommerce_db --no-tablespaces > ecommerce_backup.sql

# Dump avec structure et données
mysqldump -u developer -p myapp_db --routines --triggers > full_backup.sql

# Dump de plusieurs bases
mysqldump -u root -p --databases myapp_db ecommerce_db > multi_backup.sql

# Dump de toutes les bases
mysqldump -u root -p --all-databases > all_databases.sql

# Dump avec compression
mysqldump -u developer -p myapp_db | gzip > backup_myapp.sql.gz

# Dump structure seulement
mysqldump -u developer -p --no-data myapp_db > structure_only.sql

# Dump données seulement
mysqldump -u developer -p --no-create-info myapp_db > data_only.sql

# Dump d'une table spécifique
mysqldump -u developer -p myapp_db <nom_table> > table_backup.sql
```

#### Restaurer un dump
```bash
# Format général
mysql -u <nom_utilisateur> -p <nom_base> < <fichier_dump>.sql

# Exemples
mysql -u developer -p myapp_db < backup_myapp_20250124.sql
mysql -u app_user -p ecommerce_db < ecommerce_backup.sql

# Restaurer depuis un fichier compressé
gunzip < backup_myapp.sql.gz | mysql -u developer -p myapp_db

# Restaurer avec la commande source (dans mysql)
mysql -u developer -p myapp_db
mysql> source /path/to/backup.sql;

# Restaurer toutes les bases
mysql -u root -p < all_databases.sql
```

---

### 🛠️ Commandes Utiles MariaDB/MySQL

#### Dans le shell mysql
```sql
-- Bases de données
SHOW DATABASES;                      -- Lister les bases
USE <nom_base>;                      -- Utiliser une base
SELECT DATABASE();                   -- Base actuelle

-- Tables
SHOW TABLES;                         -- Lister les tables
DESCRIBE <nom_table>;                -- Structure d'une table
SHOW CREATE TABLE <nom_table>;       -- Voir la requête CREATE

-- Utilisateurs et privilèges
SELECT User, Host FROM mysql.user;   -- Lister les utilisateurs
SHOW GRANTS FOR CURRENT_USER();      -- Vos privilèges
SHOW GRANTS FOR '<user>'@'<host>';   -- Privilèges d'un utilisateur

-- Processus
SHOW PROCESSLIST;                    -- Connexions actives
KILL <id>;                           -- Tuer une connexion

-- Variables et statut
SHOW VARIABLES LIKE '%max_connections%';
SHOW STATUS;
SHOW ENGINE INNODB STATUS;

-- Quitter
EXIT;
QUIT;
```

#### Requêtes utiles
```sql
-- Taille des bases de données
SELECT 
    table_schema AS 'Database',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
GROUP BY table_schema;

-- Taille des tables
SELECT 
    table_name AS 'Table',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = '<nom_base>'
ORDER BY (data_length + index_length) DESC;

-- Voir les tables sans clé primaire
SELECT tables.table_schema, tables.table_name
FROM information_schema.tables
LEFT JOIN information_schema.table_constraints AS constraints
    ON tables.table_schema = constraints.table_schema
    AND tables.table_name = constraints.table_name
    AND constraints.constraint_type = 'PRIMARY KEY'
WHERE tables.table_schema NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys')
    AND constraints.constraint_name IS NULL;
```

---

## 🍃 MongoDB

### 📥 Installation

```bash
# Importer la clé GPG
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# Ajouter le dépôt MongoDB
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Installer MongoDB
sudo apt update
sudo apt install -y mongodb-org

# Démarrer MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod

# Vérifier la version
mongod --version
```

---

### 🔌 Connexion et Commandes de Base

```bash
# Se connecter au shell MongoDB
mongosh

# Se connecter avec authentification
mongosh -u <nom_utilisateur> -p <mot_de_passe> --authenticationDatabase admin

# Se connecter à une base spécifique
mongosh <nom_base>
```

#### Commandes dans le shell
```javascript
// Voir les bases de données
show dbs

// Utiliser/créer une base
use <nom_base>
use myapp_db

// Voir la base actuelle
db

// Créer une collection
db.createCollection("<nom_collection>")
db.createCollection("users")

// Voir les collections
show collections

// Insérer un document
db.<collection>.insertOne({
    name: "John Doe",
    email: "john@example.com",
    age: 30
})

// Insérer plusieurs documents
db.users.insertMany([
    { name: "Alice", email: "alice@example.com" },
    { name: "Bob", email: "bob@example.com" }
])

// Rechercher
db.users.find()
db.users.findOne({ name: "John Doe" })
db.users.find({ age: { $gte: 18 } })

// Compter
db.users.countDocuments()

// Mettre à jour
db.users.updateOne(
    { name: "John Doe" },
    { $set: { age: 31 } }
)

// Supprimer
db.users.deleteOne({ name: "John Doe" })
db.users.deleteMany({ age: { $lt: 18 } })

// Supprimer une collection
db.<collection>.drop()

// Supprimer une base
db.dropDatabase()
```

---

### 👤 Gestion des Utilisateurs MongoDB

```javascript
// Se connecter à la base admin
use admin

// Créer un administrateur
db.createUser({
    user: "<nom_admin>",
    pwd: "<mot_de_passe>",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})

// Créer un utilisateur pour une base spécifique
use <nom_base>
db.createUser({
    user: "<nom_utilisateur>",
    pwd: "<mot_de_passe>",
    roles: [ { role: "readWrite", db: "<nom_base>" } ]
})

// Exemple
use myapp_db
db.createUser({
    user: "app_user",
    pwd: "SecurePassword123!",
    roles: [ { role: "readWrite", db: "myapp_db" } ]
})

// Voir les utilisateurs
db.getUsers()

// Supprimer un utilisateur
db.dropUser("<nom_utilisateur>")

// Modifier le mot de passe
db.changeUserPassword("<nom_utilisateur>", "<nouveau_mot_de_passe>")
```

---

### 💾 Sauvegarde & Restauration MongoDB

```bash
# Dump d'une base complète
mongodump --db <nom_base> --out /backup/

# Exemples
mongodump --db myapp_db --out /backup/myapp_$(date +%Y%m%d)/
mongodump --db myapp_db --gzip --out /backup/compressed/

# Dump avec authentification
mongodump --uri="mongodb://<user>:<password>@localhost:27017/<nom_base>" --out /backup/

# Dump d'une collection spécifique
mongodump --db <nom_base> --collection <nom_collection> --out /backup/

# Restaurer une base
mongorestore --db <nom_base> /backup/myapp_db/

# Restaurer avec authentification
mongorestore --uri="mongodb://<user>:<password>@localhost:27017/" /backup/

# Restaurer une collection spécifique
mongorestore --db <nom_base> --collection <nom_collection> /backup/myapp_db/<collection>.bson

# Export en JSON
mongoexport --db <nom_base> --collection <nom_collection> --out collection.json

# Import depuis JSON
mongoimport --db <nom_base> --collection <nom_collection> --file collection.json
```

---

## 🔴 Redis

### 📥 Installation

```bash
# Installer Redis
sudo apt update
sudo apt install -y redis-server

# Vérifier la version
redis-server --version

# Démarrer Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server
sudo systemctl status redis-server
```

---

### 🔌 Connexion et Commandes de Base

```bash
# Se connecter au shell Redis
redis-cli

# Se connecter avec mot de passe
redis-cli -a <mot_de_passe>

# Se connecter à un hôte distant
redis-cli -h <hôte> -p 6379
```

#### Commandes dans redis-cli
```bash
# Tester la connexion
PING

# Définir une clé
SET <clé> <valeur>
SET username "john_doe"
SET counter 1

# Récupérer une valeur
GET <clé>
GET username

# Incrémenter
INCR counter
INCRBY counter 5

# Définir avec expiration (en secondes)
SETEX <clé> <secondes> <valeur>
SETEX session:user123 3600 "active"

# Vérifier si une clé existe
EXISTS <clé>

# Voir toutes les clés
KEYS *
KEYS user:*

# Supprimer une clé
DEL <clé>

# Voir le temps restant avant expiration
TTL <clé>

# Voir des informations sur le serveur
INFO
INFO memory

# Supprimer toutes les clés de la base actuelle
FLUSHDB

# Supprimer toutes les clés de toutes les bases
FLUSHALL

# Quitter
EXIT
```

---

### 💾 Sauvegarde & Restauration Redis

```bash
# Sauvegarder (snapshot)
redis-cli SAVE

# Sauvegarder en arrière-plan
redis-cli BGSAVE

# Voir la dernière sauvegarde
redis-cli LASTSAVE

# Fichier de sauvegarde par défaut
ls -lh /var/lib/redis/dump.rdb

# Sauvegarder manuellement
sudo cp /var/lib/redis/dump.rdb /backup/redis_backup_$(date +%Y%m%d).rdb

# Restaurer
sudo systemctl stop redis-server
sudo cp /backup/redis_backup_20250124.rdb /var/lib/redis/dump.rdb
sudo chown redis:redis /var/lib/redis/dump.rdb
sudo systemctl start redis-server
```

---

## 🔄 Comparaison & Choix

### 📊 Tableau Comparatif

| Caractéristique | PostgreSQL | MariaDB/MySQL | MongoDB | Redis |
|----------------|------------|---------------|---------|-------|
| **Type** | SQL relationnel | SQL relationnel | NoSQL (Document) | NoSQL (Clé-Valeur) |
| **Cas d'usage** | Applications complexes | Applications web | Données flexibles | Cache, sessions |
| **Transactions** | ✅ ACID complet | ✅ ACID | ⚠️ Limité | ❌ Non |
| **Scalabilité** | Vertical | Vertical/Horizontal | Horizontal | Horizontal |
| **Performance lecture** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Performance écriture** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Complexité requêtes** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Stockage en mémoire** | ❌ | ❌ | ❌ | ✅ |

---

### 🎯 Quand Utiliser Quoi ?

#### PostgreSQL 🐘
**Choisir si :**
- Relations complexes entre données
- Besoin de transactions ACID complètes
- Requêtes complexes (joins, sous-requêtes)
- Intégrité des données cruciale
- JSON + relationnel

**Exemples :** Banque, ERP, CRM, applications d'entreprise

---

#### MariaDB/MySQL 🦭
**Choisir si :**
- Applications web classiques
- Bon équilibre performance/fonctionnalités
- Écosystème mature (WordPress, Laravel, etc.)
- Réplication master-slave

**Exemples :** Sites web, blogs, e-commerce, CMS

---

#### MongoDB 🍃
**Choisir si :**
- Structure de données flexible
- Développement rapide (prototypage)
- Données non relationnelles
- Scalabilité horizontale importante
- Gros volumes de données

**Exemples :** IoT, logs, analytics, catalogues produits

---

#### Redis 🔴
**Choisir si :**
- Cache haute performance
- Sessions utilisateur
- Compteurs temps réel
- Pub/Sub messaging
- Files d'attente

**Exemples :** Cache applicatif, leaderboards, rate limiting

---

## 🔒 Sécurité

### ✅ Bonnes Pratiques Communes

```bash
# 1. Toujours utiliser des mots de passe forts
# ❌ Mauvais
CREATE USER 'user'@'localhost' IDENTIFIED BY '123456';

# ✅ Bon
CREATE USER 'user'@'localhost' IDENTIFIED BY 'Str0ng!P@ssw0rd#2025';

# 2. Principe du moindre privilège
# Donner uniquement les droits nécessaires
GRANT SELECT, INSERT ON mydb.* TO 'readonly'@'localhost';

# 3. Désactiver l'accès root distant
# Dans MySQL/MariaDB config
bind-address = 127.0.0.1

# 4. Sauvegardes régulières automatisées
# Créer un script cron
0 2 * * * /usr/local/bin/backup_databases.sh

# 5. Chiffrer les connexions (SSL/TLS)
# Configurer dans le fichier de configuration

# 6. Surveiller les logs
sudo tail -f /var/log/postgresql/postgresql-*.log
sudo tail -f /var/log/mysql/error.log

# 7. Mettre à jour régulièrement
sudo apt update && sudo apt upgrade
```

---

## 📚 Ressources Complémentaires

### Documentation Officielle
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Redis Documentation](https://redis.io/documentation)

### Outils Graphiques
- **PostgreSQL:** pgAdmin, DBeaver
- **MySQL/MariaDB:** phpMyAdmin, MySQL Workbench, DBeaver
- **MongoDB:** MongoDB Compass, Robo 3T
- **Redis:** RedisInsight, Redis Commander

### Monitoring
- **PostgreSQL:** pg_stat_statements, pgBadger
- **MySQL/MariaDB:** MySQL Enterprise Monitor, Percona Monitoring
- **MongoDB:** MongoDB Atlas, Ops Manager
- **Redis:** Redis CLI INFO, RedisInsight
