require 'rails_helper'

describe PantryIngredient, type: :model do
  context 'associations' do
    it { should belong_to(:pantry) }
    it { should belong_to(:ingredient) }
  end
end
