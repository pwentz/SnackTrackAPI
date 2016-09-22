Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/api/v1/recipes', to: 'api/v1/recipes#index'
  get '/api/v1/recipes/:recipe_id', to: 'api/v1/recipes#show'

  get '/api/v1/ingredients/search', to: 'api/v1/ingredients_search#index'

  get '/ingredients/find/:ingredient_id', to: 'api/v1/ingredients_search#show'

  post '/api/v1/users', to: 'api/v1/users#create', as: 'users'

  post '/api/v1/pantry_ingredients/:ingredient_id', to: 'api/v1/pantry_ingredients#create', as: 'pantry_ingredients'
  delete '/api/v1/pantry_ingredients/:ingredient_id', to: 'api/v1/pantry_ingredients#destroy', as: 'pantry_ingredient'
  patch '/api/v1/pantry_ingredients', to: 'api/v1/pantry_ingredients#update'
end
