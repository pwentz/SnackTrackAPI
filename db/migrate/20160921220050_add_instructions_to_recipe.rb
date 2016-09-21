class AddInstructionsToRecipe < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :instructions, :text
  end
end
