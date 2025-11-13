# 📊 Monitoring - Prometheus & Grafana

## 📋 Table des Matières
- [Introduction au Monitoring](#introduction-au-monitoring)
- [Prometheus](#prometheus)
  - [Installation](#installation-prometheus)
  - [Configuration](#configuration-prometheus)
  - [PromQL](#promql---langage-de-requête)
  - [Exporters](#exporters)
  - [AlertManager](#alertmanager)
- [Grafana](#grafana)
  - [Installation](#installation-grafana)
  - [Configuration](#configuration-grafana)
  - [Dashboards](#dashboards)
  - [Alertes](#alertes-grafana)
- [Stack complète](#stack-complète-de-monitoring)
- [Cas d'usage pratiques](#cas-dusage-pratiques)
- [Bonnes pratiques](#bonnes-pratiques)
- [Troubleshooting](#troubleshooting)
- [Ressources](#ressources)

---

## Introduction au Monitoring

### Pourquoi monitorer ?

Le monitoring est **essentiel** pour :
- 🔍 **Détecter les problèmes** avant qu'ils n'impactent les utilisateurs
- 📈 **Analyser les performances** et optimiser
- 🚨 **Alerter** l'équipe en cas d'incident
- 📊 **Prendre des décisions** basées sur les données
- 🔄 **Respecter les SLAs** (Service Level Agreements)

### Types de monitoring

```
┌─────────────────────────────────────────────┐
│ Infrastructure Monitoring                   │
│ ├─ CPU, RAM, Disk, Network                 │
│ └─ Services système                         │
├─────────────────────────────────────────────┤
│ Application Monitoring                      │
│ ├─ Métriques métier (requests, errors)     │
│ └─ Performance (latency, throughput)       │
├─────────────────────────────────────────────┤
│ Log Monitoring                              │
│ ├─ Logs applicatifs                        │
│ └─ Logs système                             │
└─────────────────────────────────────────────┘
```

### Les 4 Golden Signals (Google SRE)

1. **Latency** : Temps de réponse des requêtes
2. **Traffic** : Demande sur le système
3. **Errors** : Taux d'erreur des requêtes
4. **Saturation** : Utilisation des ressources

### Architecture Prometheus + Grafana

```
┌──────────────┐    scrape     ┌────────────┐
│   Targets    │ ◄──────────── │ Prometheus │
│ (Exporters)  │               │   Server   │
└──────────────┘               └──────┬─────┘
                                      │
                                      │ query
                                      ▼
                               ┌──────────────┐
                               │   Grafana    │
                               │  Dashboard   │
                               └──────────────┘
```

---

## Prometheus

### Qu'est-ce que Prometheus ?

**Prometheus** est un système de monitoring et d'alerting open-source créé par SoundCloud.

**Caractéristiques** :
- ✅ Modèle de données basé sur des **time-series**
- ✅ Langage de requête puissant : **PromQL**
- ✅ Architecture **pull-based** (scraping)
- ✅ Service discovery automatique
- ✅ Pas de dépendance à un stockage distribué

### Installation Prometheus

#### Via Docker

```bash
# Lancer Prometheus
docker run -d \
  --name prometheus \
  -p 9090:9090 \
  -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus

# Accéder à l'interface
http://localhost:9090
```

#### Via Docker Compose

**docker-compose.yml**
```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    restart: unless-stopped

volumes:
  prometheus_data:
```

#### Installation native (Ubuntu/Debian)

```bash
# Créer un utilisateur système
sudo useradd --no-create-home --shell /bin/false prometheus

# Télécharger Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.48.0/prometheus-2.48.0.linux-amd64.tar.gz

# Extraire
tar -xvf prometheus-2.48.0.linux-amd64.tar.gz
cd prometheus-2.48.0.linux-amd64

# Copier les binaires
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

# Créer les dossiers
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

# Copier les fichiers de config
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus/

# Changer les permissions
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Créer le service systemd
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Démarrer Prometheus
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus
```

### Configuration Prometheus

**prometheus.yml (configuration de base)**
```yaml
global:
  scrape_interval: 15s      # Fréquence de scraping
  evaluation_interval: 15s  # Fréquence d'évaluation des règles
  external_labels:
    cluster: 'production'
    region: 'eu-west-1'

# Configuration des alertes
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - 'alertmanager:9093'

# Règles d'alerte et d'enregistrement
rule_files:
  - 'alerts/*.yml'
  - 'rules/*.yml'

# Configuration des cibles à scraper
scrape_configs:
  # Prometheus lui-même
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter (métriques système)
  - job_name: 'node'
    static_configs:
      - targets: 
          - 'node-exporter:9100'
        labels:
          env: 'production'
          role: 'web'

  # Application custom
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:8080']
    metrics_path: '/metrics'
    scrape_interval: 10s
```

**Configuration avancée avec service discovery**
```yaml
scrape_configs:
  # Découverte automatique Kubernetes
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__

  # Découverte Docker
  - job_name: 'docker'
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
    relabel_configs:
      - source_labels: [__meta_docker_container_label_monitoring]
        action: keep
        regex: true

  # Découverte Consul
  - job_name: 'consul-services'
    consul_sd_configs:
      - server: 'consul:8500'
        services: []
```

### PromQL - Langage de requête

#### Syntaxe de base

```promql
# Métrique simple
http_requests_total

# Avec labels
http_requests_total{job="api", status="200"}

# Opérateurs de comparaison
http_requests_total > 100
http_requests_total{status="500"} > 0

# Range vector (dernières 5 minutes)
http_requests_total[5m]

# Rate (requêtes par seconde)
rate(http_requests_total[5m])

# Somme
sum(http_requests_total)

# Somme par label
sum by (status) (http_requests_total)
```

#### Fonctions courantes

```promql
# RATE - Taux de changement par seconde
rate(http_requests_total[5m])

# INCREASE - Augmentation sur une période
increase(http_requests_total[1h])

# AVG - Moyenne
avg(node_cpu_seconds_total)

# MAX/MIN
max(node_memory_usage_bytes)
min(node_memory_usage_bytes)

# HISTOGRAM - Percentiles
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# PREDICT_LINEAR - Prédiction
predict_linear(node_filesystem_free_bytes[1h], 4 * 3600) < 0
```

#### Exemples pratiques

```promql
# CPU usage en pourcentage
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Mémoire disponible en pourcentage
(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

# Requêtes HTTP par seconde
sum(rate(http_requests_total[5m])) by (status)

# Taux d'erreur HTTP (%)
(sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))) * 100

# P95 latency
histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))

# Top 5 des endpoints les plus lents
topk(5, avg(http_request_duration_seconds) by (endpoint))

# Prédiction de saturation disque
predict_linear(node_filesystem_avail_bytes[1h], 4 * 3600) < 0
```

### Exporters

Les exporters exposent des métriques dans un format que Prometheus peut scraper.

#### Node Exporter (métriques système)

```bash
# Docker
docker run -d \
  --name node-exporter \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  prom/node-exporter \
  --path.rootfs=/host

# Installation native
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.7.0.linux-amd64.tar.gz
sudo cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/

# Service systemd
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start node_exporter
sudo systemctl enable node_exporter
```

**Métriques Node Exporter** :
```promql
node_cpu_seconds_total        # CPU
node_memory_MemAvailable_bytes # RAM
node_disk_io_time_seconds_total # Disk I/O
node_network_receive_bytes_total # Network
node_filesystem_avail_bytes   # Filesystem
```

#### Exporters populaires

**PostgreSQL Exporter**
```bash
docker run -d \
  --name postgres-exporter \
  -p 9187:9187 \
  -e DATA_SOURCE_NAME="postgresql://user:password@postgres:5432/dbname?sslmode=disable" \
  prometheuscommunity/postgres-exporter
```

**MySQL Exporter**
```bash
docker run -d \
  --name mysql-exporter \
  -p 9104:9104 \
  -e DATA_SOURCE_NAME="user:password@(mysql:3306)/" \
  prom/mysqld-exporter
```

**Redis Exporter**
```bash
docker run -d \
  --name redis-exporter \
  -p 9121:9121 \
  oliver006/redis_exporter \
  --redis.addr=redis://redis:6379
```

**Nginx Exporter**
```bash
docker run -d \
  --name nginx-exporter \
  -p 9113:9113 \
  nginx/nginx-prometheus-exporter:latest \
  -nginx.scrape-uri=http://nginx:8080/stub_status
```

**Blackbox Exporter (monitoring externe)**
```bash
docker run -d \
  --name blackbox-exporter \
  -p 9115:9115 \
  -v $(pwd)/blackbox.yml:/config/blackbox.yml \
  prom/blackbox-exporter \
  --config.file=/config/blackbox.yml
```

**blackbox.yml**
```yaml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_status_codes: []
      method: GET
      preferred_ip_protocol: "ip4"
  
  tcp_connect:
    prober: tcp
    timeout: 5s
```

#### Instrumenter votre application

**Python (Flask)**
```python
from prometheus_client import Counter, Histogram, generate_latest
from flask import Flask, Response
import time

app = Flask(__name__)

# Métriques
REQUEST_COUNT = Counter(
    'http_requests_total', 
    'Total HTTP Requests',
    ['method', 'endpoint', 'status']
)

REQUEST_LATENCY = Histogram(
    'http_request_duration_seconds',
    'HTTP Request Latency',
    ['method', 'endpoint']
)

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    latency = time.time() - request.start_time
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.endpoint,
        status=response.status_code
    ).inc()
    REQUEST_LATENCY.labels(
        method=request.method,
        endpoint=request.endpoint
    ).observe(latency)
    return response

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

**Node.js (Express)**
```javascript
const express = require('express');
const client = require('prom-client');

const app = express();

// Créer un registre
const register = new client.Registry();

// Métriques par défaut
client.collectDefaultMetrics({ register });

// Métriques custom
const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status'],
  registers: [register]
});

const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'route'],
  registers: [register]
});

// Middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestCounter.inc({
      method: req.method,
      route: req.route?.path || req.path,
      status: res.statusCode
    });
    httpRequestDuration.observe({
      method: req.method,
      route: req.route?.path || req.path
    }, duration);
  });
  next();
});

// Endpoint metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.listen(8080);
```

**Go**
```go
package main

import (
    "net/http"
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    httpRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total HTTP requests",
        },
        []string{"method", "endpoint", "status"},
    )
    
    httpRequestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "http_request_duration_seconds",
            Help: "HTTP request duration",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "endpoint"},
    )
)

func init() {
    prometheus.MustRegister(httpRequestsTotal)
    prometheus.MustRegister(httpRequestDuration)
}

func main() {
    http.Handle("/metrics", promhttp.Handler())
    http.ListenAndServe(":8080", nil)
}
```

### AlertManager

AlertManager gère les alertes envoyées par Prometheus.

#### Installation

```bash
# Docker
docker run -d \
  --name alertmanager \
  -p 9093:9093 \
  -v /path/to/alertmanager.yml:/etc/alertmanager/alertmanager.yml \
  prom/alertmanager
```

#### Configuration AlertManager

**alertmanager.yml**
```yaml
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'

# Templates personnalisés
templates:
  - '/etc/alertmanager/templates/*.tmpl'

# Routage des alertes
route:
  receiver: 'default'
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  
  routes:
    # Alertes critiques
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true
    
    # Alertes warning
    - match:
        severity: warning
      receiver: 'slack'
    
    # Alertes par équipe
    - match:
        team: frontend
      receiver: 'frontend-team'
    
    - match:
        team: backend
      receiver: 'backend-team'

# Inhibition (éviter les alertes redondantes)
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'instance']

# Receivers (destinations des alertes)
receivers:
  - name: 'default'
    email_configs:
      - to: 'team@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alerts@example.com'
        auth_password: 'password'

  - name: 'slack'
    slack_configs:
      - channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
        send_resolved: true

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_SERVICE_KEY'
        severity: '{{ .GroupLabels.severity }}'
        description: '{{ .GroupLabels.alertname }}'

  - name: 'frontend-team'
    slack_configs:
      - channel: '#frontend-alerts'
        send_resolved: true

  - name: 'backend-team'
    slack_configs:
      - channel: '#backend-alerts'
        send_resolved: true
```

#### Règles d'alerte

**alerts/node_alerts.yml**
```yaml
groups:
  - name: node_alerts
    interval: 30s
    rules:
      # CPU usage élevé
      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "CPU usage élevé sur {{ $labels.instance }}"
          description: "CPU usage est à {{ $value }}% depuis plus de 5 minutes"

      # Mémoire faible
      - alert: LowMemory
        expr: (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100 < 10
        for: 5m
        labels:
          severity: critical
          team: infrastructure
        annotations:
          summary: "Mémoire disponible faible sur {{ $labels.instance }}"
          description: "Seulement {{ $value }}% de mémoire disponible"

      # Disque presque plein
      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes{fstype!~"tmpfs|fuse.lxcfs"} / node_filesystem_size_bytes) * 100 < 10
        for: 10m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Espace disque faible sur {{ $labels.instance }}"
          description: "{{ $labels.mountpoint }} a seulement {{ $value }}% d'espace libre"

      # Prédiction saturation disque
      - alert: DiskWillFillIn4Hours
        expr: predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs"}[1h], 4 * 3600) < 0
        for: 5m
        labels:
          severity: warning
          team: infrastructure
        annotations:
          summary: "Disque sera plein dans 4h sur {{ $labels.instance }}"
          description: "{{ $labels.mountpoint }} sera plein dans environ 4 heures"
```

**alerts/app_alerts.yml**
```yaml
groups:
  - name: application_alerts
    interval: 15s
    rules:
      # Taux d'erreur élevé
      - alert: HighErrorRate
        expr: (sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))) * 100 > 5
        for: 5m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "Taux d'erreur HTTP élevé"
          description: "Taux d'erreur 5xx est à {{ $value }}%"

      # Latence élevée
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "Latence P95 élevée"
          description: "P95 latency est à {{ $value }}s"

      # Service down
      - alert: ServiceDown
        expr: up{job="my-app"} == 0
        for: 1m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "Service {{ $labels.job }} est DOWN"
          description: "Le service {{ $labels.job }} sur {{ $labels.instance }} est inaccessible"

      # Trop de requêtes
      - alert: HighTraffic
        expr: sum(rate(http_requests_total[5m])) > 1000
        for: 5m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "Trafic élevé détecté"
          description: "{{ $value }} requêtes par seconde"
