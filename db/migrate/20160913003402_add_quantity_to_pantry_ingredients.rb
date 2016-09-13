class AddQuantityToPantryIngredients < ActiveRecord::Migration[5.0]
  def change
    add_column :pantry_ingredients, :quantity, :integer
  end
end
