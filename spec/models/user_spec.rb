require 'rails_helper'

describe User, type: :model do
  context 'associations' do
    it { should have_many(:pantry_ingredients) }
    it { should have_many(:ingredients).through(:pantry_ingredients) }
  end
end
