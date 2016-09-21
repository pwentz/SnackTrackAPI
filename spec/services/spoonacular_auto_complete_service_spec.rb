require 'rails_helper'

describe SpoonacularAutoCompleteService, type: :service do
  before(:each) do
    @service = SpoonacularAutoCompleteService.new
  end

  it 'returns individual ingredients when given a collection' do
    VCR.use_cassette('spoonacular_auto_complete_service#return_ap') do
      raw_ingredients = @service.fetch_external_ingredients('ap')

      expect(raw_ingredients.count).to eq(5)
      expect('apple').to be_in(raw_ingredients.pluck('name'))
      expect('apple.jpg').to be_in(raw_ingredients.pluck('image'))
      expect('apricot').to be_in(raw_ingredients.pluck('name'))
      expect('apricot.jpg').to be_in(raw_ingredients.pluck('image'))
    end
  end
end
