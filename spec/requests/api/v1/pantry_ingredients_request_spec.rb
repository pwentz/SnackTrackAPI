require 'rails_helper'

RSpec.describe 'Pantry Ingredients request', type: :request do
  it 'returns serialized user pantry items after calculations' do
    current_user = create(:user)
    existing_apple = create(:ingredient)
    user_id_params = { 'googleId' => current_user.google_id, 'amount' => '2' }

    post "/api/v1/pantry_ingredients/#{existing_apple.id}.json", params: user_id_params
    user_pantry_ingredients = JSON.parse(response.body)
    returned_user_ingredient = user_pantry_ingredients.first

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(user_pantry_ingredients.count).to eq(1)
    expect(returned_user_ingredient['id']).to eq(existing_apple.id)
    expect(returned_user_ingredient['name']).to eq(existing_apple.name)
    expect(returned_user_ingredient['image']).to eq(existing_apple.image)
    expect(returned_user_ingredient['amount']).to eq(2)
  end

  it 'returns serialized user pantry items after removing selected item' do
    current_user = create(:user)
    existing_apple = create(:ingredient)
    existing_apricot = create(:ingredient, name: 'apricot')
    current_user.ingredients << [existing_apple, existing_apricot]
    user_id_params = {'googleId' => current_user.google_id}

    delete "/api/v1/pantry_ingredients/#{existing_apple.id}", params: user_id_params
    user_ingredients = JSON.parse(response.body)
    sample_ingredient = user_ingredients.first

    expect{
      current_user.ingredients.reload
    }.to change{
      current_user.ingredients.length
    }.from(2).to(1)

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(user_ingredients.count).to eq(1)
    expect(sample_ingredient['id']).to eq(existing_apricot.id)
    expect(sample_ingredient['name']).to eq(existing_apricot.name)
    expect(sample_ingredient['image']).to eq(existing_apricot.image)
  end

  it 'returns serialized user pantry items after updating pantry' do
    current_user = create(:user)
    mac_n_cheese = create(:recipe)
    cheese = create(:ingredient, name: 'cheese')
    apple = create(:ingredient, name: 'apple')

    create(
      :pantry_ingredient,
      user: current_user,
      ingredient: cheese
    )
    create(
      :pantry_ingredient,
      user: current_user,
      ingredient: apple
    )
    create(
      :recipe_ingredient,
      recipe: mac_n_cheese,
      ingredient: cheese)

    recipe_params = [ { 'name' => cheese.name, 'amount' => "1 q" } ]
    update_params = { 'googleId' => current_user.google_id,
                      'recipe_ingredients' => recipe_params }

    patch "/api/v1/pantry_ingredients.json", params: update_params
    updated_pantry_ingredients = JSON.parse(response.body)
    sample_ingredient = updated_pantry_ingredients.first

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(sample_ingredient['name']).to eq(apple.name)
    expect(sample_ingredient['image']).to eq(apple.image)
  end
end
