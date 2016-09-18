class User < ApplicationRecord
  has_many :pantry_ingredients
  has_many :ingredients, through: :pantry_ingredients
  validates :google_id, presence: true, uniqueness: true

  def self.find_or_create(user_params)
    user = User.find_by(first_name: user_params['userName'],
                        google_id: user_params['googleId'])
    if user.valid?
      user
    else
      User.new(first_name: user_params['userName'],
               google_id: user_params['googleId'])
    end
  end
end
