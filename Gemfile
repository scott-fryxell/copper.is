source 'http://rubygems.org'
gem 'rails', '3.2.0'
gem 'declarative_authorization'
gem 'jquery-rails'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-tumblr'
gem 'omniauth-google-oauth2'
gem 'stripe'
gem 'dalli'
gem "foreman"
gem 'thin'
gem 'newrelic_rpm'
gem 'redis'
gem 'resque'

group :production do
  gem "pg"
end

group :development, :test do
  gem 'simplecov', :require => false
  gem 'rspec-rails'
  gem "capybara-webkit"
  gem 'database_cleaner', '~> 0.6.7'
  gem "sqlite3-ruby", :require => "sqlite3"
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'pry'
  gem 'rb-fsevent'
  gem 'spork', '> 0.9.0.rc'
  gem 'ruby_parser'
  gem 'launchy'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'yui-compressor'
end
