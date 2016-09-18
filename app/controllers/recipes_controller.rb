class RecipesController < ApplicationController
  def index
    yrc = YummlyRecipeApiService.new
    yrc.fetch_recipes(params['search'])
  end
end
