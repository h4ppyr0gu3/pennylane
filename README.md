# Pennylane Recipe Finder

## Stack
- PostgreSQL
- Ruby
- Rails
- Rubocop
- Devise
- Rspec

## Future Improvements

This is a very simple application to search for recipes based on ingredients.
There are some possible improvements to make here, such as:
- Add category table related to recipes
- Add cuisine table related to recipes
- Add author table related to recipes
- Proper Input of Recipes with Ingredients would provide better results

## Shortfalls

- Currently the use of endpoints is not following best practices
- no access control
- no validations

## Installation

Edit the .env file or set the following variables:
```
DB_HOST
DB_PASSWORD
DB_USERNAME
DB_PORT
```

run `rails db:create` to create the database
run `rails db:migrate` to migrate the database
run `rails s`

## Testing

run `rspec`

