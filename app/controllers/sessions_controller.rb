class SessionsController < ApplicationController
  def create
    user = User.find_or_create(user_params)
  end

  private

  def user_params
    params.require('session').permit(:googleId, :userName)
  end
end
