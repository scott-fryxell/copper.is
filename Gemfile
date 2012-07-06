source 'http://rubygems.org'

gem 'rails', '3.2.5'
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

gem 'jbuilder'
gem 'stripe'
gem 'dalli'
gem "foreman"
gem 'unicorn'

gem 'redis'
gem 'resque', '1.20.0'
# gem 'resque-scheduler', :require => 'resque_scheduler'
# gem 'resque-heroku-scaling-canary'
gem 'state_machine'
gem 'nokogiri'
gem 'twitter'
gem 'youtube_it'
gem 'rails_admin'
gem 'paper_trail', '~> 2'
gem 'bourbon'

group :production do
  gem "pg"
end

group :development, :production do
 gem 'newrelic_rpm'

end

group :development, :test do
  gem 'simplecov', :require => false
  gem 'sqlite3', :require => 'sqlite3'
  gem 'pry'
  gem 'ruby_parser'
  gem 'heroku'
  gem 'rspec-rails'
  gem "capybara-webkit"
  gem 'database_cleaner', '~> 0.6.7'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'rb-fsevent'
  gem 'spork-rails'
  gem 'launchy'
  gem 'ruby-graphviz', '~> 0.9.17'
  gem 'rails-erd'
end

group :test do
  gem 'factory_girl_rails'
  gem 'resque_spec'
  gem 'hashugar'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem "sass", "~> 3.2.0.alpha.244"
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'yui-compressor'
end

group :development do
  gem 'quiet_assets'
  gem 'guard-rake'
  gem 'redcarpet'
  gem 'yard'
end
