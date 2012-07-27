class OpenStruct
  def to_json(*args)
    table.to_json
  end
end

def her_setup
  @page1 = create!(:page,author_state:'adopted')
  @page2 = create!(:page,author_state:'adopted')
  
  @her = create!(:user_phony)
  @her_identity = @her.identities.first
  @her_tip1 = @her.tip(url:@page1.url)
  @her_tip2 = @her.tip(url:@page2.url)
end

def me_setup
  @page1 = create!(:page,author_state:'adopted')
  @me = create!(:user)
  @my_identity = @me.identities.first
  @my_tip = @me.tip(url:@page1.url)
end

def other_setup 
  @stranger = create!(:identities_phony)

  @page1 = create!(:page,author_state:'adopted')
  @page2 = create!(:page,author_state:'adopted')

  @wanted = create!(:identities_phony,identity_state:'wanted')
  @wanted.pages << @page1
  @wanted.pages << @page2

end