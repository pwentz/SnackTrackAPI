class Api::V1::IngredientsSearchController < ApplicationController
  respond_to :json

  def index
    respond_with Ingredient.where_name(params[:search])
  end
end
