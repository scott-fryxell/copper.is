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
    @stranger = FactoryGirl.create(:identities_vimeo)
    @wanted = FactoryGirl.create(:identities_soundcloud,identity_state:'wanted')

    @page1 = FactoryGirl.create(:page,author_state:'adopted')
    @page2 = FactoryGirl.create(:page,author_state:'adopted')

    @wanted.pages << @page1
    @wanted.pages << @page2

    @me = FactoryGirl.build(:user)
    @me.save!
    @my_tip = @me.tip(url:@page1.url)

    @her = FactoryGirl.build(:user_twitter)
    @her.save!
    @her_tip1 = @her.tip(url:@page1.url)
    @her_tip2 = @her.tip(url:@page2.url)

    instance_eval { yield } if block_given?

    @her_tip2.pay!
    @her_tip2.check_id = 2
    @her_tip2.save!
  end
end

def create_me_her_db_with_orders
  create_me_her_db do
    Stripe::Charge.stub(:create) { OpenStruct.new(id:1) }
    @me.current_order.rotate!
    @me.orders.unpaid.first.charge!
    @my_paid_order = @me.orders.paid.first
    @my_denied_order = FactoryGirl.create(:order_denied)
    @me.orders << @my_denied_order

    Stripe::Charge.stub(:create) { OpenStruct.new(id:2) }
    @her.current_order.rotate!
    @her.orders.unpaid.first.charge!
    @her_paid_order = @her.orders.paid.first
    @her_denied_order = FactoryGirl.create(:order_denied)
    @her.orders << @her_denied_order

    tip = @her.tip(url:@page2.url,amount_in_cents:2000)
    @her_check = FactoryGirl.create(:check)
    @her_check.tips << tip

    tip = @her.tip(url:@page2.url,amount_in_cents:2000)
    @her_check_paid = FactoryGirl.create(:check_paid)
    @her_check_paid.tips << tip

    tip = @her.tip(url:@page2.url,amount_in_cents:2000)
    @her_check_cashed = FactoryGirl.create(:check_cashed)
    @her_check_cashed.tips << tip

    @her.checks << @her_check
    @her.checks << @her_check_paid
    @her.checks << @her_check_cashed

    tip = @me.tip(url:@page2.url,amount_in_cents:2000)
    @check = FactoryGirl.create(:check)
    @check.tips << tip

    tip = @me.tip(url:@page2.url,amount_in_cents:2000)
    @check_paid = FactoryGirl.create(:check_paid)
    @check_paid.tips << tip

    tip = @me.tip(url:@page2.url,amount_in_cents:2000)
    @check_cashed = FactoryGirl.create(:check_cashed)
    @check_cashed.tips << tip
    @check_cashed.save!

    @me.checks << @check
    @me.checks << @check_paid
    @me.checks << @check_cashed
  end
end

