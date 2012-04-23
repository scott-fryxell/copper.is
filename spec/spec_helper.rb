require 'rubygems'
require 'spork'
require 'resque_spec/scheduler'

# def keypress_on(elem, key, charCode = 0)
#   keyCode = case key
#             when :enter then 13
#             else key.to_i
#             end
#   elem.base.invoke('keypress', false, false, false, false, keyCode, charCode);
# end
# 
# def authenticate_as_admin
# end
# 
# def authenticate_as_patron
# end
# 
# def unauthenticate
# end

def  slow_test
  unless ENV['FAST_TEST']
    yield
  else
    puts 'WARN: skipping slow tests'
  end
end

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
  Capybara.server_port = 8080
  Capybara.app_host = "http://127.0.0.1:8080"

  include Authorization::TestHelper

  RSpec.configure do |config|
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

    # config.before(:suite) do
    #   redis_options = {
    #     "daemonize"     => 'yes',
    #     "pidfile"       => REDIS_PID,
    #     "port"          => 9736,
    #     "timeout"       => 300,
    #     "save 900"      => 1,
    #     "save 300"      => 1,
    #     "save 60"       => 10000,
    #     "dbfilename"    => "dump.rdb",
    #     "dir"           => REDIS_CACHE_PATH,
    #     "loglevel"      => "debug",
    #     "logfile"       => "stdout",
    #     "databases"     => 16
    #   }.map { |k, v| "#{k} #{v}" }.join('\n')
    #   `echo '#{redis_options}' | redis-server -`
    # end

    # config.after(:suite) do
    #   %x{
    #   cat #{REDIS_PID} | xargs kill -QUIT
    #   rm -f #{REDIS_CACHE_PATH}dump.rdb
    # }
    # end
  end
  # Resque.inline = true
end
  
Spork.each_run do
  FactoryGirl.reload

  RSpec.configure do |config|
    require Rails.root.join("db/seeds.rb")
    # This code will be run each time you run your specs.
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}
    end

    config.before(:each) do
      DatabaseCleaner.start
      ResqueSpec.reset!
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end
