require 'rubygems'
require 'spork'
require 'ostruct'

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
  require 'rspec/rails'
  require 'rspec'
  require 'capybara/rspec'

  require 'declarative_authorization/maintenance'
  require 'rack/test'
  require 'omniauth'
  require 'omniauth/test'
  require 'support'

  Capybara.default_driver = :webkit
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"
  Capybara.ignore_hidden_elements = true
  include Authorization::TestHelper

  RSpec.configure do |config|
    config.filter_run_excluding :pending => true
    config.fail_fast = true
    # config.include Rack::Test::Methods
    config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
    config.mock_with :rspec
    config.profile_examples = true
    config.use_transactional_fixtures = false
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
    # REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
    # REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
  end
end

Spork.each_run do
  FactoryGirl.reload

  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.start
      DatabaseCleaner.clean
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}

      ResqueSpec.reset!
      # ResqueSpec.inline = true

      class Stripe::Customer
        def self.create(*args)
          OpenStruct.new(id:'1')
        end

        def self.retrieve(*args)
          OpenStruct.new(card:nil,save:nil)
        end
      end

      class Stripe::Charge
        def self.create(*args)
          OpenStruct.new(id:'1')
        end
      end
    end

    config.before(:all) do
      @stranger = create!(:identities_phony)
      @wanted = create!(:identities_phony,identity_state:'wanted')

      @page1 = create!(:page,author_state:'adopted')
      @page2 = create!(:page,author_state:'adopted')

      @wanted.pages << @page1
      @wanted.pages << @page2
      
      @me = create!(:user)
      @her = create!(:user_phony)

      @my_identity = @me.identities.first
      @her_identity = @her.identities.first

      @my_tip = @me.tip(url:@page1.url)

      @her_tip1 = @her.tip(url:@page1.url)
      @her_tip2 = @her.tip(url:@page2.url)
    end

    config.before(:suite) do
      DatabaseCleaner.start
      DatabaseCleaner.clean
    end

    config.after(:suite) do
      DatabaseCleaner.clean
    end
    
    config.before(:each) do
      Twitter.stub(:update)
    end
  end
end
