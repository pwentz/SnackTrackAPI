class PantryIngredient < ApplicationRecord
  belongs_to :user
  belongs_to :ingredient

  class << self
    def update_pantry(raw_ingredient_data)
      raw_ingredient_data.each do |raw_ingredient|
        pantry_item = find_by_ingredient_name(raw_ingredient['name'])
        raw_amount = raw_ingredient['amount'].split(' ').first.to_i if raw_ingredient['amount']
        if !raw_amount || raw_amount <= 1
          pantry_item.destroy
        else
          pantry_item.update_attribute(:amount, pantry_item.amount - raw_amount)
        end
      end
    end

    def find_by_ingredient_name(ingredient_name)
      current_scope.
        select('pantry_ingredients.*').
        joins('INNER JOIN ingredients ON ingredients.id = ingredient_id').
        distinct.
        find_by('ingredients.name = ?', ingredient_name)
    end
  end
end
