class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :recipe_id, presence: true
  validates :ingredient_id, presence: true
end
