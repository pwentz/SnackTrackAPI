class ChangeFoodItemName < ActiveRecord::Migration[5.0]
  def change
    rename_table :food_items, :ingredients
  end
end
