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

  class << self
    def service
      SpoonacularAutoCompleteService.new
    end

    def find_by_name(search_terms)
      where("name LIKE ?", "%#{search_terms}%").limit(5)
    end

    def create_by_collection(raw_ingredients)
      raw_ingredients.map do |raw_ingredient|
        create(raw_ingredient)
      end
    end

    def find_or_create(raw_ingredient)
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

    def identify_potential_counterparts(new_ingredient)
      if new_ingredient.errors.full_messages.include?('Name cannot have singular counterparts')
        Ingredient.find_by(name: new_ingredient.name.singularize)
      elsif new_ingredient.errors.full_messages.include?('Name cannot have plural counterparts')
        Ingredient.find_by(name: new_ingredient.name.pluralize)
      else
        new_ingredient
      end
    end

    def where_name(search_terms)
      cached_results = find_by_name(search_terms)
      # USE INGREDIENTS ALREADY IN DB TO LIMIT API CALLS
      if cached_results.count == 5
        cached_results
      else
        raw_ingredients = service.fetch_external_ingredients(search_terms)
        create_by_collection(raw_ingredients)
        find_by_name(search_terms)
      end
    end
  end
end
