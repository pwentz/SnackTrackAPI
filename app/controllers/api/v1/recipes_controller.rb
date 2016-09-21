class Api::V1::RecipesController < ApplicationController
  def index
    recipes = Recipe.where_ingredients(params['ingredients'])
    render json: recipes, each_serializer: ShortRecipeSerializer
  end

  def show
    recipe = Recipe.find_by(spoonacular_id: params['recipe_id'])
    if recipe
      recipe.update_instructions
      render json: recipe, serializer: LongRecipeSerializer
    end
  end
end
