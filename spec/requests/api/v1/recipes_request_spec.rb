require 'rails_helper'

RSpec.describe 'Recipes request', type: :request do
  it 'returns matching recipes when passed ingredients' do
    VCR.use_cassette('recipe_request#index') do
      ingredient_params = { "0"=>{"amount"=>"1", "name"=>"pasta dough", "id"=>"352"},
                            "1"=>{"amount"=>"1", "name"=>"tomato sauce", "id"=>"393"},
                            "2"=>{"amount"=>"1", "name"=>"shredded cheese", "id"=>"508"} }

      get '/api/v1/recipes/search.json', params: { 'ingredients' => ingredient_params }

      recipes = JSON.parse(response.body)
      calzone = recipes.first
      sample_ingredient = calzone['recipe_ingredients'].first

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(calzone['title']).to eq('Sausage Calzone')
      expect(calzone['ready_time']).to eq(45)
      expect(calzone['image']).to include('Sausage-Calzone')
      expect(sample_ingredient['amount']).to eq('1 T')
      expect(sample_ingredient['name']).to eq('basil')
    end
  end
end
