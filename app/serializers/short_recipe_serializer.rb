class ShortRecipeSerializer < ActiveModel::Serializer
  attributes :title, :image
  attribute :spoon_id

  def spoon_id
    object.spoonacular_id
  end
end
