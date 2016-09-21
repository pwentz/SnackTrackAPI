class LongRecipeSerializer < ActiveModel::Serializer
  attributes :title, :image, :instructions
  has_many :recipe_ingredients, serializer: RecipeIngredientSerializer
end
