require 'rails_helper'

RSpec.describe 'get index of ingredients', type: :request do
  it 'returns new ingredients when passed name fragment' do
    VCR.use_cassette('ingredients_search_request#index') do
      search_params = { 'search' => 'a' }

      get '/api/v1/ingredients/search.json', params: search_params

      new_ingredients = JSON.parse(response.body)
      sample_ingredient = new_ingredients.first

      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(new_ingredients.length).to eq(5)
      expect(sample_ingredient['name']).to eq('ale')
      expect(sample_ingredient['image']).to eq('no.jpg')
    end
  end
end
