require 'rails_helper'

RSpec.describe PantryIngredient, type: :model do
  it 'can remove pantry ingredients when matching amount is < 1' do
    current_user = create(:user)
    cheese = create(:ingredient, name: 'cheese')
    apple = create(:ingredient, name: 'apple')

    create(
      :pantry_ingredient,
      ingredient: cheese,
      user: current_user,
      amount: 1
    )

    create(
      :pantry_ingredient,
      ingredient: apple,
      user: current_user,
      amount: 1
    )

    recipe_params = [ { 'name' => cheese.name, 'amount' => "1 q" } ]


    expect{
      current_user.pantry_ingredients.update_pantry(recipe_params)
    }.to change{
      current_user.pantry_ingredients.count
    }.from(2).to(1)
  end

  it 'can update pantry ingredient quantity when matching amount > 1' do
    current_user = create(:user)
    cheese = create(:ingredient, name: 'cheese')
    apple = create(:ingredient, name: 'apple')

    create(
      :pantry_ingredient,
      ingredient: cheese,
      user: current_user,
      amount: 2
    )

    create(
      :pantry_ingredient,
      ingredient: apple,
      user: current_user,
      amount: 1
    )

    recipe_params = [ { 'name' => cheese.name, 'amount' => "1 q" } ]
    cheese_pantry_ingredient = cheese.pantry_ingredients.first
    current_user.pantry_ingredients.update_pantry(recipe_params)

    expect{
      cheese_pantry_ingredient.reload
    }.to change{
      cheese_pantry_ingredient.amount
    }.from(2).to(1)
  end

  it 'can return a pantry ingredient when passed ingredient name' do
    current_user = create(:user)
    apple = create(:ingredient, name: 'apple')
    pantry_apple = create(
      :pantry_ingredient,
      ingredient: apple,
      user: current_user
    )

    expect(
      current_user.pantry_ingredients.find_by_ingredient_name('apple')
    ).to eq(pantry_apple)
  end
end
