require 'rubygems'
require 'spork'
require 'resque_spec/scheduler'
require 'ostruct'

Spork.prefork do
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb' ))].each {|f| require f}

  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require 'simplecov'
  SimpleCov.start 'rails'

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec'
  require 'capybara/rspec'

  require 'declarative_authorization/maintenance'
  require 'rack/test'
  require 'omniauth'
  require 'omniauth/test'

  Capybara.default_driver = :webkit
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"

  include Authorization::TestHelper

  RSpec.configure do |config|

    config.around(:each, :vcr) do |example|
      name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
      VCR.use_cassette(name) { example.call }
    end
    config.fail_fast = true
    # config.include Rack::Test::Methods
    config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
    config.mock_with :rspec

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
    REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
  end
end

Spork.each_run do
  FactoryGirl.reload

  RSpec.configure do |config|
    require Rails.root.join("db/seeds.rb")
    # This code will be run each time you run your specs.
    config.filter_run_excluding :broken => true
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}
    end

    config.before(:each) do
      DatabaseCleaner.start
      ResqueSpec.reset!
      ResqueSpec.inline = true
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end
