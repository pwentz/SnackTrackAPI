class PantryIngredientSerializer < ActiveModel::Serializer
  attributes :amount
  attribute :ingredient_name, key: :name
  attribute :ingredient_image, key: :image
  attribute :ingredient_id, key: :id

  def ingredient_id
    object.ingredient.id
  end

  def ingredient_name
    object.ingredient.name
  end

  def ingredient_image
    object.ingredient.image
  end
end
