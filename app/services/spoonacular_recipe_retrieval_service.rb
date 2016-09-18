class SpoonacularRecipeRetrievalService
  def initialize
    @conn = Faraday.new('https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/')
    @conn.headers['Accept'] = 'application/json'
    @conn.headers['X-Mashape-Key'] = ENV['spoonacular_key']
    @conn.params['includeNutrition'] = false
  end

  def detailed_recipe_data(recipe_ids)
    recipe_ids.map do |id|
      response = @conn.get("#{id}/information")
      JSON.parse(response.body)
    end
  end
end
