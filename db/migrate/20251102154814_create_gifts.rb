class CreateGifts < ActiveRecord::Migration[7.1]
  def change
    create_table :gifts do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.string :link
      t.integer :reserved_by_id
      t.references :wishlist, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :gifts, :reserved_by_id
  end
end
