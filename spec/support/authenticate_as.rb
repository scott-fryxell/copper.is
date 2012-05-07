def authenticate_as_admin
  raise "not an admin" unless user.roles.first.name == 'admin'
end

def authenticate_as_patron(user)
  raise "that user is nil dude!" unless user
  raise "not a patron" unless user.roles.first.name == 'Patron'
  controller.instance_eval do
    cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
    @current_user = user
  end
end
 
def unauthenticate
  controller.instance_eval do
    @current_user = nil
  end
end

def create_me_her_db
  before :each do
    @stranger = FactoryGirl.create(:identities_twitter)
    @wanted = FactoryGirl.create(:identities_facebook,identity_state:'wanted')
    
    @page1 = FactoryGirl.create(:page,author_state:'adopted')
    @page2 = FactoryGirl.create(:page,author_state:'adopted')
    
    @wanted.pages << @page1
    @wanted.pages << @page2
    
    @me = FactoryGirl.create(:user)
    @my_tip = @me.tip(url:@page1.url)

    @her = FactoryGirl.create(:user)
    @her_tip1 = @her.tip(url:@page1.url)
    @her_tip2 = @her.tip(url:@page2.url)
    @her_tip2.pay!
    @her_tip2.check_id = 2
    @her_tip2.save!
  end
end

