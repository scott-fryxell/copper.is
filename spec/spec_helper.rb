require 'rubygems'
require 'spork'
require 'resque_spec/scheduler'
require 'ostruct'

Spork.prefork do
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

  Capybara.default_driver = :webkit
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"

  include Authorization::TestHelper
  RSpec.configure do |config|
    config.filter_run_excluding :broken => true
    # config.fail_fast = true
    # config.include Rack::Test::Methods
    config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
    config.mock_with :rspec

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
  
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb' ))].each do |f| 
    load f
  end

  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner.start
      DatabaseCleaner.strategy = :truncation #, {:except => %w[roles]}
      ResqueSpec.reset!
      ResqueSpec.inline = true
      
      class Stripe::Customer
        def self.create(*args)
          OpenStruct.new(id:'1')
        end
      end
      
      class Stripe::Charge
        def self.create(*args)
          OpenStruct.new(id:'1')
        end
      end
    end
      
    config.before(:all) do
      @stranger = FactoryGirl.create(:identities_vimeo)
      @wanted = FactoryGirl.create(:identities_soundcloud,identity_state:'wanted')

      @page1 = FactoryGirl.create(:page,author_state:'adopted')
      @page2 = FactoryGirl.create(:page,author_state:'adopted')

      @wanted.pages << @page1
      @wanted.pages << @page2

      @me = FactoryGirl.create(:user)
      @her = FactoryGirl.create(:user_twitter)
      
      @my_identity = @me.identities.first
      @her_identity = @her.identities.first
      
      @my_tip = @me.tip(url:@page1.url)

      @her_tip1 = @her.tip(url:@page1.url)
      @her_tip2 = @her.tip(url:@page2.url)
    end
    
    config.after(:suite) do
      DatabaseCleaner.clean
    end
  end
end
