class RecipeIngredientSerializer < ActiveModel::Serializer
  attributes :id
  attribute :formatted_amount, key: :amount
  attribute :ingredient_name, key: :name


  def formatted_amount
    "#{object.amount} #{object.unit}"
  end

  def ingredient_name
    object.ingredient.name
  end
end
