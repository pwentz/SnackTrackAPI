class User < ActiveRecord::Base
  has_one :pantry
  has_many :pantry_ingredients, through: :pantry
  has_many :ingredients, through: :pantry_ingredients
end
