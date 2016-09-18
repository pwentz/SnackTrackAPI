class Api::V1::RecipesController < ApplicationController
  def index
    recipes = RecipeFinder.fetch_recipes(params['ingredients'])
    render json: recipes, each_serializer: RecipeSerializer
  end
end
