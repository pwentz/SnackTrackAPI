class RecipeFinder
  attr_reader :ingredients
  def initialize(ingredients)
    @ingredients = ingredients
  end

  def search_service
    @search_service ||= SpoonacularRecipeSearchService.new
  end

  def retrieval_service
    @retrieval_service ||= SpoonacularRecipeRetrievalService.new
  end

  def fetch_recipes
    cached_recipes = Recipe.find_by_ingredients(ingredients.values)
    # USE RECIPES ALREADY IN DB TO LIMIT API CALLS
    if cached_recipes.length == 5
      cached_recipes
    else
      simple_recipe_data = search_service.recipe_match_api(ingredients)
      recipe_ids = simple_recipe_data.map{ |recipe| recipe['id'] }
      aggregate_recipe_data = retrieval_service.detailed_recipe_data(recipe_ids)
      Recipe.create_recipes(aggregate_recipe_data)
    end
  end

  class << self
    def fetch_recipes(ingredients)
      new(ingredients).fetch_recipes
    end
  end
end
