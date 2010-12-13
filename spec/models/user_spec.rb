require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :roles_users, :tip_bundles, :tips

  it "should find the sample user from the fixture" do
    User.find_by_username('test').should_not be_nil
  end

  it "should not find a sample user that's not in the fixtures" do
    User.find_by_username('nonexistent').should be_nil
  end

  it "should be a patron" do
    User.find_by_username('test').roles.collect { |role| role.name }.should include("Patron")
  end

  it "should have a tip rate" do
    User.find_by_email('test').tip_preference_in_cents.should_not be_nil
    #amount_in_cents.should == 25
  end

  it "should allow a tip rate to be assigned to it" do
    u = User.find_by_username('test')
    u.tip_preference_in_cents = 10
    u.save.should be_true
  end

  describe "when creating a tip directly from the User" do

    it "should complain if the tip url is not valid" do
      fan = users(:active)
      fan.tip('foobar').should be_nil
    end

    it "should allow the description to be passed along with the tip URL" do
      fan = users(:active)
      tip = fan.tip('example.com/somepath/random-other-stuff', 'a unique page description')
      tip.locator.page.description.should == 'a unique page description'
    end

    it "should allow a multiplier of more than 1 to be passed along with the tip URL" do
      fan = users(:active)
      tip = fan.tip('example.com/somepath/morepath', 'description', 3)
      tip.multiplier.should == 3
    end

    it "should fail if the user does not have a tip rate selected" do
      fan = users(:active)
      fan.tip_rate = nil
      fan.save
      tip = fan.tip('www.happy-times.com', 'page title')
      tip.should be_nil
    end

  end

  describe "active_tips method" do
    it "should return a list of active tips for a user with an active tip bundle" do
      @user = User.find_by_email('test@test.com')
      @user.active_tips.should_not be_nil
      @user.active_tips.size.should be > 1
      @user.active_tips.should be_an_instance_of Array
    end

    it "should not errors out if the user does not have an active tip bundle" do
      @user = User.find_by_email('publisher@test.com')
      @user.active_tips.should_not be_nil
      @user.active_tips.size.should be == 0
      @user.active_tips.should be_an_instance_of Array
    end
  end

end
