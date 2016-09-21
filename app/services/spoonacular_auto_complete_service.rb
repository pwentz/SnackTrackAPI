class SpoonacularAutoCompleteService
  def initialize
    @connection = Faraday.new('https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete')
    @connection.headers['X-Mashape-Key'] = ENV['spoonacular_key']
    @connection.params['number'] = 5
  end

  def fetch_external_ingredients(search_terms)
    response = @connection.get do |req|
      req.params['query'] = search_terms
    end
    parse(response.body)
  end

  private

  def parse(response_body)
    JSON.parse(response_body)
  end
end
