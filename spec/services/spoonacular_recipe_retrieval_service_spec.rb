require 'rails_helper'

RSpec.describe SpoonacularRecipeRetrievalService, type: :service do
  before(:each) do
    @service = SpoonacularRecipeRetrievalService.new
  end

  it 'should return detailed recipe information given an id' do
    VCR.use_cassette('spoonacular_recipe_retrieval_service#search_by_633547') do
      cinnamon_apples_recipe = @service.detailed_recipe_data([633547])
      recipe_ingredients = cinnamon_apples_recipe.first['extendedIngredients']

      expect(cinnamon_apples_recipe.count).to eq(1)
      expect(cinnamon_apples_recipe.first['title']).to eq('Baked Cinnamon Apple Slices')
      expect('apples').to be_in(recipe_ingredients.pluck('name'))
    end
  end
end