```

---

## Grafana

### Qu'est-ce que Grafana ?

**Grafana** est une plateforme open-source de visualisation et d'analyse de métriques.

**Caractéristiques** :
- ✅ Dashboards interactifs et personnalisables
- ✅ Support de multiples sources de données
- ✅ Système d'alerting intégré
- ✅ Gestion d'équipes et permissions
- ✅ Templating et variables

### Installation Grafana

#### Via Docker

```bash
docker run -d \
  --name grafana \
  -p 3000:3000 \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana-oss

# Accéder à l'interface
# URL: http://localhost:3000
# User: admin
# Password: admin
```

#### Via Docker Compose (avec Prometheus)

**docker-compose.yml**
```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./alerts:/etc/prometheus/alerts
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
    restart: unless-stopped
    networks:
      - monitoring

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin123
      - GF_INSTALL_PLUGINS=grafana-clock-panel
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    depends_on:
      - prometheus
    restart: unless-stopped
    networks:
      - monitoring

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    restart: unless-stopped
    networks:
      - monitoring

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager_data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
    restart: unless-stopped
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data:
  grafana_data:
  alertmanager_data:
```

#### Installation native (Ubuntu/Debian)

```bash
# Ajouter le repo Grafana
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Installer
sudo apt-get update
sudo apt-get install grafana

