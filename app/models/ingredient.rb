# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  has_many :user_ingredients, dependent: :destroy
  has_many :users, through: :user_ingredients

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at]
  end
end
