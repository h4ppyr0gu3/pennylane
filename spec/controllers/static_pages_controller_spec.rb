# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    context 'when user is not logged in' do
      it 'returns http success' do
        get :home
        expect(response).to have_http_status(:redirect)
      end

      it 'does not assign @recipes' do
        get :home
        expect(assigns(:recipes)).to be_nil
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }
      let!(:ingredient1) { create(:ingredient) }
      let!(:ingredient2) { create(:ingredient) }
      let!(:recipe1) { create(:recipe, ingredients: [ingredient1, ingredient2]) }
      let!(:recipe2) { create(:recipe, ingredients: [ingredient1]) }
      let!(:recipe3) { create(:recipe, ingredients: []) }

      before do
        sign_in user
        user.ingredients << [ingredient1, ingredient2]
      end

      it 'returns http success' do
        get :home
        expect(response).to have_http_status(:success)
      end

      it 'assigns @recipes' do
        get :home
        expect(assigns(:recipes)).not_to be_nil
      end

      it 'sets @should_sort to false' do
        get :home
        expect(assigns(:should_sort)).to be false
      end

      it 'recommends recipes based on user ingredients', :aggregate_failures do
        get :home
        recipes = assigns(:recipes)
        expect(recipes).to include(recipe1, recipe2)
        expect(recipes).not_to include(recipe3)
      end

      it 'orders recipes by ingredient match count', :aggregate_failures do
        get :home
        recipes = assigns(:recipes)
        expect(recipes.first).to eq(recipe1)
        expect(recipes.second).to eq(recipe2)
      end

      it 'limits recommendations to MAX_RECOMMENDATIONS' do
        create_list(:recipe, 20, ingredients: [ingredient1, ingredient2])
        get :home
        expect(assigns(:recipes).to_a.length).to eq(StaticPagesController::MAX_RECOMMENDATIONS)
      end
    end
  end
end
