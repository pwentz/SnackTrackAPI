require 'rails_helper'

RSpec.describe 'Recipes request', type: :request do
  it 'returns matching recipes when passed ingredients' do
    VCR.use_cassette('recipe_request#index') do
      ingredient_params = { "0"=>{"amount"=>"1", "name"=>"pasta dough", "id"=>"352"},
                            "1"=>{"amount"=>"1", "name"=>"tomato sauce", "id"=>"393"},
                            "2"=>{"amount"=>"1", "name"=>"shredded cheese", "id"=>"508"} }

      get '/api/v1/recipes.json', params: { 'ingredients' => ingredient_params }

      recipes = JSON.parse(response.body)
      calzone = recipes.first

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(calzone['title']).to eq('Sausage Calzone')
      expect(calzone['image']).to include('Sausage-Calzone')
    end
  end

  it 'returns recipe with updated instructions when passed id' do
    VCR.use_cassette('recipe_request_spec#update_16962') do
      cheese = create(:ingredient, name: 'cheese')
      recipe = create(
        :recipe,
        title: 'Mac n Cheese',
        image: 'macncheese.jpg',
        spoonacular_id: 16962,
        instructions: ''
      )

      recipe.ingredients << cheese

      get "/api/v1/recipes/#{recipe.spoonacular_id}.json"

      long_format_recipe = JSON.parse(response.body)
      long_format_ingredients = long_format_recipe['recipe_ingredients']

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(long_format_recipe['title']).to eq('Mac n Cheese')
      expect(long_format_recipe['image']).to eq('macncheese.jpg')
      expect(long_format_recipe['instructions']).to include('Cook macaroni until very firm.')
      expect(long_format_ingredients.first['name']).to eq('cheese')
    end
  end
end
