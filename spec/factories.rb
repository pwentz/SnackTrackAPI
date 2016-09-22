FactoryGirl.define do
  factory :ingredient do
    name
    image 'apple.jpg'
  end

  sequence :name do |i|
    "apple#{i}"
  end

  factory :pantry_ingredient do
    user
    ingredient
    amount 1
    unit 'q'
  end

  factory :recipe do
    title
    ready_time 45
    image 'macncheese.jpg'
    spoonacular_id
    instructions 'Preheat the oven'
  end

  sequence :spoonacular_id do |i|
    "1696#{i}"
  end

  sequence :title do |i|
    "Mac n Cheese ##{i}"
  end

  factory :user do
    first_name 'Pat'
    google_id
  end

  sequence :google_id do |i|
    "123#{i}"
  end

  factory :recipe_ingredient do
    recipe
    ingredient
    unit 'q'
    amount 1
  end
end
