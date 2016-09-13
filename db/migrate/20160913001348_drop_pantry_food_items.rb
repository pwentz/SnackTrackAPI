class DropPantryFoodItems < ActiveRecord::Migration[5.0]
  def change
    drop_table :pantry_food_items
  end
end
