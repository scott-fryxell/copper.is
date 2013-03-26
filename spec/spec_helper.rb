require 'rubygems'
require 'spork'

Spork.prefork do
  def create!(factory,*args)
    record = FactoryGirl.create(factory,*args)
    record.save!
    record.reload
    # record.should be_valid
    record
  end

  ENV["RAILS_ENV"] = 'test'
  if ENV['RCOV']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec'
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'declarative_authorization/maintenance'
  require 'omniauth'
  require 'omniauth/test'
  require 'support'

  Capybara.default_driver = :webkit
  Capybara.javascript_driver = :webkit
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
    config.profile_examples = true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
    config.use_transactional_fixtures = false
    # REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
    # REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
  end

end

Spork.each_run do
  FactoryGirl.reload

  load "#{Rails.root}/config/routes.rb"
  # load "#{Rails.root}/config/authorization_rules.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each {|f| load f}
  Dir["#{Rails.root}/lib/**/*.rb"].each {|f| load f}

  RSpec.configure do |config|

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
      class Stripe::Customer
        # def self.create(*args)
        #   puts "create #{args}"
        #   OpenStruct.new(id:'1', :active_card=>{type:'Visa', exp_year:'2015', exp_month:'4', last4:"4242"})
        # end
        def self.retrieve(*args)
          # puts "retrieve #{args}"
          OpenStruct.new(id:'1', save:"", :active_card=>{type:'Visa', exp_year:'2015', exp_month:'4', last4:"4242"})
        end
      end

      class Stripe::Charge
        def self.create(*args)
          # puts "charge #{args}"
          OpenStruct.new(id:'1', :card => {last4:'4242'})
        end
      end
    end
    config.before :each do
      Twitter.stub(:update)
      DatabaseCleaner.start
    end
    config.after :each do
      DatabaseCleaner.clean
    end
  end
end