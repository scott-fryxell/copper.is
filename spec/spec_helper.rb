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

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
end

Webrat.configure do |config|
  config.mode = :rails
end

Fixtures.reset_cache
fixtures_folder = File.join(RAILS_ROOT, 'spec', 'fixtures')
fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
Fixtures.create_fixtures(fixtures_folder, fixtures)