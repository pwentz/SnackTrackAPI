class SpoonacularRecipeSearchService
  def initialize
    @conn = Faraday.new('https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients')
    @conn.headers['X-MASHAPE-KEY'] = ENV['spoonacular_key']
    @conn.params['number'] = 6
    @conn.params['fillIngredients'] = true
  end

  def recipe_match_api(raw_ingredients_data)
    ingredient_names = raw_ingredients_data.values.pluck('name')
    ingredient_params = ingredient_names.reduce('') do |res, ing|
      res += "#{ing},"
    end
    @conn.params['ingredients'] = ingredient_params
    response = @conn.get
    parse(response.body)
  end

  private

  def parse(response_body)
    JSON.parse(response_body)
  end

end
