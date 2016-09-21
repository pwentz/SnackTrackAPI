class Api::V1::RecipesController < ApplicationController
  def index
    recipes = Recipe.where_ingredients(params['ingredients'])
    render json: recipes, each_serializer: RecipeSerializer
  end
end
