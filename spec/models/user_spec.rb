require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :roles_users, :tip_bundles, :tips

  it "should find the sample user from the fixture" do
    users(:patron).should_not be_nil
  end

  it "should not find a sample user that's not in the fixtures" do
    User.find_by_username('nonexistent').should be_nil
  end

  it "should be a patron" do
    users(:patron).roles.collect { |role| role.name }.should include("Patron")
  end

  it "should have a tip rate" do
    users(:patron).tip_preference_in_cents.should_not be_nil
    #amount_in_cents.should == 25
  end

  it "should allow a tip rate to be assigned to it" do
    u = users(:patron)
    u.tip_preference_in_cents = 10
    u.save.should be_true
  end

  describe "when creating a tip directly from the User" do

    it "should complain if the tip url is not valid" do
      fan = users(:patron)
      fan.tip('foobar').should be_nil
    end

    it "should allow the description to be passed along with the tip URL" do
      fan = users(:patron)
      tip = fan.tip('example.com/somepath/random-other-stuff', 'a unique page description')
      tip.locator.page.description.should == 'a unique page description'
    end

  end

  describe "active_tips method" do
    it "should return a list of active tips for a user with an active tip bundle" do
      @user = users(:patron)
      @user.active_tips.should_not be_nil
      @user.active_tips.size.should be > 1
      @user.active_tips.should be_an_instance_of Array
    end

    it "should not error out if the user does not have an active tip bundle" do
      @user = users(:patron)
      @user.active_tips.should_not be_nil
      @user.active_tips.size.should be == 8
      @user.active_tips.should be_an_instance_of Array
    end
  end

end
