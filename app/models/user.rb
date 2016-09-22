class User < ApplicationRecord
  has_many :pantry_ingredients
  has_many :ingredients, through: :pantry_ingredients
  validates :google_id, presence: true, uniqueness: true

  def add_to_pantry(params)
    ingredient = Ingredient.find_by(id: params['ingredient_id'])
    if ingredients.exists?(ingredient.id)
      existing_pi = pantry_ingredients.find_by(ingredient: ingredient.id)
      existing_pi.update_attribute(:amount, existing_pi.amount + params['amount'].to_i)
    else
      pantry_ingredients.create(
        ingredient: ingredient,
        amount: params['amount']
      )
    end
  end

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
