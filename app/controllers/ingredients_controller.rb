# frozen_string_literal: true

class IngredientsController < ApplicationController
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if params[:name] != '' || !params[:name].nil?
      ingredients_to_add = Ingredient.where('name ILIKE ?', "%#{params[:name]}%")
      new_ingredients = ingredients_to_add.where.not(
        id: current_user.ingredients.pluck(:id)
      )

      current_user.ingredients << new_ingredients

      current_user.listed_ingredients << ingredient_params[:name]
      current_user.listed_ingredients = current_user.listed_ingredients.flatten.uniq

      current_user.save
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: new_ingredients }
    end
  end

  def destroy # rubocop:disable Metrics/AbcSize
    if params[:id].present?
      current_user.listed_ingredients.delete(params[:id])
      current_user.save

      ingredients = Ingredient.where('name ILIKE ?', "%#{params[:id]}%")
      UserIngredient.where(ingredient: ingredients, user: current_user).destroy_all
    end

    redirect_to root_path
  end

  private

  def ingredient_params
    params.permit(:name, :user_id)
  end
end
