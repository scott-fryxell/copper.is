# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'webrat/integrations/rspec-rails'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  include Webrat::Methods
end


Webrat.configure do |config|
  config.mode = :rails
end

module Spec::Rails::Example
  class IntegrationExampleGroup < ActionController::IntegrationTest

    def initialize(defined_description, options={}, &implementation)
      defined_description.instance_eval do
        def to_s
          self
        end
      end

      super(defined_description)
    end

    Spec::Example::ExampleGroupFactory.register(:integration, self)
  end
end

module MailTestHelper
  FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
  
  def load_mail_fixture(example_message)
    File.read(File.join(FIXTURE_LOAD_PATH,example_message))
  end
end