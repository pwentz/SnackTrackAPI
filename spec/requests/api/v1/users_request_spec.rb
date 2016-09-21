require 'rails_helper'

RSpec.describe 'request for user', type: :request do
  it "returns an existing user's pantry ingredients" do
    user = create(:user, first_name: 'Pat', google_id: '1234')
    included_apple = create(:ingredient, name: 'apple')
    included_apricot = create(:ingredient, name: 'apricot')
    excluded_beef = create(:ingredient, name: 'beef')
    user.ingredients << [included_apple, included_apricot]
    user_params = { 'userName' => user.first_name, 'googleId' => user.google_id}

    post '/api/v1/users/sign_in', params:  user_params

    existing_user_ingredients = JSON.parse(response.body).pluck('name')

    expect(response).to have_http_status(200)
    expect(response.content_type).to eq('application/json')
    expect('apple').to be_in(existing_user_ingredients)
    expect('apricot').to be_in(existing_user_ingredients)
    expect('beef').not_to be_in(existing_user_ingredients)
  end
end
