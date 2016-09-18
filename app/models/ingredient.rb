class Ingredient < ApplicationRecord
  has_many :user_ingredients
  has_many :users, through: :user_ingredients
  validates :name, uniqueness: true
  validate :name_cannot_have_plural_counterparts
  validate :name_cannot_have_singular_counterparts
  validates :image, uniqueness: true

  def name_cannot_have_plural_counterparts
    counterpart = Ingredient.find_by(name: name.pluralize)
    if counterpart && counterpart.id != id
      errors.add(:name, 'cannot have plural counterparts')
    end
  end

  def name_cannot_have_singular_counterparts
    counterpart = Ingredient.find_by(name: name.singularize)
    if counterpart && counterpart.id != id
      errors.add(:name, 'cannot have singular counterparts')
    end
  end

  def self.find_by_name(search_terms)
    where("name LIKE ?", "%#{search_terms}%").first(5)
  end

  def self.create_by_collection(raw_ingredients)
    raw_ingredients.map do |raw_ingredient|
      create(raw_ingredient)
    end
  end
end
