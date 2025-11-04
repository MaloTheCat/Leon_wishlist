class CreateWishlists < ActiveRecord::Migration[7.1]
  def change
    create_table :wishlists do |t|
      t.string :title
      t.text :description
      t.integer :year
      t.boolean :is_public, default: false
      t.references :user, null: false, foreign_key: true
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :wishlists, [:user_id, :year]
    add_index :wishlists, [:family_id, :year]
  end
end
