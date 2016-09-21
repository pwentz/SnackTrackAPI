class AddSpoonacularIdToRecipe < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :spoonacular_id, :integer
  end
end
