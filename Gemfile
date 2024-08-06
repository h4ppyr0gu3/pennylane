# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bootsnap', require: false
gem 'devise', '~> 4.9'
gem 'importmap-rails'
gem 'jbuilder'
gem 'pagy', '~> 9.0'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.8', '>= 7.0.8.1'
gem 'ransack', '~> 4.2'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot', '~> 6.4'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'pry', '~> 0.14.2'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rspec-rails', '~> 6.1'
  gem 'rubocop', '~> 1.65'
  gem 'rubocop-rails', '~> 2.25'
  gem 'rubocop-rspec', '~> 3.0'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
