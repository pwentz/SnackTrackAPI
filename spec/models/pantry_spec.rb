require 'rails_helper'

describe Pantry, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:pantry_ingredients) }
    it { should have_many(:ingredients).through(:pantry_ingredients) }
  end
end
