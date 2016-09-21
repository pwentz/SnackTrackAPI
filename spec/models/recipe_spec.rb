require 'rails_helper'

RSpec.describe Recipe, type: :model do
  context 'queries' do
    it 'can retrieve recipes when passed ingredients' do
      VCR.use_cassette('recipe_model#ingredient_search') do
        ingredient_params = { "0"=>{"amount"=>"1", "name"=>"pasta dough", "id"=>"352"},
                              "1"=>{"amount"=>"1", "name"=>"tomato sauce", "id"=>"393"},
                              "2"=>{"amount"=>"1", "name"=>"shredded cheese", "id"=>"508"} }

        matching_recipes = Recipe.where_ingredients(ingredient_params)
        sample_recipe = matching_recipes.first['title']

        expect(matching_recipes.count).to eq(5)
        expect(sample_recipe).to eq('Sausage Calzone')
      end
    end

    it 'finds recipes by ingredients without external service' do
      mac_n_cheese = create(:recipe)
      garlic_bread = create(:recipe, title: 'garlic bread')
      pork_chops = create(:recipe, title: 'pork chops')
      cheese = create(:ingredient, name: 'cheese')
      garlic = create(:ingredient, name: 'garlic')
      cheese.recipes << [mac_n_cheese, garlic_bread]
      garlic.recipes << garlic_bread

      cheese_params = [{"amount"=>"1", "name"=>"cheese", "id"=>"352"}]
      garlic_params = [{"amount"=>"1", "name"=>"garlic", "id"=>"355"}]

      cheese_recipes = Recipe.find_by_ingredients(cheese_params)
      garlic_recipes = Recipe.find_by_ingredients(garlic_params)

      expect(cheese_recipes.length).to eq(2)
      expect(garlic_recipes.length).to eq(1)

      expect(mac_n_cheese).to be_in(cheese_recipes)
      expect(garlic_bread).to be_in(cheese_recipes)

      expect(garlic_bread).to be_in(garlic_recipes)
      expect(mac_n_cheese).not_to be_in(garlic_recipes)

      expect(pork_chops).not_to be_in(cheese_recipes)
      expect(pork_chops).not_to be_in(garlic_recipes)
    end

    it 'creates recipes and related ingredients when given raw data' do
      raw_recipe_data = [ { 'title'=>'mac n cheese',
                          'readyInMinutes'=>45,
                          'image'=>'mac.jpg',
                          'extendedIngredients'=>
                            [ {'name'=>'pasta', 'image'=>'pasta.jpg'},
                             {'name'=>'cheese', 'image'=>'cheese.jpg'} ] } ]
      result = Recipe.create_recipes(raw_recipe_data)
      recipe = result.first
      recipe_ingredients = recipe.ingredients.pluck(:name)

      expect(result.count).to eq(1)
      expect(recipe.title).to eq('mac n cheese')
      expect(recipe_ingredients.count).to eq(2)
      expect('pasta').to be_in(recipe_ingredients)
      expect('cheese').to be_in(recipe_ingredients)
    end
  end
end