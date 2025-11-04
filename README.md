# 🎁 Leon Wishlist - MVP

Une application de gestion de listes de cadeaux familiales développée en Ruby on Rails.

## 📋 Description

[VIBECODING TEST] A Christmas list to simplify who gave what. In your account, you can manage your list and edit the lists of other people in the same group. With a simple and quick view, you'll also have the option to import your lists from a file.

## ✨ Fonctionnalités MVP

### Gestion des comptes utilisateurs
- ✅ Inscription avec création ou rejointe d'une famille
- ✅ Connexion / Déconnexion
- ✅ Authentification sécurisée avec `has_secure_password`

### Gestion des familles
- ✅ Création de famille avec code d'invitation unique
- ✅ Rejoindre une famille via code d'invitation
- ✅ Visualisation des membres de la famille

### Gestion des wishlists
- ✅ Créer, éditer, supprimer ses propres listes
- ✅ Rendre une liste publique ou privée
- ✅ Voir les listes des autres membres (si on a publié la sienne)
- ✅ Organisation par année

### Gestion des cadeaux
- ✅ Ajouter, éditer, supprimer des cadeaux dans ses listes
- ✅ Chaque cadeau comporte : nom, prix, lien
- ✅ Réserver un cadeau d'un autre membre
- ✅ Annuler une réservation
- ✅ Le propriétaire de la liste ne voit pas qui a réservé ses cadeaux
- ✅ Les autres membres voient qui a réservé quel cadeau

### Partage
- ✅ Partager une liste par email
- ✅ Email formaté en HTML et texte brut

## 🛠 Technologies

- **Ruby**: 3.0.3
- **Rails**: 7.1.6
- **Base de données**: PostgreSQL
- **Frontend**: Bootstrap 5.3 (via CDN)
- **Authentification**: bcrypt avec `has_secure_password`

## 📦 Installation

### Prérequis
- Ruby 3.0.3
- PostgreSQL
- Bundler

### Étapes d'installation

1. **Cloner le repository**
```bash
git clone [URL_DU_REPO]
cd leon_whishlist
```

2. **Installer les dépendances**
```bash
bundle install
```

3. **Configurer la base de données**
```bash
bin/rails db:create && rails db:migrate && rails db:seed
```

4. **Lancer le serveur**
```bash
bin/rails server
```

5. **Accéder à l'application**
`http://localhost:3000`

## 👥 Comptes de test

Si vous avez exécuté `db:seed`, vous pouvez utiliser ces comptes :

- **Jean Dupont** : `jean@example.com` / `password123`
- **Marie Dupont** : `marie@example.com` / `password123`
- **Pierre Dupont** : `pierre@example.com` / `password123`

Code d'invitation de la famille : Visible dans les logs du seed ou sur la page "Ma Famille"

## 📊 Structure de la base de données

### Modèles

**Family**
- `name`: Nom de la famille
- `invite_code`: Code unique pour rejoindre la famille

**User**
- `first_name`, `last_name`: Nom et prénom
- `email`: Email (unique)
- `password_digest`: Mot de passe chiffré
- `has_filled_list`: Boolean indiquant si l'utilisateur a rempli sa liste
- `family_id`: Référence à la famille

**Wishlist**
- `title`: Titre de la liste
- `description`: Description optionnelle
- `year`: Année de la liste
- `is_public`: Visibilité publique dans la famille
- `user_id`: Propriétaire de la liste
- `family_id`: Famille associée

**Gift**
- `name`: Nom du cadeau
- `price`: Prix estimé (décimal)
- `link`: URL vers le produit
- `reserved_by_id`: Utilisateur qui a réservé le cadeau (optionnel)
- `wishlist_id`: Liste à laquelle appartient le cadeau

## 🎯 Logique métier importante

### Règle de visibilité
Un utilisateur ne peut voir les listes des autres membres de sa famille que s'il a lui-même publié une liste (`has_filled_list = true`).

### Confidentialité des réservations
- Le propriétaire d'une liste **ne voit pas** qui a réservé ses cadeaux
- Les autres membres de la famille **voient** qui a réservé quel cadeau
- Cette logique est implémentée dans la vue `wishlists/show.html.erb`

## 🚀 Prochaines étapes (Hors MVP)

- [ ] Import de listes depuis fichiers CSV, TXT, RTF, DOCX
- [ ] Upload d'images pour les cadeaux
- [ ] Notifications par email
- [ ] Système de recherche et filtres
- [ ] Export de listes en PDF
- [ ] Statistiques et tableaux de bord
- [ ] Tests unitaires et d'intégration
- [ ] Déploiement avec Docker
- [ ] CI/CD avec GitHub Actions

## 📝 Routes principales

```
GET    /                         → wishlists#index (page d'accueil)
GET    /login                    → sessions#new
POST   /login                    → sessions#create
DELETE /logout                   → sessions#destroy
GET    /signup                   → registrations#new
POST   /signup                   → registrations#create

GET    /family                   → families#show
GET    /wishlists                → wishlists#index
GET    /wishlists/:id            → wishlists#show
POST   /wishlists/:id/share      → wishlists#share

POST   /wishlists/:wishlist_id/gifts/:id/reserve    → gifts#reserve
DELETE /wishlists/:wishlist_id/gifts/:id/unreserve  → gifts#unreserve
```

## 🤝 Contribution

Ce projet est un MVP de vibecoding. N'hésitez pas à proposer des améliorations !

---

Code crée façon vibecoding.
