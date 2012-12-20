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
  puts "processing triaged pages"
  Page.orphaned.each do |page|
    puts page.url
    page.discover_identity!    
  end

  # puts "processing triaged pages"
  # Page.triaged.each do |page|
  #   puts page.url
  #   page.find_identity_from_author_link!
  # end

  # puts "processing fostered pages"
  # Page.fostered.each do |page|
  #   puts page.url
  #   page.find_identity_from_page_links!
  # end
end


task :reset_page_state => :environment do
  Page.all.each do |page|
    page.author_state = 'orphaned'
    page.save!
  end

  # Page.triaged.each |page| do
  #   page.find_identity_from_author_link!
  # end

  # Page.fostered.each |page| do
  #   page.find_identity_from_page_links!
  # end
end


namespace :db do
  task :bounce => %w{drop:all create:all migrate seed} do
    `cp ./db/development.sqlite3 ./db/test.sqlite3`
  end
end
