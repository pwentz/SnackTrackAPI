require 'rails_helper'

describe SpoonacularAutoCompleteService, type: :model do
  before(:each) do
    @service = SpoonacularAutoCompleteService.new
  end

  it 'returns individual ingredients when given a collection' do
    VCR.use_cassette('spoonacular_auto_complete_service#return_ap') do
    end
  end
end
