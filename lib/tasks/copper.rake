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
        Resque.enqueue page.class, page.id, :discover_author!
      end
    end

    task :learn => :environment do
      Page.all.each do |page|
        puts "spidering page: #{page.id}"
        Resque.enqueue page.class, page.id, :learn
      end
    end
  end

  namespace :order do

    task :rotate_orders => :environment do
      User.billable

      Order.current.where(created_at:1.week.ago).each do |order|

        if order.user.billable?
          if order.billable?
            #TODO: this can be done as a scope. it will scale better scoped
            Resque.enqueue order.class, order.id, :rotate!
          end
        else
          Resque.enqueue User.class, order.user.id, :ask_user_for_payment_info
        end

      end
    end

    task :charge_unpaid_orders => :environment do

      Order.unpaid.each do |order|
        if order.user.billable?
          Resque.enqueue order.class, order.id, :charge!
        end
      end
    end

  end

  namespace :messaging do

    task :fans_who_have_tipped => :environment do

      User.where('users.stripe_id IS NOT NULL').each do |user|
        if user.tips.count > 0
          # puts "gonna message #{user.email}"
          Resque.enqueue user.class, user.id, :send_message_to_fans_who_have_tipped
        end
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
        if user.stripe_id
          user.stripe_id = 'cus_1ZPqPjxc87MHT9'
          user.accept_terms = true
          user.email ="scott@copper.is"
          user.save
        end
      end
    end
    task :set_email_to_scott => :environment do
      User.all.each do |user|
        user.email='scott@copper.is'
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
  task :bounce => %w{db:reset db:test:prepare} do
  end
end
