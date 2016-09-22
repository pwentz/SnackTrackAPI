class Api::V1::PantryIngredientsController < ApplicationController
  def create
    current_user.add_to_pantry(params)
    render json: current_user.pantry_ingredients, each_serializer: PantryIngredientSerializer
  end

  def destroy
    ingredient = Ingredient.find_by(id: params['ingredient_id'])
    current_user.pantry_ingredients.find_by(ingredient: ingredient).destroy
    render json: current_user.pantry_ingredients, each_serializer: PantryIngredientSerializer
  end

  def update
    current_user.pantry_ingredients.remove_from_pantry(params['recipe_ingredients'])
    render json: current_user.pantry_ingredients, each_serializer: PantryIngredientSerializer
  end
end
