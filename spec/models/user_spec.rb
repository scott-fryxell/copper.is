require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before do
    @user = FactoryGirl.create(:user)
  end

  it "should be a patron" do
    @user.roles.first.name.should ==  'Patron'
  end

  it 'should have at least one identity' #do
  #   @user.valid?.should be_true
  #   @user.identities.count.should > 0
  # end

  it "should have a tip rate" do
    @user.tip_preference_in_cents.should_not be_nil
    @user.tip_preference_in_cents.should == 50
  end

  it "should allow a tip rate to be assigned to it" do
    u = FactoryGirl.create(:user)
    u.tip_preference_in_cents = 10
    u.save.should be_true
  end

  describe "tiping" do
    it "should complain if the tip url is not valid" do
      fan = FactoryGirl.create(:user)
      fan.tip(url:'foobar').valid?.should be_false
    end

    it "should handle project-free-tv.com urls" do
      fan = FactoryGirl.create(:user)
      tip = fan.tip(url:'http://www.free-tv-video-online.me/player/divxden.php?id=fpjbj7rqnv8y', title:'Project%20Free%20TV%20-%20Watch%20%9160%20Minutes%20(US)%20Season%2044%20Episode%2025%92%20%20on%20Divxden%20for%20free')
    end

    it "should allow the title to be passed along with the tip URL" do
      fan = FactoryGirl.create(:user)
      tip = fan.tip( url:  'example.com/somepath/random-other-stuff',
                     title:'a unique page description' )
      tip.page.title.should == 'a unique page description'
    end

  end

  describe "current tips" do
    it "should return a list of tips for a user with an current tip order" do
      @user = FactoryGirl.create(:user)
      @user.current_tips.should_not be_nil
      @user.current_tips.size.should == 0
      @user.current_tips.should be_an_instance_of Array
    end

    it "should not error out if the user does not have an active tip order" do
      @user = FactoryGirl.create(:user)
      @user.current_tips.should_not be_nil
      8.times do
        @user.tip(url:'example.com')
      end
      @user.current_tips.size.should be == 8
      @user.current_tips.should be_an_instance_of Array
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

      @user = FactoryGirl.create(:user)
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
      @user = FactoryGirl.create(:user)
      lambda{@user.create_stripe_token(number, exp_month, exp_year, cvc, description)}.should raise_error
    end
  end
end
