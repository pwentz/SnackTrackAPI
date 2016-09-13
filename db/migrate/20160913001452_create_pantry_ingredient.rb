class CreatePantryIngredient < ActiveRecord::Migration[5.0]
  def change
    create_table :pantry_ingredients do |t|
      t.references :pantry, foreign_key: true
      t.references :ingredient, foreign_key: true
    end
  end
end
