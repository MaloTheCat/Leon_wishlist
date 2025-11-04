# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Début du seeding..."

Gift.destroy_all
Wishlist.destroy_all
User.destroy_all
Family.destroy_all

family = Family.create!(
  name: "Famille Dupont"
)
puts "✅ Famille créée : #{family.name} (Code: #{family.invite_code})"

users = []

user1 = User.create!(
  first_name: "Jean",
  last_name: "Dupont",
  email: "jean@example.com",
  password: "password123",
  password_confirmation: "password123",
  family: family,
  has_filled_list: true
)
users << user1
puts "✅ Utilisateur créé : #{user1.full_name}"

user2 = User.create!(
  first_name: "Marie",
  last_name: "Dupont",
  email: "marie@example.com",
  password: "password123",
  password_confirmation: "password123",
  family: family,
  has_filled_list: true
)
users << user2
puts "✅ Utilisateur créé : #{user2.full_name}"

user3 = User.create!(
  first_name: "Pierre",
  last_name: "Dupont",
  email: "pierre@example.com",
  password: "password123",
  password_confirmation: "password123",
  family: family,
  has_filled_list: true
)
users << user3
puts "✅ Utilisateur créé : #{user3.full_name}"

wishlist1 = Wishlist.create!(
  title: "Ma liste de Noël 2025",
  description: "Mes idées cadeaux pour cette année",
  year: 2025,
  is_public: true,
  user: user1,
  family: family
)
puts "✅ Wishlist créée : #{wishlist1.title}"

wishlist2 = Wishlist.create!(
  title: "Liste de Noël de Marie",
  description: "Quelques idées...",
  year: 2025,
  is_public: true,
  user: user2,
  family: family
)
puts "✅ Wishlist créée : #{wishlist2.title}"

wishlist3 = Wishlist.create!(
  title: "Cadeaux de Pierre - Noël 2025",
  year: 2025,
  is_public: true,
  user: user3,
  family: family
)
puts "✅ Wishlist créée : #{wishlist3.title}"

Gift.create!([
  {
    name: "Livre : Le Seigneur des Anneaux",
    price: 29.99,
    link: "https://www.amazon.fr/seigneur-anneaux",
    wishlist: wishlist1
  },
  {
    name: "Casque Bluetooth Sony",
    price: 89.99,
    link: "https://www.fnac.com/casque-sony",
    wishlist: wishlist1,
    reserved_by: user2
  },
  {
    name: "Coffret de thé",
    price: 35.00,
    wishlist: wishlist1
  },
  {
    name: "Montre connectée",
    price: 199.99,
    link: "https://www.apple.com/watch",
    wishlist: wishlist1,
    reserved_by: user3
  }
])
puts "✅ 4 cadeaux créés pour #{user1.full_name}"

Gift.create!([
  {
    name: "Sac à main Michael Kors",
    price: 250.00,
    link: "https://www.michaelkors.com",
    wishlist: wishlist2
  },
  {
    name: "Parfum Chanel N°5",
    price: 89.00,
    wishlist: wishlist2,
    reserved_by: user1
  },
  {
    name: "Cours de yoga (10 séances)",
    price: 150.00,
    wishlist: wishlist2
  },
  {
    name: "Bougie parfumée Diptyque",
    price: 65.00,
    link: "https://www.diptyqueparis.com",
    wishlist: wishlist2,
    reserved_by: user3
  },
  {
    name: "Écharpe en cachemire",
    price: 120.00,
    wishlist: wishlist2
  }
])
puts "✅ 5 cadeaux créés pour #{user2.full_name}"

Gift.create!([
  {
    name: "PlayStation 5",
    price: 499.99,
    link: "https://www.playstation.com",
    wishlist: wishlist3
  },
  {
    name: "Chaussures de running Nike",
    price: 120.00,
    link: "https://www.nike.com",
    wishlist: wishlist3,
    reserved_by: user1
  },
  {
    name: "Abonnement Spotify Premium (1 an)",
    price: 119.88,
    wishlist: wishlist3,
    reserved_by: user2
  }
])

puts "\n🎉 Seeding terminé !"
puts "\n📝 Informations de connexion :"
puts "Email: jean@example.com | Mot de passe: password123"
puts "Email: marie@example.com | Mot de passe: password123"
puts "Email: pierre@example.com | Mot de passe: password123"
puts "\n🔑 Code d'invitation de la famille : #{family.invite_code}"
