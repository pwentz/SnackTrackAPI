class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :google_id
  has_many :ingredients, serializer: UserIngredientSerializer
end
