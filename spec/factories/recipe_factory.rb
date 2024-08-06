# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    ratings { 4.5 }
    title { 'Recipe 1' }
    cuisine { 'Italian' }
    category { 'Dinner' }
    author { 'Author 1' }

    trait :with_ingredients do
      after(:create) do |recipe|
        ingredients = [
          create(:ingredient, name: 'flour', recipe: recipe),
          create(:ingredient, name: 'egg', recipe: recipe)
        ]
        recipe.recipe_ingredients << ingredients
      end
    end
  end
end
