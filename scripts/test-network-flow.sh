#!/bin/bash
# Test complet du flux réseau - Leon Wishlist
# Ce script peut être exécuté depuis n'importe où et détecte automatiquement le contexte

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Diagnostic complet - Leon Wishlist                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"

# Détection de l'environnement
CURRENT_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$CURRENT_IP" ]; then
    CURRENT_IP=$(ifconfig 2>/dev/null | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
fi

echo ""
echo -e "${BLUE}=== Environnement détecté ===${NC}"
echo "Hostname : $(hostname)"
echo "IP       : $CURRENT_IP"

if [[ "$CURRENT_IP" =~ ^192\.168\.1\.123 ]]; then
    LOCATION="server"
    echo -e "${GREEN}✅ Exécuté depuis le serveur LXC RoR (192.168.1.123)${NC}"
elif [[ "$CURRENT_IP" =~ ^192\.168\.1\. ]]; then
    LOCATION="local-network"
    echo -e "${YELLOW}⚠️  Exécuté depuis le réseau local (pas le serveur LXC)${NC}"
else
    LOCATION="external"
    echo -e "${YELLOW}⚠️  Exécuté depuis l'extérieur du réseau local${NC}"
fi

# Tests selon l'emplacement
if [ "$LOCATION" = "server" ]; then
    echo ""
    echo -e "${BLUE}=== Test 1 : Docker est-il installé ? ===${NC}"
    if command -v docker &> /dev/null; then
        echo -e "${GREEN}✅ Docker installé${NC}"
        docker --version
    else
        echo -e "${RED}❌ Docker non installé${NC}"
        exit 1
    fi

    echo ""
    echo -e "${BLUE}=== Test 2 : Conteneurs Docker ===${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    if docker ps | grep -q leon_wishlist_web; then
        echo -e "${GREEN}✅ Container leon_wishlist_web tourne${NC}"
    else
        echo -e "${RED}❌ Container leon_wishlist_web ne tourne pas${NC}"
        echo "   Lancez : docker compose up -d"
        exit 1
    fi

    echo ""
    echo -e "${BLUE}=== Test 3 : Logs du container web (dernières 20 lignes) ===${NC}"
    docker logs leon_wishlist_web --tail 20

    echo ""
    echo -e "${BLUE}=== Test 4 : Rails répond-il depuis l'intérieur du container ? ===${NC}"
    HTTP_CODE=$(docker exec leon_wishlist_web curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null)
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
        echo -e "${GREEN}✅ Rails répond (HTTP $HTTP_CODE)${NC}"
    else
        echo -e "${RED}❌ Rails ne répond pas (HTTP $HTTP_CODE)${NC}"
    fi

    echo ""
    echo -e "${BLUE}=== Test 5 : Port 3000 accessible depuis le LXC ? ===${NC}"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 2>/dev/null)
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
        echo -e "${GREEN}✅ Port 3000 accessible (HTTP $HTTP_CODE)${NC}"
    else
        echo -e "${RED}❌ Port 3000 non accessible (HTTP $HTTP_CODE)${NC}"
    fi

    echo ""
    echo -e "${BLUE}=== Test 6 : Connectivité PostgreSQL ===${NC}"
    # Vérifier si netcat est disponible
    if docker exec leon_wishlist_web command -v nc &> /dev/null; then
        if docker exec leon_wishlist_web nc -zv 192.168.1.128 5432 2>&1 | grep -q "succeeded\|open"; then
            echo -e "${GREEN}✅ PostgreSQL (192.168.1.128:5432) accessible (test netcat)${NC}"
        else
            echo -e "${RED}❌ PostgreSQL non accessible via netcat${NC}"
        fi
    else
        # Fallback si netcat n'est pas installé
        if docker exec leon_wishlist_web timeout 3 bash -c 'cat < /dev/null > /dev/tcp/192.168.1.128/5432' 2>/dev/null; then
            echo -e "${GREEN}✅ PostgreSQL port 5432 accessible (test /dev/tcp)${NC}"
        else
            echo -e "${YELLOW}⚠️  Test TCP échoué, tentative avec Rails...${NC}"
        fi
    fi
    
    # Test de connexion SQL via Rails
    echo -n "   Test de connexion SQL... "
    PSQL_TEST=$(docker exec leon_wishlist_web rails runner "puts ActiveRecord::Base.connection.execute('SELECT 1').first['?column?'] rescue puts 'ERROR'" 2>&1 | tail -1)
    if [ "$PSQL_TEST" = "1" ]; then
        echo -e "${GREEN}✅ Rails connecté à PostgreSQL${NC}"
    else
        echo -e "${RED}❌ Erreur de connexion Rails${NC}"
    fi

    echo ""
    echo -e "${BLUE}=== Test 7 : Redis ===${NC}"
    if docker exec leon_wishlist_redis redis-cli ping 2>/dev/null | grep -q PONG; then
        echo -e "${GREEN}✅ Redis répond${NC}"
    else
        echo -e "${RED}❌ Redis ne répond pas${NC}"
    fi

    echo ""
    echo -e "${BLUE}=== Test 8 : Variables d'environnement ===${NC}"
    docker exec leon_wishlist_web env | grep -E '^(RAILS_ENV|DATABASE_URL|RAILS_MASTER_KEY|REDIS_URL)' | while read line; do
        if [[ "$line" =~ ^RAILS_MASTER_KEY= ]] || [[ "$line" =~ PASSWORD ]]; then
            echo "${line%%=*}=***SECRET***"
        else
            echo "$line"
        fi
    done

