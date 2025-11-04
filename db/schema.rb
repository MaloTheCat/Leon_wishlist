# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_11_02_154814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.string "invite_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_code"], name: "index_families_on_invite_code", unique: true
  end

  create_table "gifts", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.string "link"
    t.integer "reserved_by_id"
    t.bigint "wishlist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reserved_by_id"], name: "index_gifts_on_reserved_by_id"
    t.index ["wishlist_id"], name: "index_gifts_on_wishlist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "has_filled_list", default: false
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["family_id"], name: "index_users_on_family_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "year"
    t.boolean "is_public", default: false
    t.bigint "user_id", null: false
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id", "year"], name: "index_wishlists_on_family_id_and_year"
    t.index ["family_id"], name: "index_wishlists_on_family_id"
    t.index ["user_id", "year"], name: "index_wishlists_on_user_id_and_year"
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "gifts", "wishlists"
  add_foreign_key "users", "families"
  add_foreign_key "wishlists", "families"
  add_foreign_key "wishlists", "users"
end
