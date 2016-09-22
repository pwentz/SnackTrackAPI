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

        expect(matching_recipes.count).to eq(6)
        expect(Recipe.count).to eq(6)
        expect(matching_recipes.sort).to eq(Recipe.all)
        expect(sample_recipe).to eq('Sausage Calzone')
      end
    end

    it 'can look for existing recipes before enlisting service' do
      cheese = create(:ingredient, name: 'cheese')
      recipes = create_list(:recipe, 6)
      6.times do |i|
        create(
          :recipe_ingredient,
          ingredient: cheese,
          recipe: recipes[i]
        )
      end
      ingredient_params = { "0"=>{"amount"=>"1", "name"=>"cheese", "id"=>"#{cheese.id}"} }

      matching_recipes = Recipe.where_ingredients(ingredient_params)

      expect(recipes.sort).to eq(matching_recipes.sort)
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
  end

  it 'creates recipes and related ingredients when given raw data' do
    raw_recipe_data = [ { 'title'=>'mac n cheese',
                        'image'=>'mac.jpg',
                        'usedIngredients'=>
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

  it 'can update instructions using a service' do
    VCR.use_cassette('recipe_model_spec#instruction_service') do
      recipe = create(:recipe,
                      spoonacular_id: 16962,
                      instructions: '')

      expect{
        recipe.update_instructions
      }.to change{recipe.instructions.length}.from(0).to(931)
      expect(recipe.instructions).to include('Cook macaroni until very firm.')
    end
  end
end
