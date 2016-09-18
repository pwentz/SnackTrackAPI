class Api::V1::UsersController < ApplicationController
  def create
    user = User.find_or_create(params)
    if user.save
      render json: user.user_ingredients, each_serializer: UserIngredientSerializer
    end
  end
end
