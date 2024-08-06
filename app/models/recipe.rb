# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients

  def self.ransackable_attributes(_auth_object = nil)
    %w[title category cuisine author ratings id cooking_time prep_time]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[ingredients recipe_ingredients]
  end
end
