class IngredientFinder
  attr_reader :search_terms
  def initialize(search_terms)
    @search_terms = search_terms
  end

  def auto_complete_service
    @auto_complete_service ||= SpoonacularAutoCompleteService.new
  end

  def fetch_ingredients
    cached_results = Ingredient.find_by_name(search_terms)
    if cached_results.count <= 5
      cached_results
    else
      auto_complete_api_call
    end
  end

  def auto_complete_api_call
    raw_ingredients = auto_complete_service.
                            autocomplete_call(search_terms)
    Ingredient.create_by_collection(raw_ingredients)
  end

  def self.fetch_ingredients(search_terms)
    new(search_terms).fetch_ingredients
  end
end
