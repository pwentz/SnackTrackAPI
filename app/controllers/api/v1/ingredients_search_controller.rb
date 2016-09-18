class Api::V1::IngredientsSearchController < ApplicationController
  respond_to :json

  def index
    respond_with IngredientFinder.fetch_ingredients(params[:search])
  end
end
