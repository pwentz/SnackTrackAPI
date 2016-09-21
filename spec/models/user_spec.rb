require 'rails_helper'

describe User, type: :model do
  context 'associations' do
    it { should have_many(:pantry_ingredients) }
    it { should have_many(:ingredients).through(:pantry_ingredients) }
  end

  it 'can update pantry when given an ingredient new to pantry' do
    current_user = create(:user)
    existing_apple = create(:ingredient)
    user_id_params = { 'googleId' => current_user.google_id,
                       'amount' => '1',
                       'ingredient_id' => existing_apple.id }
    expect{
      current_user.update_pantry(user_id_params)
    }.to change{
      current_user.ingredients.count
    }.from(0).to(1)

    expect(
      current_user.ingredients.first
    ).to eq(existing_apple)
  end

  it 'can increate pantry items when ingredients already present' do
    current_user = create(:user)
    pantry_apple_instance = create(:pantry_ingredient, user: current_user)
    apple = current_user.ingredients.first
    user_id_params = { 'googleId' => current_user.google_id,
                       'amount' => '2',
                       'ingredient_id' => apple.id }

    current_user.update_pantry(user_id_params)

    expect{
      pantry_apple_instance.reload
    }.to change{
      pantry_apple_instance.amount
    }.from(1).to(3)
  end
end
