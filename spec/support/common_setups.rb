def her_setup
  mock_page_and_user
  @her = create!(:user, name:'josephene')
  @page1 = create!(:page,author_state:'adopted')
  @page2 = create!(:page,author_state:'adopted')
  @her_tip1 = @her.tip(url:@page1.url)
  @her_tip2 = @her.tip(url:@page2.url)
end

def me_setup
  mock_page_and_user
  @me = create!(:user)
  @page1 = create!(:page,author_state:'adopted')
  @my_tip = @me.tip(url:@page1.url)
end

def admin_setup
  mock_page_and_user
  @admin = create!(:admin)
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.ignore_localhost = true
  c.cassette_library_dir = 'tmp/cassettes'
  c.hook_into :webmock
end


# class ActiveRecord::Base
#   mattr_accessor :shared_connection
#   @@shared_connection = nil
#
#   def self.connection
#     @@shared_connection || retrieve_connection
#   end
# end
# ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection