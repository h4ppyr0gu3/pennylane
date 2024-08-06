class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :instructions
      t.integer :cooking_time
      t.integer :prep_time
      t.string :image
      t.float :ratings
      t.string :cuisine
      t.string :category
      t.string :author

      t.timestamps
    end
  end
end
