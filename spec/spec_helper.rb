require 'spork'

Spork.prefork do

end

Spork.each_run do
  require 'simplecov'
  SimpleCov.start 'rails'

  ENV["RAILS_ENV"] = 'test'
  require File.expand_path("../../config/environment", __FILE__)
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  # require 'rack/utils'
  require 'rspec'
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'declarative_authorization/maintenance'
  require 'omniauth'
  require 'omniauth/test'
  require 'capybara/poltergeist'

  def create!(factory,*args)
    record = FactoryGirl.create(factory,*args)
    record.save!
    record.reload
    # record.should be_valid
    record
  end

  # Capybara.app = Rack::ShowExceptions.new(Copper::Application)
  # Capybara.default_driver = :webkit
  # Capybara.javascript_driver = :webkit
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
  Capybara.default_selector = :css
  Capybara.ignore_hidden_elements = false
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"
  include Authorization::TestHelper

  RSpec.configure do |config|
    config.include Capybara::DSL
    config.filter_run_excluding :broken => true
    config.fail_fast = false
    config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
    config.mock_with :rspec
    config.profile_examples = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
    config.use_transactional_fixtures = false
    # REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
    # REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"

    config.around(:each, :vcr) do |example|
      name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
      options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
      VCR.use_cassette(name, options) { example.call }
    end
    # Request specs cannot use a transaction because Capybara runs in a
    # separate thread with a different database connection.
    config.before type: :request do
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}
    end
    config.before :suite do
      ResqueSpec.reset!
      ResqueSpec.inline = true
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation, {:except => %w[roles]})
    end
    config.before :each do
      DatabaseCleaner.start
    end
    config.after :each do
      DatabaseCleaner.clean
    end

  end

  FactoryGirl.reload

  load "#{Rails.root}/config/routes.rb"
  # load "#{Rails.root}/config/authorization_rules.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each {|f| load f}
  Dir["#{Rails.root}/lib/**/*.rb"].each {|f| load f}

end