class CreateFamilies < ActiveRecord::Migration[7.1]
  def change
    create_table :families do |t|
      t.string :name
      t.string :invite_code

      t.timestamps
    end
    
    add_index :families, :invite_code, unique: true
  end
end
