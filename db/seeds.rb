# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class Seeder
  class << self
    def seed
      seed_users
      seed_pantries
      seed_pantry_ingredients
    end

    def seed_users
      15.times do |i|
        user = User.create!(
          first_name: Faker::Name.first_name
        )
        puts "Created #{user.first_name}"
      end
    end

    def seed_pantries
      15.times do |i|
        pantry = Pantry.create!(
          user: User.all[i - 1]
        )
        puts "Created pantry for #{pantry.user.first_name}"
      end
    end

    def seed_pantry_ingredients
      count = 0
      100.times do |i|
        PantryIngredient.create!(
          ingredient_id: create_ingredient.id,
          pantry_id: count += 1
        )
        count = 0 if count > 14
      end
    end

    def create_ingredient
      Ingredient.create!(name: Faker::Food.ingredient)
    end
  end
end
Seeder.seed
