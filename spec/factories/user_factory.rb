# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'sQqQp@example.com' }
    password { 'password' }

    trait :with_ingredients do
      after(:create) do |user|
        ingredients = [
          create(:ingredient, name: 'tomato', user: user),
          create(:ingredient, name: 'onion', user: user)
        ]
        user.user_ingredients << ingredients
      end
    end
  end
end
