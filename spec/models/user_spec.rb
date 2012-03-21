require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :roles, :users, :roles_users, :tip_orders, :tips

  it "should find the sample user from the fixture" do
    users(:a_fan).should_not be_nil
  end

  it "should not find a sample user that's not in the fixtures" do
    User.find_by_name('nonexistent').should be_nil
  end

  it "should be a patron" do
    # TODO: when we sort out our fixture situation we should re test this
    # users(:a_fan).roles.collect { |role| role.name }.should include("Patron")
  end

  it "should have a tip rate" do
    users(:a_fan).tip_preference_in_cents.should_not be_nil
    users(:a_fan).tip_preference_in_cents.should == 25
  end

  it "should allow a tip rate to be assigned to it" do
    u = users(:a_fan)
    u.tip_preference_in_cents = 10
    u.save.should be_true
  end

  describe "tiping" do

    it "should complain if the tip url is not valid" do
      fan = users(:a_fan)
      fan.tip('foobar').should be_nil
    end

    it "should handle project-free-tv.com urls", :focus=>true do
      fan = users(:a_fan)
      tip = fan.tip('http://www.free-tv-video-online.me/player/divxden.php?id=fpjbj7rqnv8y', 'Project%20Free%20TV%20-%20Watch%20%9160%20Minutes%20(US)%20Season%2044%20Episode%2025%92%20%20on%20Divxden%20for%20free')
    end

    it "should allow the description to be passed along with the tip URL" do
      fan = users(:a_fan)
      tip = fan.tip('example.com/somepath/random-other-stuff', 'a unique page description')
      tip.locator.page.description.should == 'a unique page description'
    end

  end

  describe "active_tips method" do

    it "should return a list of tips for a user with an current tip order" do
      @user = users(:a_fan)
      @user.active_tips.should_not be_nil
      @user.active_tips.size.should be > 1
      @user.active_tips.should be_an_instance_of Array
    end

    it "should not error out if the user does not have an active tip order" do
      @user = users(:a_fan)
      @user.active_tips.should_not be_nil
      @user.active_tips.size.should be == 8
      @user.active_tips.should be_an_instance_of Array
    end
  end

  describe "creating a stripe account" do

    it "should be able to retrieve a token from stripe.com" do

      stripe = Stripe::Token.create(
          :card => {
          :number => "4242424242424242",
          :exp_month => 3,
          :exp_year => 2013,
          :cvc => 314
        },
          :currency => "usd"
      )

      @user = users(:a_fan)
      @user.stripe_customer_id.should be_nil
      @user.create_stripe_customer(stripe.id).should_not be_nil
      @user.stripe_customer_id.should_not be_nil
      @user.delete_stripe_customer
    end

    it "should not create a customer with an invalid card" do
      number = 424242424242
      exp_month = 11
      exp_year = 201
      cvc = 666
      description = "testing creating a customer"
      @user = users(:a_fan)
      lambda{@user.create_stripe_token(number, exp_month, exp_year, cvc, description)}.should raise_error
    end

  end

end
