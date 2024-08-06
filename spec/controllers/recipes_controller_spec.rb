# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  describe 'GET #index' do
    let!(:recipes) { create_list(:recipe, 3) }

    context 'with HTML format' do
      before { get :index }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end

      it 'assigns @should_sort to false' do
        expect(assigns(:should_sort)).to be false
      end

      it 'assigns @q as a Ransack search' do
        expect(assigns(:q)).to be_a(Ransack::Search)
      end

      it 'assigns @recipes' do
        expect(assigns(:recipes)).to match_array(recipes)
      end

      it 'paginates the results' do
        expect(assigns(:pagy)).to be_a(Pagy)
      end
    end

    context 'with JSON format' do
      before { get :index, format: :json }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns JSON' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns all recipes' do
        expect(response.parsed_body.size).to eq(3)
      end
    end

    context 'with search params' do
      let!(:matching_recipe) { create(:recipe, title: 'Spaghetti') }

      before { get :index, params: { q: { title_cont: 'Spaghetti' } } }

      it 'returns matching recipes', :aggregate_failures do
        expect(assigns(:recipes)).to include(matching_recipe)
        expect(assigns(:recipes)).not_to include(recipes.first)
      end
    end
  end

  describe 'GET #show' do
    let(:recipe) { create(:recipe) }

    context 'with JSON format' do
      before { get :show, params: { id: recipe.id }, format: :json }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns JSON' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns the correct recipe' do
        expect(response.parsed_body['id']).to eq(recipe.id)
      end
    end

    context 'with invalid id' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          get :show, params: { id: 'invalid' }, format: :json
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
