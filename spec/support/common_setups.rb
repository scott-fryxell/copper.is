def her_setup
  @her = create!(:user, name:'josephene')
  @page1 = create!(:page,author_state:'adopted')
  @page2 = create!(:page,author_state:'adopted')
  @her_tip1 = @her.tip(url:@page1.url)
  @her_tip2 = @her.tip(url:@page2.url)
end

def me_setup
  @me = create!(:user)
  @page1 = create!(:page,author_state:'adopted')
  @my_tip = @me.tip(url:@page1.url)
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.ignore_localhost = true
  c.cassette_library_dir = 'tmp/cassettes'
  c.hook_into :webmock
end
