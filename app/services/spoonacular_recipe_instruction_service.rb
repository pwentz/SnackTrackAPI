class SpoonacularRecipeInstructionService
  def initialize
    @conn = Faraday.new('https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/')
    @conn.headers['X-MASHAPE-KEY'] = ENV['spoonacular_key']
  end

  def get_instructions(spoon_id)
    response = @conn.get("#{spoon_id}/analyzedInstructions")
    JSON.parse(response.body)
  end
end
