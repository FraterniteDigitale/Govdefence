# 🛡️ **GovDefence v8.0** – *OSINT & Honeypot Suite*  
> **"La souveraineté commence par la connaissance."**
> Suite offensive/défensive **éthique**, **multi-environnement**, **production-ready** pour reconnaissance passive et détection active.

![Terminal Futuriste](https://placehold.co/800x200/0a0a0a/00ff88?text=GOVDEFENCE+v8.0+-+SOVEREIGN+CYBER+OPS)

---

## 📦 **Fonctionnalités Clés**

| Module | Description |
|-------|-------------|
| 🔍 **Recon Domaine** | Résolution DNS via Cloudflare (pas de trace), détection CMS avec `whatweb` |
| 🌍 **Recon IP** | Géolocalisation (ipinfo.io) + scan rapide ports (nmap) |
| 📧 **Recon Email** | Vérification de fuites via **Leak-Lookup** (API requise) |
| 📱 **Recon Téléphone** | Validation & géolocalisation via **NumVerify** (API requise) |
| 🎣 **Honeypot (Cowrie)** | Déploiement SSH/ Telnet furtif (Linux uniquement) |
| 📝 **Logging automatique** | Toutes les actions enregistrées dans `logs/YYYY-MM-DD.log` |
| 🌀 **Support multi-OS** | Termux • iSH • WSL2 • Linux natif |

---

## 🌐 **Compatibilité Environnements**

| OS | Support | Honeypot | OSINT complet |
|----|--------|----------|----------------|
| **Linux natif** | ✅ | ✅ | ✅ |
| **WSL2 (Win10/11)** | ✅ | ✅ (avec Docker) | ✅ |
| **Termux (Android)** | ✅ | ❌ | ✅ |
| **iSH (iOS)** | ✅ | ❌ | Partiel (pas de nmap/whatweb) |

> 💡 **Note** : Sur iOS (iSH), seules les requêtes HTTP/JSON sont possibles (pas de scanners réseau).

---

## 🧰 **Installation & Dépendances**

### 1. **Cloner le projet**
```bash
git clone https://github.com/FraterniteDigitale/Govdefence.git
cd Govdefence
chmod +x Govdefence.sh
```

### 2. **Installer les dépendances selon votre OS**

#### 🐧 **Linux (Debian/Ubuntu)**
```bash
sudo apt update && sudo apt install -y curl jq nmap whatweb openssl dnsutils cowrie
```

#### 🪟 **WSL2 (Windows)**
> Installez Ubuntu via Microsoft Store, puis :
```bash
sudo apt install -y curl jq nmap whatweb openssl dnsutils
# Pour Cowrie, voir section Honeypot
```

#### 📱 **Termux (Android)**
```bash
pkg update && pkg install -y curl jq nmap whatweb openssl tor
```

#### 🍏 **iSH (iOS)**
> Déjà limité → installer depuis l’App Store, puis :
```bash
apk add curl jq
# ⚠️ nmap, whatweb, cowrie non disponibles
```

---

## 🔑 **Configuration des API (OBLIGATOIRE pour Email + Téléphone)**

Créez un fichier `config.env` à la racine du projet :

```bash
cp config.env.example config.env  # (optionnel, si fourni)
ou utiliser uniquement la commande suivante si le fichier config.env.example n'est pas founie 
nano config.env
```

### Contenu minimal à ajouter :
```env
# API Leak-Lookup (email breach)
LEAK_API=votre_clé_ici

# API NumVerify (validation téléphone)
NUMVERIFY_API=votre_clé_ici
```

### 🔹 **Obtenir vos clés API**

#### 1. **Leak-Lookup** (email leaks)
- Site : https://leak-lookup.com
- Inscrivez-vous → *Dashboard* → *API Key*
- Gratuit jusqu’à 20 requêtes/jour

#### 2. **NumVerify** (téléphone)
- Site : https://numverify.com
- Inscrivez-vous → *Dashboard* → *API Access Key*
- Gratuit (1 000 requêtes/mois)

> ✅ **Conseil** : Ne jamais committer `config.env` sur Git ! Ajoutez-le à `.gitignore`.

---

## ▶️ **Lancement**

```bash
./Govdefence.sh
```

> Le script détecte automatiquement votre environnement, vérifie les dépendances, et affiche un menu interactif.

---

## 🎣 **Honeypot Cowrie – Linux uniquement**

### Installation complète :
```bash
# Sur Debian/Ubuntu
sudo apt install cowrie
sudo systemctl stop ssh  # Libérer le port 22 (optionnel)
sudo nano /etc/cowrie/cowrie.cfg
```

### Modifier `cowrie.cfg` :
```ini
[honeypot]
listen_port = 2222
# ou 22 (si SSH désactivé)
```

### Démarrage manuel (si pas via systemctl) :
```bash
cd /var/lib/cowrie
sudo -u cowrie cowrie start
```

> Dans **GovDefence**, le menu gère le statut et les logs (`/var/lib/cowrie/log/cowrie.log`).

---

## 📜 **Exemple de Workflow Éthique**

1. **Recon IP publique** d’un serveur que vous administrez → vérifier exposé ?
2. **Tester vos propres emails** pour fuites → durcissement identité numérique
3. **Déployer un honeypot** dans un lab isolé → observer les scanners automatisés
4. **Jamais** scanner une cible sans autorisation légale

> ⚖️ **Rappel légal** : L’OSINT est légal **seulement** sur des données publiques.  
> Le scan actif (nmap) **nécessite un consentement écrit**.

---

## 🗂️ **Structure du Projet**

```
GovDefence/
├── Govdefence.sh          # Script principal
├── config.env             # Vos clés API (à créer)
├── config.env.example     # Modèle (optionnel)
├── logs/                  # Fichiers de logs journaliers
└── README.md              # Ce fichier
```

---

## 🛑 **Bonnes Pratiques de Sécurité**

- Ne jamais exécuter en `root` (sauf honeypot géré par `systemd`)
- Utiliser un **réseau isolé** ou **VM dédiée** pour le honeypot
- Ne pas exposer le honeypot sur internet sans pare-feu
- **Chiffrer** vos logs sensibles (`gpg`, `age`)

---

## ❤️ **Remerciements**

> Ce projet est proposé par la **Fraternité Digitale** — collectif informel de défenseurs de la souveraineté numérique, de l’éthique hacker, et de la résilience citoyenne.

Merci à :
- La communauté **Termux** et **iSH** pour la démocratisation du terminal sur mobile
- **Cowrie Project** pour l’un des meilleurs honeypots opensource
- **Cloudflare**, **ipinfo.io**, **Leak-Lookup**, **NumVerify** pour leurs APIs accessibles
- Toi, qui utilises cet outil **avec responsabilité**

> 🕊️ *"La cybersécurité n’est pas une arme — c’est un droit."*

---

## 📢 **Licence**

Ce projet est sous licence **MIT** — libre d’usage, de modification, et de redistribution, **à condition de respecter le cadre éthique et légal**.

---

## 🚀 **Prochaines Évolutions (Roadmap)**

- Module **Dark Web Monitor** (via Tor + onion services)
- Intégration **Quantum Gov v12** (token mutualisé)
- Export PDF/JSON des rapports
- Mode **Air-Gapped OSINT** (via archive locale de bases de fuites)

---

> ✨ **GO SOVEREIGN. STAY ETHICAL. DEFEND TOGETHER.** ✨

---

📄 **Version** : v8.0 – Décembre 2025  
🌐 **Auteur** : Fraternité Digitale – https://github.com/FraterniteDigitale  
🔐 **Usage** : Lab personnel • Pentest autorisé • Éducation uniquement

---
Dites-nous,on pousse ce projet **encore plus loin**. 💻✊
