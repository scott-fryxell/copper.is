namespace :copper do
  namespace :job do
    task :orphaned_pages => :environment do
      Resque.enqueue OrphanedPagesJob
    end
    task :providerable_pages => :environment do
      Resque.enqueue ProviderablePagesJob
    end
    task :spiderable_pages => :environment do
      Resque.enqueue SpiderablePagesJob
    end
  end
end

namespace :db do
  task :bounce => %w{drop:all create:all migrate seed} do
    `cp ./db/development.sqlite3 ./db/test.sqlite3`
  end
end
