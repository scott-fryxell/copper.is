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
  require 'resque_spec'
  
  require 'declarative_authorization/maintenance'
  require 'rack/test'
  require 'omniauth'
  require 'omniauth/test'
  require 'support'

  Capybara.default_driver = :webkit
  Capybara.javascript_driver = :webkit
  Capybara.ignore_hidden_elements = false
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"
  include Authorization::TestHelper

  RSpec.configure do |config|
    config.filter_run_excluding :broken => true
    config.filter_run_excluding :slow => true
    config.fail_fast = true
    # config.include Rack::Test::Methods
    config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
    config.mock_with :rspec
    config.profile_examples = true
    config.use_transactional_fixtures = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
  end
end

Spork.each_run do
  FactoryGirl.reload
  
  # load Rails.root+'app/models/sti_factory.rb'
  
  # ['channels','sites'].each do |base|
  #   Dir[File.join(Rails.root,'app','models',base,'*.rb')].each do |path|
  #     load path
  #   end
  # end
  
  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.start
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}
      DatabaseCleaner.clean
    end
    
    config.before(:each) do
      ResqueSpec.reset!
    end
    
    class Stripe::Customer
      def self.create(*args)
        OpenStruct.new(id:'1', :active_card=>{type:'Visa', exp_year:'2015', exp_month:'4', last4:"4242"})
      end
      
      def self.retrieve(*args)
        OpenStruct.new(id:'1', save:"", :active_card=>{type:'Visa', exp_year:'2015', exp_month:'4242', last4:"4242"})
        end
      end
    end

    class Stripe::Charge
      def self.create(*args)
        OpenStruct.new(id:'1')
      end
    end
  end
end
