require 'rails_helper'

describe Ingredient, type: :model do
  context 'associations' do
    it { should have_many(:pantry_ingredients) }
    it { should have_many(:users).through(:pantry_ingredients) }
  end

  context 'queries' do
    it 'can find and save new ingredients when passed name fragment' do
      VCR.use_cassette('ingredient_model_autocomplete#a') do
        search_query = 'a'
        ingredients = Ingredient.where_name(search_query)

        expect(ingredients.count).to eq(5)
        expect(
          ingredients.all?{ |ingredient| ingredient.name[0] == 'a' }
        ).to be_truthy
        expect(Ingredient.count).to eq(5)
      end
    end

    it 'can return matching ingredients in database when passed params' do
      search_query = 'a'
      existing_a_ingredients = create_list(:ingredient, 5)
      ingredients = Ingredient.where_name(search_query)

      expect(
        ingredients.all?{ |ingredient| ingredient.name[0] == 'a' }
      ).to be_truthy
      expect(ingredients).to eq(existing_a_ingredients)
    end

    it 'can auto-complete search without enlisting service' do
      included_apple = create(:ingredient, name: 'apple', image: 'apple.jpg')
      included_apricot = create(:ingredient, name: 'apricot', image: 'apricot.jpg')
      excluded_beef = create(:ingredient, name: 'ground beef', image: 'ground_beef.jpg')

      queried_ingredients = Ingredient.find_by_name('ap')

      expect(queried_ingredients.length).to eq(2)
      expect(included_apple).to be_in(queried_ingredients)
      expect(included_apricot).to be_in(queried_ingredients)
      expect(excluded_beef).not_to be_in(queried_ingredients)
    end

    it 'can find existing ingredient or create new one given a name' do
      existing_ingredient = create(:ingredient, name: 'apple')
      familiar_ingredient_params = { 'name' => 'apple', 'image' => 'apple.jpg' }
      unfamiliar_params = { 'name' => 'beef', 'image' => 'beef.jpg' }

      expect(
        Ingredient.find_or_create(familiar_ingredient_params)
      ).to eq(existing_ingredient)

      expect{
        Ingredient.find_or_create(unfamiliar_params)
      }.to change{Ingredient.count}.from(1).to(2)
    end

    it 'can identify existing ingredient when passed plural counterpart' do
      existing_ingredient = create(:ingredient, name: 'apple')
      invalid_plural_counterpart = build(:ingredient, name: 'apples')
      invalid_plural_counterpart.save

      expect(
        Ingredient.identify_potential_counterparts(invalid_plural_counterpart)
      ).to eq(existing_ingredient)

      expect{
        invalid_plural_counterpart.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'can identify existing ingredient when passed singular counterpart' do
      existing_ingredient = create(:ingredient, name: 'apples')
      invalid_singular_counterpart = build(:ingredient, name: 'apple')
      invalid_singular_counterpart.save

      expect(
        Ingredient.identify_potential_counterparts(invalid_singular_counterpart)
      ).to eq(existing_ingredient)

      expect(
        invalid_singular_counterpart.errors.full_messages.first
      ).to eq('Name cannot have plural counterparts')
    end
  end
end
