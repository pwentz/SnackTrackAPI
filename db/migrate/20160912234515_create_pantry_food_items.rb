class CreatePantryFoodItems < ActiveRecord::Migration[5.0]
  def change
    create_table :pantry_food_items do |t|
      t.references :food_item, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
