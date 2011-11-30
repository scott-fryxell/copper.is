source 'http://rubygems.org'
gem 'rails', '3.1.0'
gem 'declarative_authorization'
gem 'jquery-rails'
gem 'omniauth', '0.3.2'
# gem 'oa-openid'
gem 'stripe'

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
  gem 'sass-rails',   "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end
