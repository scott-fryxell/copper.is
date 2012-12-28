source 'http://rubygems.org'

gem 'rails', '3.2.9'
gem 'declarative_authorization'
gem 'jquery-rails'

gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-flickr'
gem 'omniauth-facebook'
gem 'omniauth-tumblr'
gem 'omniauth-github'
gem 'omniauth-vimeo'
gem 'omniauth-soundcloud'
gem 'omniauth-google-oauth2'

gem 'jbuilder'
gem 'stripe'
gem 'dalli'
gem "foreman"
gem 'unicorn'

gem 'redis'
gem 'resque', "~> 1.22.0"
gem 'state_machine'
gem 'nokogiri'
gem 'twitter'
gem 'youtube_it'
gem 'paper_trail', '~> 2'
gem 'carmen-rails'
gem "vimeo"
gem 'koala'
gem 'mechanize'

# gem 'rack-mini-profiler'
# gem 'resque-scheduler', :require => 'resque_scheduler'
# gem 'resque-heroku-scaling-canary'

group :production do
  gem "pg"
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'simplecov', :require => false
  gem 'sqlite3', :require => 'sqlite3'
  gem 'pry'
  gem 'ruby_parser'
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
  gem 'quiet_assets'
end

group :test do
  gem 'factory_girl_rails'
  gem 'resque_spec'
  gem 'hashugar'
end

gem 'sass-rails',   '~> 3.2.3' # needed global for heroku
gem 'bourbon'
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier'
  gem 'yui-compressor'
end

group :development do
  gem 'guard-rake'
  gem 'redcarpet'
  gem 'yard'
end