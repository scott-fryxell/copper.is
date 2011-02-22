require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
require File.expand_path(File.dirname(__FILE__) + "/../../spec/fixtures/ordered_fixtures")

ENV["FIXTURE_ORDER"] ||= ""

namespace :db do
  namespace :fixtures do
    desc "Load fixtures into #{ENV['RAILS_ENV']} database in order that supports table constraints"
    task :load_ordered => :environment do
      require 'active_record/fixtures'
      ordered_fixtures = Hash.new
      ENV["FIXTURE_ORDER"].split.each { |fx| ordered_fixtures[fx] = nil }
      other_fixtures = Dir.glob(File.join(Rails.root, 'spec', 'fixtures', '*.{yml,csv}')).collect { |file| File.basename(file, '.*') }.reject {|fx| ordered_fixtures.key? fx }
      ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])
      (ordered_fixtures.keys + other_fixtures).each do |fixture|
        Fixtures.create_fixtures('spec/fixtures',  fixture)
      end unless :environment == 'production'
      # Don't load fixtures into production database
    end

    desc "Deletes all fixture tables mentioned in FIXTURE_ORDER environment in reverse order to avoid constraint problems"
    task :delete => :environment do
      require 'active_record/fixtures'
      ordered_fixtures = Hash.new
      ENV["FIXTURE_ORDER"].split.reverse.each { |fx| ordered_fixtures[fx] = nil }
      # get any other fixtures not listed in the ordered_fixtures.rb file and store them as other_fixtures
      other_fixtures = Dir.glob(File.join(Rails.root, 'spec', 'fixtures', '*.{yml,csv}')).collect { |file| File.basename(file, '.*') }.reject {|fx| ordered_fixtures.key? fx }
      ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])
      (ordered_fixtures.keys + other_fixtures).each do |fixture|
        ActiveRecord::Base.connection.update "DELETE FROM #{fixture}"
      end unless :environment == 'production'
      # Don't delete in production database
    end
  end
end