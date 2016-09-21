FactoryGirl.define do
  factory :ingredient do
    name 'apple'
    image 'apple.jpg'
  end

  factory :recipe do
    title 'Mac n Cheese'
    ready_time 45
    image 'macncheese.jpg'
  end
end
