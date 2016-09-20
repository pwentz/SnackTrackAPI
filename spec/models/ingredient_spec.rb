require 'rails_helper'

describe Ingredient, type: :model do
  context 'associations' do
    it { should have_many(:pantry_ingredients) }
    it { should have_many(:users).through(:pantry_ingredients) }
  end
end