# Démarrer
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server

# Accéder à l'interface
# URL: http://localhost:3000
# User: admin
# Password: admin
```

### Configuration Grafana

#### Provisioning automatique

**grafana/provisioning/datasources/prometheus.yml**
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
    jsonData:
      timeInterval: "15s"
      httpMethod: POST
```

**grafana/provisioning/dashboards/dashboard.yml**
```yaml
apiVersion: 1

providers:
  - name: 'Default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    editable: true
    options:
      path: /etc/grafana/provisioning/dashboards
```

#### Configuration avancée

**grafana.ini**
```ini
[server]
protocol = http
http_port = 3000
domain = grafana.example.com
root_url = %(protocol)s://%(domain)s:%(http_port)s/

[database]
type = postgres
host = postgres:5432
name = grafana
user = grafana
password = password

[auth]
disable_login_form = false

[auth.anonymous]
enabled = false

[smtp]
enabled = true
host = smtp.gmail.com:587
user = alerts@example.com
password = password
from_address = alerts@example.com
from_name = Grafana

[alerting]
enabled = true
execute_alerts = true
```

### Dashboards

#### Créer un Dashboard

1. **Via l'interface web** :
   - Cliquer sur "+" → "Dashboard"
   - "Add new panel"
   - Configurer la requête PromQL
   - Sélectionner le type de visualisation
   - Sauvegarder

