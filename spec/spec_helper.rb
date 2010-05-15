# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'webrat/integrations/rspec-rails'
require 'lib/mail-test-helper'

# include seed data before running tests (gets cleared out otherwise)
require "#{Rails.root}/db/seeds.rb"

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
