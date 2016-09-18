class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :ready_time, :image
  has_many :recipe_ingredients, serializer: RecipeIngredientSerializer
end
