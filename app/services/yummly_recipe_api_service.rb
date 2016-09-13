class YummlyRecipeApiService
  def initialize
    @conn = Faraday.new('http://api.yummly.com/v1/api/recipes')
    @conn.params['_app_id'] = ENV['yummly_id']
    @conn.params['_app_key'] = ENV['yummly_key']
  end

  def fetch_recipes(recipe)
    @conn.params['q'] = recipe
    response = @conn.get
    response.body
  end
end
