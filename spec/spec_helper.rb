if ENV['COVERAGE_REPORT']
  require 'simplecov'
  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] ||= 'test'

require 'active_support/core_ext'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'webmock/rspec'

require 'rspec/rails'

require 'omniauth'
require 'omniauth/test'

require 'declarative_authorization/maintenance'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

def create!(factory,*args)
  FactoryGirl.create(factory,*args)
end

def build!(factory,*args)
  FactoryGirl.build(factory,*args)
end

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.default_selector = :css
Capybara.ignore_hidden_elements = false
Capybara.server_port = 8080
Capybara.app_host = "http://127.0.0.1:8080"
include Authorization::TestHelper

ActiveRecord::Migration.maintain_test_schema!
OmniAuth.config.test_mode = true

RSpec.configure do |config|
  # config.include(Reek::Spec) TODO: figure out how to implement reek
  config.render_views
  config.include Capybara::DSL
  config.filter_run_excluding broken:true
  config.fail_fast = false
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
  config.mock_with :rspec
  config.profile_examples = false
  config.filter_run focus:true
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, {:except => %w[roles]})
  end

  config.before :each do
    ResqueSpec.reset!
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end

end
