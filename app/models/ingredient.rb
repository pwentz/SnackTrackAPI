class Ingredient < ApplicationRecord
  has_many :pantry_ingredients
  has_many :pantries, through: :pantry_ingredients
end
