class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  def self.create_by_collection(aggregate_ingredient_data)
    aggregate_ingredient_data.map do |raw_ingredient|
      ingredient = Ingredient.find_or_create(raw_ingredient)
      recipe_ingredient = unscoped.find_by(ingredient: ingredient)
      if recipe_ingredient
        recipe_ingredient
      else
        create(
          ingredient: ingredient,
          amount: raw_ingredient['amount'],
          unit: raw_ingredient['unitShort']
        )
      end
    end
  end
end