2. **Via JSON** :

**dashboard_node_exporter.json**
```json
{
  "dashboard": {
    "title": "Node Exporter Full",
    "tags": ["prometheus", "node-exporter"],
    "timezone": "browser",
    "panels": [
      {
        "id": 1,
        "title": "CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{ instance }}"
          }
        ],
        "yaxes": [
          {
            "format": "percent",
            "min": 0,
            "max": 100
          }
        ]
      },
      {
        "id": 2,
        "title": "Memory Usage",
        "type": "gauge",
        "targets": [
          {
            "expr": "100 - ((node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100)"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "unit": "percent",
            "min": 0,
            "max": 100,
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {"value": 0, "color": "green"},
                {"value": 70, "color": "yellow"},
                {"value": 90, "color": "red"}
              ]
            }
          }
        }
      }
    ]
  }
}
```

#### Dashboards recommandés

**ID de dashboards communautaires** :
```bash
# Node Exporter Full
Dashboard ID: 1860

# Docker Monitoring
Dashboard ID: 893

# Kubernetes Cluster Monitoring
Dashboard ID: 7249

# Nginx Metrics
Dashboard ID: 12708

# PostgreSQL Database
Dashboard ID: 9628

# MySQL Overview
Dashboard ID: 7362
```

**Importer un dashboard** :
1. Aller dans "+" → "Import"
2. Entrer l'ID du dashboard
3. Sélectionner la source de données Prometheus
4. "Import"

