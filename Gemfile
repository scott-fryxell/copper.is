source 'http://rubygems.org'
gem 'rails', '3.2.0'
gem 'declarative_authorization'
gem 'jquery-rails'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google'
gem 'omniauth-tumblr'
gem 'stripe'
gem 'dalli'
gem "foreman"
gem 'thin'


group :production do
  gem "pg"
end

group :development, :test do
  gem 'simplecov', :require => false
  gem 'rspec-rails'
  gem 'capybara'
  gem "sqlite3-ruby", :require => "sqlite3"
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'pry'
  gem 'rb-fsevent'
  gem 'spork', '> 0.9.0.rc'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
end
