class CreateUserIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :user_ingredients do |t|
      t.references :user, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.integer :quantity
    end
  end
end
