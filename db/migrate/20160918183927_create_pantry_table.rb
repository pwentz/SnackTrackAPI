class CreatePantryTable < ActiveRecord::Migration[5.0]
  def change
    create_table :pantry_ingredients do |t|
      t.references :user, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.text :unit
      t.integer :amount
    end
  end
end
