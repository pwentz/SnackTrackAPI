class Api::V1::PantryIngredientsController < ApplicationController
  def create
    ingredient = Ingredient.find_by(id: params['ingredient_id'])
    if current_user.ingredients.exists?(ingredient.id)
      existing_pi = current_user.pantry_ingredients.find_by(ingredient: ingredient.id)
      existing_pi.update_attribute(:amount, existing_pi.amount + params['amount'])
    else
      current_user.pantry_ingredients.create(
        ingredient: ingredient,
        amount: params['amount']
      )
    end
    render json: current_user.pantry_ingredients, each_serializer: PantryIngredientSerializer
  end

  def destroy
    ingredient = Ingredient.find_by(id: params['ingredient_id'])
    current_user.pantry_ingredients.find_by(ingredient: ingredient).destroy
    render json: current_user.pantry_ingredients, each_serializer: PantryIngredientSerializer
  end
end
