begin
  2.times { puts }
  require 'pp'
  
  OLD_PRODUCTION = {
    adapter:'sqlite3',
    database: 'db/old_production.sqlite3',
    pool: 5,
    timeout: 5000,
  }
  
  def make_all_columns_accessable(klass)
    klass.columns.map(&:name).each do |col|
      klass.attr_accessible col
    end
  end
  
  def prepare_table(klass)
    make_all_columns_accessable klass
    klass.delete_all
  end
  
  [User,Identity,Page,Order,Tip].each do |klass|
    prepare_table klass
  end
  
  module Old
    class User < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
    end
    
    class Identity < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
    end
    
    class Locator < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
      belongs_to :site
      
      def url
        r = self.scheme + '://' + self.site.fqdn + (self.path || '/')
        if self.query
          r += '?' + self.query
        end
        r
      end
    end
    
    class Site < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
      has_many :locators
    end
    
    class TipOrder < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
    end
    
    class Tip < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
    end
    
    class Page < ActiveRecord::Base
      establish_connection OLD_PRODUCTION
    end
  end

  Old::User.find_each do |user|
    new_user = User.create(user.attributes)
    new_user.roles << Role.find_by_name('Fan')
    new_user.save!(validate:false)
  end
  
  Old::Identity.find_each do |ident|
    i = Identity.create!(ident.attributes)
    i.identity_state = 'known'
    i.save!
  end
  
  loc_page_map = {}
  Old::Locator.find_each do |loc|
    old_page =  Old::Page.find(loc.page_id)
    page = Page.create!(url:loc.url,author_state:'orphaned',
                        title:old_page.description,
                        created_at:old_page.created_at,
                        updated_at:old_page.updated_at
                        )
    loc_page_map[loc.id] = page.id
  end
  
  Old::TipOrder.find_each do |tip_order|
    order = Order.new(id:tip_order.id,user_id:tip_order.fan_id,
                      created_at:tip_order.created_at,
                      updated_at:tip_order.updated_at,
                      charge_token:tip_order.charge_token)
    if tip_order.is_active?
      order.order_state = 'current'
    else
      order.order_state = 'paid'
    end
    order.save!(validate:false)
  end

  # User.find_each do |user|
  #   user.current_order
  # end

  Old::Tip.find_each do |tip|
    t = Tip.new(id:tip.id,amount_in_cents:tip.amount_in_cents,
                created_at:tip.created_at,
                updated_at:tip.updated_at,
                order_id:tip.tip_order_id,
                page_id:loc_page_map[tip.locator_id])
    if Order.find(t.order_id).paid?
      t.paid_state = 'charged'
    else
      t.paid_state = 'promised'
    end
    t.save!(validate:false)
  end
  
rescue => e
  puts e.message
  pp e.backtrace[0..4]
end

