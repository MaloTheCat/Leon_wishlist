class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.boolean :has_filled_list, default: false
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :users, :email, unique: true
  end
end
