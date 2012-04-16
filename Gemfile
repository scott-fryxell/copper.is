source 'http://rubygems.org'
gem 'rails', '3.2.3'
gem 'declarative_authorization'
gem 'jquery-rails'

gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-flickr'
gem 'omniauth-facebook'
gem 'omniauth-tumblr'
gem 'omniauth-github'
gem 'omniauth-vimeo'
gem 'omniauth-soundcloud', '~> 1.0.0'
gem 'omniauth-google-oauth2'

gem 'stripe'
gem 'dalli'
gem "foreman"
gem 'thin'
gem 'newrelic_rpm'
gem 'redis'
gem 'resque'
gem 'resque-scheduler', :require => 'resque_scheduler'
# gem 'resque-heroku-scaling-canary'
gem 'addressable'
gem 'state_machine'
gem 'nokogiri'
gem 'twitter'

group :production do
  gem "pg"
end

group :development, :test do
  gem 'simplecov', :require => false
  gem "sqlite3-ruby", :require => "sqlite3"
  gem 'pry'
  gem 'ruby_parser'
  gem 'heroku'
  gem 'rspec-rails'
  gem "capybara-webkit"
  gem 'database_cleaner', '~> 0.6.7'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'rb-fsevent'
  gem 'spork', '> 0.9.0.rc'
  gem 'launchy'
end

group :test do
  gem 'factory_girl_rails'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'yui-compressor'
end
