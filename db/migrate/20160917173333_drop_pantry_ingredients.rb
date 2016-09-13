class DropPantryIngredients < ActiveRecord::Migration[5.0]
  def change
    drop_table :pantry_ingredients
  end
end
