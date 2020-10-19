source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'jquery-rails'
gem 'friendly_id'
gem 'will_paginate'
gem 'public_activity'
gem 'acts_as_votable'
gem 'acts_as_commentable'
gem 'acts_as_follower'
gem 'counter_culture'
gem 'faker'
gem 'populator'
gem 'auto_html', '~>1.6.4'
gem 'sanitize'
gem 'font-awesome-rails'
gem 'rubocop', require: false
gem 'devise-jwt', '~> 0.5.9'
gem 'active_model_serializers'
gem 'simple_token_authentication'
gem 'stripe-rails'
gem 'stripe'

gem 'ckeditor', github: 'galetahub/ckeditor'
gem 'mime-types'

gem 'crono'
gem 'haml'
gem 'sinatra', require: nil
gem 'daemons'

#For Admin
gem 'activeadmin'
# Plus integrations with:
gem 'cancancan'
gem 'draper'
gem 'pundit'
gem 'active_admin_flat_skin'


gem 'simple_recommender'
gem 'sprockets-rails'

gem "jquery-slick-rails"
gem 'gon'
# For Search Filters
gem 'filterrific'

gem 'notifications', '~> 0.6.0'

gem 'disco'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'devise'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2'



group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Run against the latest stable release
  gem 'rspec-rails', '~> 4.0.0'
  gem 'shoulda-matchers'

end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'railroady'
  # Use sqlite3 as the database for Active Record
  #gem 'sqlite3', '~> 1.4'
end
gem 'pg'
group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
