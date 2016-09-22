require 'rails_helper'

RSpec.describe 'request for user', type: :request do
  it "returns an existing user's pantry ingredients" do
    current_user = create(
      :user,
      first_name: 'Pat',
      google_id: '1234'
    )
    apple = create(
      :ingredient,
      name: 'apple',
      image: 'apple.jpg'
    )
    create(
      :pantry_ingredient,
      user: current_user,
      ingredient: apple,
      amount: 2,
      unit: 'T'
    )
    user_params = { 'userName' => current_user.first_name, 'googleId' => current_user.google_id}

    post '/api/v1/users', params:  user_params

    existing_user_ingredients = JSON.parse(response.body)
    sample_ingredient = existing_user_ingredients.first

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(sample_ingredient['name']).to eq('apple')
    expect(sample_ingredient['image']).to eq('apple.jpg')
    expect(sample_ingredient['amount']).to eq(2)
  end

  it "returns a new user's blank pantry" do
    user_params = { 'googleId' => '1234', 'userName' => 'Fred' }

    post '/api/v1/users', params:  user_params

    returned_user_ingredients = JSON.parse(response.body)

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect(returned_user_ingredients).to be_empty
    expect(User.count).to eq(1)
  end
end
