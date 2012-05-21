namespace :copper do
  task :old_production => :environment do
    load 'extras/migrate_to_new_schema.rb'
  end
end
