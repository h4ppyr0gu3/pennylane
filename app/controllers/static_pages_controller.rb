# frozen_string_literal: true

class StaticPagesController < ApplicationController
  MAX_RECOMMENDATIONS = 15
  include Pagy::Backend

  def home
    return if current_user.blank?

    @should_sort = false
    @recipes = recommended_recipes(current_user)
  end

  private

  def recommended_recipes(user)
    Recipe.select('recipes.*, COUNT(ingredients.id) AS ingredient_match_count')
          .joins(:ingredients)
          .where(ingredients: { id: user.ingredient_ids })
          .group('recipes.id')
          .order('ingredient_match_count DESC, recipes.id')
          .limit(MAX_RECOMMENDATIONS)
  end
end
