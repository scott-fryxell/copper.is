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


task :work_pages_over => :environment do
  logger_output = lambda {|p| puts "id=#{p.id}, #{p.url[0...120]}"}

  puts "processing orphaned pages"
  Page.orphaned.each do |page|
    logger_output.call page
    page.discover_identity
  end

  puts "processing triaged pages"
  Page.triaged.each do |page|
    logger_output.call page
    page.find_identity_from_author_link
  end

  puts "processing fostered pages"
  Page.fostered.limit(20).each do |page|
    logger_output.call page
    page.find_identity_from_page_links
  end
end


task :reset_page_state => :environment do
  Page.all.each do |page|
    page.author_state = 'orphaned'
    page.save!
  end
end


namespace :db do
  task :bounce => %w{drop:all create:all migrate seed} do
    `cp ./db/development.sqlite3 ./db/test.sqlite3`
  end
end
