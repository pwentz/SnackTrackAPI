class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  validates :title, presence: true, uniqueness: true

  class << self
    def search_service
      SpoonacularRecipeSearchService.new
    end

    def where_ingredients(ingredients)
      cached_recipes = find_by_ingredients(ingredients.values)
      # USE RECIPES ALREADY IN DB TO LIMIT API CALLS
      if cached_recipes.length == 5
        cached_recipes
      else
        aggregate_recipe_data = search_service.recipe_match_api(ingredients)
        create_recipes(aggregate_recipe_data)
      end
    end

    def create_recipes(aggregate_recipe_data)
      aggregate_recipe_data.map do |recipe_data|
        recipe = Recipe.create(
          title: recipe_data['title'],
          image: recipe_data['image'],
          spoonacular_id: recipe_data['id']
        )
        recipe.find_and_create_ingredients(recipe_data['missedIngredients']) if recipe_data['missedIngredients']
        recipe.find_and_create_ingredients(recipe_data['usedIngredients']) if recipe_data['usedIngredients']
        recipe
      end
    end

    def find_by_ingredients(raw_ingredients)
      select('recipes.*').
        joins(:ingredients).
        where('ingredients.name IN (?)',
              raw_ingredients.pluck('name')).
        distinct.
        limit(5)
    end
  end

  def instruction_service
    @instruction_service ||= SpoonacularRecipeInstructionService.new
  end

  def find_and_create_ingredients(raw_ingredient_data)
    raw_ingredient_data.each do |raw_ingredient|
      ingredient = Ingredient.find_or_create(raw_ingredient)
      recipe_ingredients.create(
        ingredient: ingredient,
        unit: raw_ingredient['unit'],
        amount: raw_ingredient['amount']
      )
    end
  end

  def update_instructions
    if instructions.nil? || instructions.empty?
      raw_steps = instruction_service.get_instructions(spoonacular_id)
      require 'pry'; binding.pry
      update_attribute(:instructions, format_instructions(raw_steps))
    end
  end

  def format_instructions(raw_steps)
    raw_steps.first['steps'].reduce('') do |result, instruction|
      result += "#{instruction['step']} "
    end.strip
  end
end
