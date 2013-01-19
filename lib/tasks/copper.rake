namespace :copper do
  namespace :page do
    task :stats => :environment do
      adoption_rate = Page.adoption_rate
      puts "processing #{Page.orphaned.count} orphaned pages"
      puts ":    #{Page.adopted.count} adopted pages."
      puts ":    #{Page.manual.count} manual pages"
      puts ":    #{Page.dead.count} dead pages"
      puts ":    #{Page.adoption_rate}% adopted"
    end

    task :adopt => :environment do
      Page.orphaned.each do |page|
        Resque.enqueue Page, page.id, :discover_author!
      end
    end

    task :learn => :environment do
      Page.all.each do |page|
        Resque.enqueue Page, page.id, :learn
      end
    end
  end

  namespace :dev do
    task :reset_page => :environment do
      Page.all.each do |page|
        page.author_state = 'orphaned'
        page.author = nil
        page.save!
      end
    end
    task :reset_stripe => :environment do
      User.all.each do |user|
        user.stripe_id = nil
        user.save
      end
    end    
    task :reset_thumbnail => :environment do
      Page.all.each do |page|
        page.thumbnail_url = nil
        page.save
      end
    end    
  end
end

namespace :db do
  task :bounce => %w{drop:all create:all migrate seed} do
    `cp ./db/development.sqlite3 ./db/test.sqlite3`
  end
end
