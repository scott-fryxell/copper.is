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

  namespace :page do
    task :adopt => :environment do
      adoption_rate = Page.adoption_rate
      puts "processing #{Page.orphaned.count} orphaned pages"
      Page.orphaned.each do |page|
        begin
          page.discover_identity!
        rescue => e
          # puts "Page#discover_identity: on: #{page.url}"
          # puts ":    #{e.class}: #{e.message}"
          page.reject!
        end
        if adoption_rate != Page.adoption_rate
          adoption_rate = Page.adoption_rate
          puts ":    #{Page.adoption_rate}% adopted"
        end
      end
      puts "Complete. #{Page.adopted.count} pages adopted."

      puts "Processing #{Page.fostered.count} fostered pages"
      Page.fostered.each do |page|
        begin
          page.find_identity_from_page_links!
        rescue => e    
          # puts "Page#find_identity_from_page_links: on: #{page.url}"
          # puts ":    #{e.class}: #{e.message}"
          page.reject!
        end
        if adoption_rate != Page.adoption_rate
          adoption_rate = Page.adoption_rate
          puts ":    #{Page.adoption_rate}% adopted"
        end
      end

      puts "Complete."
      puts ":    #{Page.adopted.count} adopted pages."
      puts ":    #{Page.manual.count} manual pages"
      puts ":    #{Page.dead.count} dead pages"
    end

    task :learn => :environment do
      puts "learninhg about pages"
      # create a thumbnail
      # TODO: categorize, determine id it's NSFW
      Page.all.each do |page|
        page.discover_thumbnail
      end    
    end
  end
end


task :reset_page_adoption => :environment do
  Identity.all.each do |identity|
    identity.destroy
  end

  Page.all.each do |page|
    page.author_state = 'orphaned'
    page.identity = nil
    page.save!
  end
end


namespace :db do
  task :bounce => %w{drop:all create:all migrate seed} do
    `cp ./db/development.sqlite3 ./db/test.sqlite3`
  end
end
