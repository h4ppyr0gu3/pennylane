# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IngredientsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'POST #create' do
    context 'with valid params' do
      let!(:existing_ingredient) { create(:ingredient, name: 'Tomato') }
      let!(:new_ingredient) { create(:ingredient, name: 'Potato') }

      before do
        user.ingredients << existing_ingredient
      end

      it 'adds new ingredients to user' do
        expect do
          post :create, params: { name: 'Potato' }
        end.to change(user.ingredients, :count).by(1)
      end

      it "doesn't add existing ingredients" do
        expect do
          post :create, params: { name: 'Tomato' }
        end.not_to change(user.ingredients, :count)
      end

      it "adds ingredient name to user's listed_ingredients" do
        post :create, params: { name: 'Potato' }
        user.reload
        expect(user.listed_ingredients).to include('Potato')
      end

      it 'ensures listed_ingredients are unique' do
        user.update(listed_ingredients: ['Potato'])
        post :create, params: { name: 'Potato' }
        user.reload
        expect(user.listed_ingredients.count('Potato')).to eq(1)
      end

      it 'redirects to root_path for HTML request' do
        post :create, params: { name: 'Potato' }
        expect(response).to redirect_to(root_path)
      end

      it 'returns JSON for JSON request' do
        post :create, params: { name: 'Potato' }, format: :json
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "doesn't add ingredients when name is blank" do
        expect do
          post :create, params: { name: '' }
        end.not_to change(user.ingredients, :count)
      end

      it "doesn't add ingredients when name is nil" do
        expect do
          post :create, params: { name: nil }
        end.not_to change(user.ingredients, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:ingredient) { create(:ingredient, name: 'Tomato') }

    before do
      user.ingredients << ingredient
      user.update(listed_ingredients: ['Tomato'])
    end

    context 'with valid params' do
      it "removes ingredient from user's listed_ingredients" do
        delete :destroy, params: { id: 'Tomato' }
        user.reload
        expect(user.listed_ingredients).not_to include('Tomato')
      end

      it 'removes association between user and ingredient' do
        expect do
          delete :destroy, params: { id: 'Tomato' }
        end.to change(user.ingredients, :count).by(-1)
      end

      it 'redirects to root_path' do
        delete :destroy, params: { id: 'Tomato' }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      it "doesn't remove anything when id is blank" do
        expect do
          delete :destroy, params: { id: '' }
        end.not_to change(user.ingredients, :count)
      end
    end
  end
end
