class UserIngredientSerializer < ActiveModel::Serializer
  attributes :quantity
  attribute :ingredient_name, key: :name
  attribute :ingredient_image, key: :image


  def ingredient_name
    object.ingredient.name
  end

  def ingredient_image
    object.ingredient.image
  end
end
