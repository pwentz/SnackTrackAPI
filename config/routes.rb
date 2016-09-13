Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/recipes', to: 'recipes#index'

  get '/ingredients/search', to: 'api/v1/ingredients_search#index'

  get '/ingredients/find/:ingredient_id', to: 'api/v1/ingredients_search#show'

  post '/api/v1/users/sign_in', to: 'api/v1/users#create', as: 'users'

  post '/api/v1/user_ingredients/:ingredient_id/add_to_pantry', to: 'api/v1/user_ingredients#create', as: 'user_ingredients'
end
