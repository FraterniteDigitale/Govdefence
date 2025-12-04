#!/bin/bash
# ==========================================================================
# GovDefence v8.0 – OSINT & Honeypot Suite
# Production Ready – Secure & Optimized
# ==========================================================================

# ========= Chargement Configuration =========
CONFIG_FILE="config.env"
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo -e "\e[31m[⚠] Aucune configuration trouvée ($CONFIG_FILE).\nVeuillez créer ce fichier pour définir vos clés API.\e[0m"
fi

# ========= Couleurs =========
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; CYAN="\e[36m"; MAGENTA="\e[35m"; RESET="\e[0m"; BOLD="\e[1m"

# ========= Effet machine à écrire =========
typewrite() {
  text="$1"; delay="${2:-0.01}"
  for ((i=0; i<${#text}; i++)); do echo -n "${text:$i:1}"; sleep $delay; done; echo
}

# ========= Pause Uniformisée =========
pause() { read -rp "Appuyez sur Entrée pour continuer... "; }

# ========= Logging =========
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date '+%F').log"
log() { echo "[$(date '+%F %T')] $1" >> "$LOG_FILE"; }

# ========= Bannière Futuriste =========
banner() {
  clear; echo -e "${MAGENTA}"
  cat << "EOF"
██████╗  ██████╗ ██╗   ██╗██████╗ ███████╗███████╗███╗   ██╗
██╔══██╗██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝████╗  ██║
██████╔╝██║   ██║██║   ██║██║  ██║█████╗  █████╗  ██╔██╗ ██║
██╔═══╝ ██║   ██║██║   ██║██║  ██║██╔══╝  ██╔══╝  ██║╚██╗██║
██║     ╚██████╔╝╚██████╔╝██████╔╝███████╗███████╗██║ ╚████║
╚═╝      ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝
EOF
  echo -e "${CYAN}${BOLD}GovDefence v8.0 – FULL PACK FINAL${RESET}\n"
  echo -e "Logs : ${YELLOW}$LOG_FILE${RESET}\n"
}

# ========= Détection Environnement =========
detect_env() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if uname -a | grep -qi microsoft; then
      ENVIRON="WSL2"
    elif [[ -n "$PREFIX" && "$PREFIX" == *com.termux* ]]; then
      ENVIRON="Termux"
    else
      ENVIRON="Linux"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    ENVIRON="iSH"
  else
    ENVIRON="Unknown"
  fi
  echo -e "${YELLOW}[i] Environnement détecté : $ENVIRON${RESET}"
  log "Environnement détecté : $ENVIRON"
}

# ========= Vérif dépendances dynamiques =========
check_deps() {
  case $ENVIRON in
    iSH)    required=(curl jq whois dig) ;;
    Termux) required=(curl jq tor nmap whatweb openssl) ;;
    WSL2)   required=(curl jq tor nmap whatweb openssl dig) ;;
    Linux)  required=(curl jq tor nmap whatweb openssl dig cowrie) ;;
    *)      required=(curl jq) ;;
  esac

  for dep in "${required[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      echo -e "${RED}⚠ Manquant : $dep${RESET}"
      log "Dépendance manquante : $dep"
    fi
  done
}

# ========= Modules =========
recon_domain() {
  read -rp "🌐 Domaine : " dom
  [[ -z "$dom" ]] && { echo -e "${RED}❌ Domaine invalide${RESET}"; return; }
  typewrite "[+] DNS Recon $dom"
  result=$(curl -s --fail "https://cloudflare-dns.com/dns-query?name=$dom&type=A" -H "accept: application/dns-json" 2>/dev/null | jq '.Answer')
  if [[ $? -ne 0 || -z "$result" ]]; then
    echo -e "${RED}❌ Erreur API DNS${RESET}"
    log "Erreur DNS recon pour $dom"
  else
    echo "$result"
    log "Recon Domaine $dom : $result"
  fi
  [[ "$ENVIRON" != "iSH" ]] && { echo -e "${CYAN}[+] CMS:${RESET}"; whatweb -q "$dom" | tee -a "$LOG_FILE"; }
}

recon_ip() {
  read -rp "🔎 IP : " ip
  [[ -z "$ip" ]] && { echo -e "${RED}❌ IP invalide${RESET}"; return; }
  typewrite "[+] GEO IP $ip"
  result=$(curl -s --fail "https://ipinfo.io/$ip/json" 2>/dev/null | jq .)
  if [[ $? -ne 0 || -z "$result" ]]; then
    echo -e "${RED}❌ Erreur API IPinfo${RESET}"
    log "Erreur GeoIP pour $ip"
  else
    echo "$result"
    log "Recon IP $ip : $result"
  fi
  [[ "$ENVIRON" != "iSH" ]] && { echo -e "${CYAN}[+] Scan Ports${RESET}"; nmap -Pn --top-ports 20 "$ip" | grep tcp | tee -a "$LOG_FILE"; }
}

