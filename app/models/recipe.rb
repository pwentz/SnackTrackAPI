class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true, uniqueness: true

  def self.create_recipes(aggregate_recipe_data)
    aggregate_recipe_data.map do |recipe_data|
      recipe = create(
        title: recipe_data['title'],
        ready_time: recipe_data['readyInMinutes'],
        image: recipe_data['image']
      )
      recipe.recipe_ingredients.create_by_collection(recipe_data['extendedIngredients'])
      recipe
    end
  end

  def self.find_by_ingredients(raw_ingredients)
    select('recipes.*').
      joins(:ingredients).
      where('ingredients.name IN (?)',
            raw_ingredients.pluck(:name)).
      distinct.
      limit(5)
  end
end
