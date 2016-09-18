class Api::V1::UserIngredientsController < ApplicationController
  def create
    user = User.find_by(google_id: params['googleId'])
    ingredient = Ingredient.find_by(id: params['ingredient_id'])
    if user.ingredients.exists?(ingredient.id)
      existing_ui = user.user_ingredients.find_by(ingredient: ingredient.id)
      existing_ui.update_attribute(:quantity, existing_ui.quantity + params['quantity'])
    else
      user.user_ingredients.create(
        ingredient: ingredient,
        quantity: params['quantity']
      )
    end
    render json: user.user_ingredients, each_serializer: UserIngredientSerializer
  end
end
