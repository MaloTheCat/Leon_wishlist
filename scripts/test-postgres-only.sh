#!/bin/bash
# Test rapide de connexion PostgreSQL depuis le container Docker

echo "=== Test de connexion PostgreSQL depuis leon_wishlist_web ==="
echo ""

echo "Test 1 : Test du port TCP 5432 avec netcat"
if docker exec leon_wishlist_web command -v nc &> /dev/null; then
    docker exec leon_wishlist_web nc -zv 192.168.1.128 5432 2>&1
else
    echo "⚠️  netcat non installé, utilisation de /dev/tcp..."
    docker exec leon_wishlist_web bash -c 'timeout 5 bash -c "cat < /dev/null > /dev/tcp/192.168.1.128/5432 && echo Connexion réussie || echo Connexion échouée"' 2>&1
fi

echo ""
echo "Test 2 : Connexion Rails à la base de données"
docker exec leon_wishlist_web rails runner "puts 'Test connexion DB...'; puts ActiveRecord::Base.connection.execute('SELECT version()').first['version']; puts 'Connexion OK!'" 2>&1

echo ""
echo "Test 3 : Vérifier les variables d'environnement"
docker exec leon_wishlist_web bash -c 'echo "DATABASE_URL=$DATABASE_URL"' | sed 's/:[^@]*@/:***PASSWORD***@/'

echo ""
echo "=== Si tous les tests passent, PostgreSQL est bien accessible ! ==="
