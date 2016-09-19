class User < ApplicationRecord
  has_many :pantry_ingredients
  has_many :ingredients, through: :pantry_ingredients
  validates :google_id, presence: true, uniqueness: true

  def self.find_or_create(user_params)
    user = User.find_by(google_id: user_params['googleId'])
    if user
      user
    else
      User.new(google_id: user_params['googleId'],
               first_name: user_params['userName'])
    end
  end
end
