class AddListedIngredientsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :listed_ingredients, :string, array: true, default: []
  end
end