#### Variables de Dashboard

**Créer des variables dynamiques** :
```
Name: instance
Type: Query
Query: label_values(node_uname_info, instance)
Refresh: On Dashboard Load

Name: job
Type: Query
Query: label_values(up, job)
```

**Utiliser dans les requêtes** :
```promql
up{instance="$instance", job="$job"}
```

### Alertes Grafana

#### Créer une alerte

**Via l'interface** :
1. Éditer un panel
2. Aller dans l'onglet "Alert"
3. "Create Alert"
4. Définir les conditions

**Exemple d'alerte** :
```
Name: High CPU Alert
Condition: 
  WHEN avg() OF query(A, 5m, now) 
  IS ABOVE 80

Notifications:
  - Slack Channel
  - Email Team
```

#### Configuration des canaux de notification

**Slack**
```json
{
  "url": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
  "recipient": "#alerts",
  "username": "Grafana",
  "icon_emoji": ":grafana:",
  "mentionChannel": "here"
}
```

**Email**
```
Addresses: team@example.com, oncall@example.com
```

**Webhook**
```
URL: https://api.example.com/webhook
HTTP Method: POST
```

---

## Stack complète de monitoring

### Docker Compose complet

**docker-compose.monitoring.yml**
```yaml
version: '3.8'

services:
  # Prometheus
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ./prometheus/alerts:/etc/prometheus/alerts
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    restart: unless-stopped
    networks:
      - monitoring

  # Grafana
  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin123}
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    depends_on:
      - prometheus
    restart: unless-stopped
    networks:
      - monitoring

  # Node Exporter
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    ports:
      - "9100:9100"
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    restart: unless-stopped
    networks:
      - monitoring

  # cAdvisor - Container metrics
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    privileged: true
    restart: unless-stopped
    networks:
      - monitoring

  # AlertManager
  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    ports:
      - "9093:9093"
    volumes:
      - ./alertmanager/alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager_data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
    restart: unless-stopped
    networks:
      - monitoring

  # Blackbox Exporter
  blackbox-exporter:
    image: prom/blackbox-exporter:latest
    container_name: blackbox-exporter
    ports:
      - "9115:9115"
    volumes:
      - ./blackbox/blackbox.yml:/etc/blackbox/blackbox.yml
    command:
      - '--config.file=/etc/blackbox/blackbox.yml'
    restart: unless-stopped
    networks:
      - monitoring

  # PostgreSQL Exporter (si vous avez PostgreSQL)
  postgres-exporter:
    image: prometheuscommunity/postgres-exporter:latest
    container_name: postgres-exporter
    ports:
      - "9187:9187"
    environment:
      - DATA_SOURCE_NAME=postgresql://user:password@postgres:5432/dbname?sslmode=disable
    restart: unless-stopped
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge

volumes:
  prometheus_data:
  grafana_data:
  alertmanager_data:
```