recon_email() {
  read -rp "📧 Email : " em
  [[ -z "$em" ]] && { echo -e "${RED}❌ Email invalide${RESET}"; return; }
  typewrite "[+] Checking OSINT leaks for $em"
  if [[ -z "$LEAK_API" ]]; then
    echo -e "${RED}⚠ API LEAK-LOOKUP non définie (voir config.env)${RESET}"
    return
  fi
  result=$(curl -s --fail "https://leak-lookup.com/api/search?key=$LEAK_API&q=$em" | jq .)
  [[ $? -eq 0 ]] && echo "$result" && log "Leak Lookup $em : $result" || echo -e "${RED}❌ Erreur API Leak-Lookup${RESET}"
}

recon_phone() {
  read -rp "📱 Numéro International : " phone
  [[ -z "$phone" ]] && { echo -e "${RED}❌ Numéro invalide${RESET}"; return; }
  typewrite "[+] Phone Intelligence $phone"
  if [[ -z "$NUMVERIFY_API" ]]; then
    echo -e "${RED}⚠ API NUMVERIFY non configurée (voir config.env)${RESET}"
    return
  fi
  result=$(curl -s --fail "http://apilayer.net/api/validate?access_key=$NUMVERIFY_API&number=$phone" | jq .)
  [[ $? -eq 0 ]] && echo "$result" && log "Phone Lookup $phone : $result" || echo -e "${RED}❌ Erreur API NumVerify${RESET}"
}

honeypot_status() {
  [[ "$ENVIRON" == "Linux" ]] || { echo -e "${RED}❌ Honeypot non supporté ($ENVIRON)${RESET}"; return; }
  if pgrep -f "cowrie" >/dev/null; then
    echo -e "${GREEN}[✔] Honeypot actif${RESET}"
    log "Honeypot actif"
  else
    echo -e "${RED}[✖] Honeypot inactif${RESET}"
    log "Honeypot inactif"
  fi
}

honeypot_start() {
  [[ "$ENVIRON" == "Linux" ]] || { echo -e "${RED}❌ Honeypot uniquement sous Linux${RESET}"; return; }
  echo -e "${YELLOW}⚡ Démarrage Cowrie Honeypot...${RESET}"
  nohup cowrie > /dev/null 2>&1 & sleep 3
  honeypot_status
}

honeypot_logs() {
  [[ "$ENVIRON" == "Linux" ]] || { echo -e "${RED}❌ Honeypot non supporté${RESET}"; return; }
  tail -n 15 /var/lib/cowrie/log/cowrie.log 2>/dev/null || echo "No logs yet"
}

# ========= Menu =========
menu() {
  while true; do
    banner
    echo -e "${GREEN}[1] Recon Domaine${RESET}"
    echo -e "${GREEN}[2] Recon IP${RESET}"
    [[ "$ENVIRON" != "iSH" ]] && echo -e "${GREEN}[3] Recon Email${RESET}"
    [[ "$ENVIRON" != "iSH" ]] && echo -e "${GREEN}[4] Recon Téléphone${RESET}"
    [[ "$ENVIRON" == "Linux" ]] && echo -e "${CYAN}[5] Honeypot Status${RESET}"
    [[ "$ENVIRON" == "Linux" ]] && echo -e "${CYAN}[6] Start Honeypot${RESET}"
    [[ "$ENVIRON" == "Linux" ]] && echo -e "${CYAN}[7] Logs Honeypot${RESET}"
    echo -e "${RED}[0] Quitter${RESET}"
    read -rp "Choix ➤ " c
    case $c in
      1) recon_domain; pause ;;
      2) recon_ip; pause ;;
      3) recon_email; pause ;;
      4) recon_phone; pause ;;
      5) honeypot_status; pause ;;
      6) honeypot_start; pause ;;
      7) honeypot_logs; pause ;;
      0) typewrite "🚪 Fermeture session GovDefence."; log "Session terminée."; exit 0 ;;
      *) echo -e "${RED}❌ Choix invalide${RESET}"; sleep 1;;
    esac
  done
}

# ========= Main =========
detect_env
check_deps
menu
