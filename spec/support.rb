class OpenStruct
  def to_json(*args)
    table.to_json
  end
end

def mock_page
  Page.any_instance.stub(:learn)
  Page.any_instance.stub(:discover_author)
end

def mock_order
  Order.any_instance.stub(:send_paid_order_message)
end

def mock_user
  User.any_instance.stub(send_welcome_message:[{"email"=> "scott@copper.is","status" => "sent"}])
  Author.any_instance.stub(:create_page_for_author)
end

def mock_page_and_user
  mock_page
  mock_user
end

def her_setup
  mock_page_and_user
  @her = create!(:user_phony)
  @her_author = @her.authors.first
  @page1 = create!(:page,author_state:'adopted')
  @page2 = create!(:page,author_state:'adopted')
  @her_tip1 = @her.tip(url:@page1.url)
  @her_tip2 = @her.tip(url:@page2.url)
end

def me_setup
  mock_page_and_user
  @page1 = create!(:page,author_state:'adopted')
  @me = create!(:user)
  @my_author = @me.authors.first
  @my_tip = @me.tip(url:@page1.url)
end

def other_setup
  mock_page_and_user
  @stranger = create!(:authors_phony)
  @page1 = create!(:page,author_state:'adopted')
  @page2 = create!(:page,author_state:'adopted')
  @wanted = create!(:authors_phony,author_state:'wanted')
  @wanted.pages << @page1
  @wanted.pages << @page2
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