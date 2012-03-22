require 'rubygems'
require 'spork'

Spork.prefork do
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
  # Capybara.server_port = 9000
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"

  include Authorization::TestHelper

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    # config.filter_run :focus => true
    config.run_all_when_everything_filtered = false

    config.include Rack::Test::Methods
    config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy

  end
end

Spork.each_run do

  RSpec.configure do |config|
    # require Rails.root.join("db/seeds.rb")
    # This code will be run each time you run your specs.
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}

    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end