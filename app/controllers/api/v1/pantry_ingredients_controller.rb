class Api::V1::PantryIngredientsController < ApplicationController
  def create
    user = User.find_by(google_id: params['googleId'])
    ingredient = Ingredient.find_by(id: params['ingredient_id'])
    if user.ingredients.exists?(ingredient.id)
      existing_pi = user.pantry_ingredients.find_by(ingredient: ingredient.id)
      existing_pi.update_attribute(:amount, existing_pi.amount + params['amount'])
    else
      user.pantry_ingredients.create(
        ingredient: ingredient,
        amount: params['amount']
      )
    end
    render json: user.pantry_ingredients, each_serializer: PantryIngredientSerializer
  end
end