fi

# Tests réseau (depuis n'importe où)
echo ""
echo -e "${BLUE}=== Test 9 : Connectivité réseau de base ===${NC}"
ping -c 2 192.168.1.111 > /dev/null 2>&1 && echo -e "${GREEN}✅ Proxmox (192.168.1.111) accessible${NC}" || echo -e "${RED}❌ Proxmox inaccessible${NC}"
ping -c 2 192.168.1.123 > /dev/null 2>&1 && echo -e "${GREEN}✅ LXC RoR (192.168.1.123) accessible${NC}" || echo -e "${RED}❌ LXC RoR inaccessible${NC}"
ping -c 2 192.168.1.128 > /dev/null 2>&1 && echo -e "${GREEN}✅ LXC PostgreSQL (192.168.1.128) accessible${NC}" || echo -e "${RED}❌ LXC PostgreSQL inaccessible${NC}"

if [[ "$CURRENT_IP" =~ ^192\.168\.1\. ]] && [ "$LOCATION" != "server" ]; then
    echo ""
    echo -e "${BLUE}=== Test 10 : Accès à l'application depuis le réseau local ===${NC}"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://192.168.1.123:3000/ 2>/dev/null)
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
        echo -e "${GREEN}✅ Application accessible sur http://192.168.1.123:3000/ (HTTP $HTTP_CODE)${NC}"
    else
        echo -e "${RED}❌ Application non accessible (HTTP $HTTP_CODE)${NC}"
    fi
fi

# Récapitulatif et prochaines étapes
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Architecture réseau                                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Internet → http://88.170.0.237:32769"
echo "    ↓"
echo "Box Free (redirection NAT)"
echo "    ↓"
echo "192.168.1.123:3000 (Container LXC RoR sur Proxmox)"
echo "    ↓"
echo "Docker (mapping 3000:3000)"
echo "    ↓"
echo "Container leon_wishlist_web:3000 (Rails)"
echo "    ↓"
echo "PostgreSQL (192.168.1.128:5432)"
echo ""

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Configuration requise sur la Box Free                  ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Protocole : TCP"
echo "Port WAN  : 32769"
echo "IP LAN    : 192.168.1.123"
echo "Port LAN  : 3000"
echo ""

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   Tests manuels à effectuer                               ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo -e "${YELLOW}1. Depuis une autre machine du réseau local :${NC}"
echo "   curl -v http://192.168.1.123:3000/"
echo ""
echo -e "${YELLOW}2. Depuis Internet (téléphone en 4G/5G, PAS en WiFi) :${NC}"
echo "   curl -v http://88.170.0.237:32769/"
echo "   ou dans un navigateur : http://88.170.0.237:32769/"
echo ""
echo -e "${YELLOW}3. Si ça ne fonctionne pas depuis Internet :${NC}"
echo "   - Vérifiez la configuration de redirection sur votre Box Free"
echo "   - Vérifiez que le pare-feu de la box autorise le port 32769"
echo "   - Vérifiez qu'aucun autre service n'utilise déjà le port 32769"
echo ""

if [ "$LOCATION" = "server" ]; then
    echo -e "${YELLOW}4. Commandes utiles sur ce serveur :${NC}"
    echo "   docker compose logs -f web          # Voir les logs en temps réel"
    echo "   docker compose restart web          # Redémarrer l'application"
    echo "   docker compose down && docker compose up -d  # Redémarrage complet"
    echo ""
fi
