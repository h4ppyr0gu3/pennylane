# frozen_string_literal: true

class RecipesController < ApplicationController
  include Pagy::Backend
  before_action :set_recipe, only: %i[show]
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def index
    @should_sort = false
    @q = Recipe.ransack(params[:q])
    @pagy, @recipes = pagy(@q.result(distinct: true)
      .includes(:recipe_ingredients, :ingredients))

    respond_to do |format|
      format.json { render json: @recipes }
      format.html { render :index }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @recipe }
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
