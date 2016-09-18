class Ingredient < ApplicationRecord
  has_many :pantry_ingredients
  has_many :users, through: :pantry_ingredients
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  validates :name, uniqueness: true
  validate :name_cannot_have_plural_counterparts
  validate :name_cannot_have_singular_counterparts
  validates :image, presence: true

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

  def self.find_or_create(raw_ingredient)
    ingredient = find_by(name: raw_ingredient['name'])
    if ingredient
      ingredient
    else
      new_ingredient = create(
        name: raw_ingredient['name'],
        image: raw_ingredient['image']
      )
      identify_potential_counterparts(new_ingredient)
    end
  end

  def self.identify_potential_counterparts(new_ingredient)
    if new_ingredient.errors.full_messages.include?('Name cannot have singular counterparts')
      Ingredient.find_by(name: new_ingredient['name'].singularize)
    elsif new_ingredient.errors.full_messages.include?('Name cannot have plural counterparts')
      Ingredient.find_by(name: new_ingredient['name'].pluralize)
    else
      new_ingredient
    end
  end
end
