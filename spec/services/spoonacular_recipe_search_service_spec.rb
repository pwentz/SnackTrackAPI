require 'rails_helper'

RSpec.describe SpoonacularRecipeSearchService, type: :service do
  before(:each) do
    @service = SpoonacularRecipeSearchService.new
  end

  it 'returns 5 recipes based on ingredient parameters' do
    VCR.use_cassette('spoonacular_recipe_search_service#find_by_apple') do
      raw_ingredient_data = { '0': { 'name': 'apple', 'image': 'apple.png' } }
      raw_recipe_data = @service.recipe_match_api(raw_ingredient_data)
      raw_recipe = raw_recipe_data.first

      expect(raw_recipe_data.count).to eq(5)
      expect(raw_recipe['title']).to include('Apple')
    end

  end
end
