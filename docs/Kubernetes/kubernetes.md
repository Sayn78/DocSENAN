# ☸️ Kubernetes – Installation & Configuration (Manuelle)

Ce guide explique comment installer et configurer un cluster Kubernetes (kubeadm) sur des machines Ubuntu (ou équivalent), en mode multi-nœuds (1 master + n workers).

---

## 🔧 Prérequis

- 2+ machines Ubuntu (physiques, VMs ou AWS EC2)
- Accès root ou sudo
- Nom d’hôte unique par machine (`hostnamectl set-hostname`)
- IP fixe ou résolvable entre les nœuds
- Désactivation de swap (`sudo swapoff -a` + commenter dans `/etc/fstab`)

---

## 📦 Étape 1 – Installer les dépendances sur **tous les nœuds**

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl
```

Ajouter la clé GPG de Kubernetes :

```bash
sudo curl -fsSLo /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```

Ajouter le dépôt Kubernetes :

```bash
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

---

## 🧱 Étape 2 – Installer kubelet, kubeadm et kubectl

```bash
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

---

## 🔗 Étape 3 – Activer le routage réseau & modules nécessaires

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

---

## 🧠 Étape 4 – Initialiser le **master node**

Sur le **nœud maître uniquement** :
```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

Une fois terminé, configure `kubectl` :
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

## 🌐 Étape 5 – Installer un plugin réseau (CNI)

Exemple avec **Flannel** :
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

(ou Calico, Weave, Cilium selon le besoin)

---

## ➕ Étape 6 – Joindre les nœuds workers

Sur chaque **nœud worker**, exécute la commande `kubeadm join` donnée à la fin du `kubeadm init`, par exemple :

```bash
sudo kubeadm join 10.0.0.1:6443 --token abcdef.0123456789abcdef     --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxxxxxxxxxxxx
```

---

## ✅ Étape 7 – Vérification

Sur le **master node** :
```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

---

## 🧹 Astuces utiles

- Redémarrer le service kubelet :
```bash
sudo systemctl restart kubelet
```

- Voir les logs du kubelet :
```bash
sudo journalctl -u kubelet -n 100 --no-pager
```

- Réinitialiser le cluster :
```bash
sudo kubeadm reset
```