### Démarrage

```bash
# Lancer la stack complète
docker-compose -f docker-compose.monitoring.yml up -d

# Vérifier les services
docker-compose -f docker-compose.monitoring.yml ps

# Voir les logs
docker-compose -f docker-compose.monitoring.yml logs -f

# Arrêter la stack
docker-compose -f docker-compose.monitoring.yml down
```

---

## Cas d'usage pratiques

### Monitoring d'une application web

```promql
# Requêtes par seconde
sum(rate(http_requests_total[5m]))

# Taux d'erreur
(sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m]))) * 100

# P50, P95, P99 latency
histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Top endpoints les plus lents
topk(10, avg by (endpoint) (http_request_duration_seconds))
```

### Monitoring base de données

```promql
# PostgreSQL - Connexions actives
pg_stat_activity_count

# PostgreSQL - Taille de la base
pg_database_size_bytes

# PostgreSQL - Slow queries
rate(pg_stat_statements_mean_time_seconds[5m]) > 1

# MySQL - Requêtes par seconde
rate(mysql_global_status_queries[5m])

# MySQL - Threads connectés
mysql_global_status_threads_connected
```

### Monitoring Kubernetes

```promql
# Pods en état non-running
count(kube_pod_status_phase{phase!="Running"})

# Utilisation CPU par pod
sum(rate(container_cpu_usage_seconds_total[5m])) by (pod)

# Utilisation mémoire par namespace
sum(container_memory_usage_bytes) by (namespace)

# Restarts fréquents
rate(kube_pod_container_status_restarts_total[1h]) > 0
```

### Monitoring réseau

```promql
# Bande passante entrante
rate(node_network_receive_bytes_total[5m])

# Bande passante sortante
rate(node_network_transmit_bytes_total[5m])

# Paquets perdus
rate(node_network_receive_drop_total[5m])

# Connexions TCP
node_netstat_Tcp_CurrEstab
```

---

## Bonnes pratiques

### 1. Nommage des métriques

```
# Convention : type_component_unit
http_requests_total           # ✅
http_request_duration_seconds # ✅
node_memory_usage_bytes       # ✅

requests                      # ❌ Trop vague
http_req                      # ❌ Abréviation
```

### 2. Labels

```promql
# Bonnes pratiques
http_requests_total{method="GET", status="200", endpoint="/api/users"}

# À éviter
http_requests_total{user_id="12345"}  # ❌ Cardinalité trop élevée
http_requests_total{timestamp="..."}  # ❌ Timestamp déjà géré
```

