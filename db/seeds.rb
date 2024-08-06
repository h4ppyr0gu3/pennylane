require 'json'
require 'pry'

UNIT_NAMES = %w[pinch teaspoon cup tablespoon package can slice pound clove pint dash]

def find_or_create_recipe(recipe_json)
  Recipe.find_or_create_by!(
    title: recipe_json['title'],
    instructions: recipe_json['instructions'],
    cooking_time: recipe_json['cook_time'],
    prep_time: recipe_json['prep_time'],
    image: recipe_json['image'],
    ratings: recipe_json['ratings'],
    cuisine: recipe_json['cuisine'],
    category: recipe_json['category'],
    author: recipe_json['author']
  )
end

def decimal_value(string)
  case string
  when '½'
    0.5
  when '¼'
    0.25
  when '⅓'
    0.33
  when '⅔'
    0.66
  when '¾'
    0.75
  else
    0
  end
end

def quantity_from_string(string)
  split_string = string.split(' ')
  quantity = 0.0
  first_word = split_string.first
  quantity = first_word.to_i if first_word.to_i != 0

  if quantity.zero?
    quantity = decimal_value(first_word)
  else
    quantity += decimal_value(split_string[1])
  end

  quantity
end

def ingredient_name(split_ingredient, last_index, quantity)
  if last_index.nil?
    if quantity > 0
      split_ingredient[1..].join(' ')
    else
      split_ingredient.join(' ')
    end
  elsif last_index.zero?
    split_ingredient[last_index..].join(' ')
  elsif last_index > 0
    split_ingredient[(last_index + 1)..].join(' ')
  end
end

def create_and_associate_ingredient(ingredient, recipe)
  unit_names = UNIT_NAMES.flat_map { |unit| [unit, unit.pluralize] }
  split_ingredient = ingredient.split(' ')

  ingredient_unit_name = (ingredient.split(' ') & unit_names).first
  last_index = split_ingredient.index(ingredient_unit_name)
  quantity = quantity_from_string(ingredient)

  ingredient = Ingredient.find_or_create_by!(
    name: ingredient_name(split_ingredient, last_index, quantity)
  )

  RecipeIngredient.find_or_create_by!(
    recipe: recipe,
    ingredient: ingredient,
    quantity: quantity,
    unit: ingredient_unit_name
  )
end

File.open('lib/recipes.json') do |f|
  recipes = JSON.parse(f.read)

  recipes.each_slice(50).with_index do |batch, idx|
    batch.each do |recipe|
      db_recipe = find_or_create_recipe(recipe)

      recipe['ingredients'].each do |ingredient|
        create_and_associate_ingredient(ingredient, db_recipe)
      end
    end
    puts "finished batch #{idx}"
  end
end
