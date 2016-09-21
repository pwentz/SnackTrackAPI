class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true, uniqueness: true

  class << self
    def search_service
      SpoonacularRecipeSearchService.new
    end

    def retrieval_service
      SpoonacularRecipeRetrievalService.new
    end

    def where_ingredients(ingredients)
      cached_recipes = find_by_ingredients(ingredients.values)
      # USE RECIPES ALREADY IN DB TO LIMIT API CALLS
      if cached_recipes.length == 5
        cached_recipes
      else
        simple_recipe_data = search_service.recipe_match_api(ingredients)
        recipe_ids = simple_recipe_data.pluck('id')
        aggregate_recipe_data = retrieval_service.detailed_recipe_data(recipe_ids)
        create_recipes(aggregate_recipe_data)
      end
    end

    def create_recipes(aggregate_recipe_data)
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

    def find_by_ingredients(raw_ingredients)
      select('recipes.*').
        joins(:ingredients).
        where('ingredients.name IN (?)',
              raw_ingredients.pluck('name')).
        distinct.
        limit(5)
    end
  end
end