### 3. Rétention des données

```yaml
# prometheus.yml
global:
  # Garder 30 jours de données
  storage.tsdb.retention.time: 30d
  
  # Limite de taille
  storage.tsdb.retention.size: 50GB
```

### 4. Recording Rules

Pour les requêtes lourdes, précalculer les résultats :

```yaml
groups:
  - name: cpu_recording_rules
    interval: 30s
    rules:
      - record: instance:node_cpu_utilization:rate5m
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### 5. Organisation des dashboards

```
/dashboards
├── infrastructure/
│   ├── overview.json
│   ├── nodes.json
│   └── network.json
├── applications/
│   ├── api.json
│   ├── web.json
│   └── workers.json
└── databases/
    ├── postgresql.json
    └── redis.json
```

### 6. Alertes efficaces

```yaml
# ✅ Bon
- alert: HighErrorRate
  expr: rate(http_requests_total{status="500"}[5m]) > 0.05
  for: 5m
  annotations:
    summary: "High error rate on {{ $labels.instance }}"
    description: "Error rate is {{ $value }} req/s"

# ❌ À éviter (alerte trop sensible)
- alert: AnyError
  expr: http_requests_total{status="500"} > 0
  for: 1s
```

### 7. Sécurité

```yaml
# Activer l'authentification
# grafana.ini
[auth.basic]
enabled = true

# Activer HTTPS
[server]
protocol = https
cert_file = /etc/ssl/grafana.crt
cert_key = /etc/ssl/grafana.key

# Prometheus avec basic auth
# prometheus.yml
basic_auth:
  username: admin
  password: secret
```

---

## Troubleshooting

### Prometheus ne scrape pas les targets

```bash
# Vérifier la config
promtool check config prometheus.yml

# Vérifier les targets
curl http://localhost:9090/api/v1/targets

# Logs Prometheus
docker logs prometheus

# Tester manuellement le scraping
curl http://target:9100/metrics
```

### Grafana ne se connecte pas à Prometheus

```bash
# Vérifier la connexion
docker exec grafana curl http://prometheus:9090/api/v1/query?query=up

# Vérifier les logs
docker logs grafana

# Tester la datasource
# Settings → Data Sources → Prometheus → Save & Test
```

### Métriques manquantes

```promql
# Lister toutes les métriques disponibles
{__name__=~".+"}

# Vérifier si une métrique existe
count({__name__="http_requests_total"})

# Voir les labels d'une métrique
http_requests_total
```

### Alertes ne se déclenchent pas

```bash
# Vérifier les règles
promtool check rules alerts/*.yml

# Voir les alertes actives
curl http://localhost:9090/api/v1/alerts

# Tester une alerte
promtool test rules test.yml
```

### Performance dégradée

```bash
# Vérifier l'utilisation mémoire
docker stats prometheus

# Voir le nombre de time series
curl http://localhost:9090/api/v1/status/tsdb

# Réduire la rétention
--storage.tsdb.retention.time=15d

# Augmenter les ressources
docker run -m 4g --cpus=2 prom/prometheus
```

---

## Ressources

### Documentation officielle
- 📖 [Prometheus Docs](https://prometheus.io/docs/)
- 📖 [Grafana Docs](https://grafana.com/docs/)
- 📖 [PromQL Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)

### Outils
- 🛠️ [PromLens](https://promlens.com/) - Query builder
- 🛠️ [Prometheus Playground](https://play.prometheus.io/)
- 🛠️ [Grafana Play](https://play.grafana.org/)

### Dashboards communautaires
- 🎨 [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
- 🎨 [Awesome Prometheus](https://github.com/roaldnefs/awesome-prometheus)

### Exporters
- 📦 [Prometheus Exporters](https://prometheus.io/docs/instrumenting/exporters/)

### Tutoriels
- 📚 [Prometheus Up & Running (Book)](https://www.oreilly.com/library/view/prometheus-up/9781492034131/)
- 📚 [The Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)

---

[⬆ Retour en haut](#-monitoring---prometheus--grafana)
