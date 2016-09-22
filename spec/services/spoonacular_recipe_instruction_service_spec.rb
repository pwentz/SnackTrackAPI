require 'rails_helper'

RSpec.describe SpoonacularRecipeInstructionService, type: :service do
  before(:each) do
    @service = SpoonacularRecipeInstructionService.new
  end

  it 'returns step by step instructional data when passed recipe id' do
    VCR.use_cassette('spoonacular_instruction_service#get_324694') do
      raw_recipe_data = @service.get_instructions(324694)
      sample_recipe = raw_recipe_data.first
      sample_recipe_step = sample_recipe['steps'].first['step']

      expect(sample_recipe['steps'].length).to eq(10)
      expect(sample_recipe_step).to eq('Preheat the oven to 200 degrees F.')
    end
  end
end
