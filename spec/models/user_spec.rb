require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :roles_users, :addresses, :accounts, :orders, :transactions, :refills, :tip_bundles, :tips

  it "should find the sample user from the fixture" do
    User.find_by_email('test@test.com').should_not be_nil
  end

  it "should not find a sample user that's not in the fixtures" do
    User.find_by_email('nonexistent@test.com').should be_nil
  end

  it "should be a patron" do
    User.find_by_email('test@test.com').roles.collect { |role| role.name }.should include("Patron")
  end

  it "should default to having no activation date set" do
    User.find_by_email('notactive@test.com').activation_date.should be_nil
  end

  describe "when creating a tip directly from the User" do
    it "should fail if no funds are available" do
      lambda { User.find_by_email('patron@test.com').tip('http://example.com', 1) }.should raise_exception InsufficientFunds
    end

    it "should fail if the new tip would cause the tip value to drop below the threshold" do
      fan = users(:patron)
      transaction = Transaction.create(:account => accounts(:simple), :order => orders(:o4),:amount_in_cents => 4)

      bundle = TipBundle.create(:fan => fan)
      bundle.refills << Refill.create(:transaction => transaction, :amount_in_cents => 3)
      bundle.save.should be_true

      lambda { fan.tip('http://example.com', 'sample page', 3) }.should_not raise_exception InsufficientFunds
      lambda { fan.tip('http://anotheryourself.com', 'iam lakech', 1) }.should raise_exception InsufficientFunds
    end

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
  end

  describe "when loading the list of active users" do
    before(:each) do
      @users = User.find_active_users
    end

    it "should find the active users" do
      @users.detect { |user| user.email == 'test@test.com' }.should be_true
      @users.detect { |user| user.email == 'admin@test.com' }.should be_true
    end

    it "shouldn't find the inactive users" do
      @users.detect { |user| user.email == 'notactive@test.com' }.should be_false
    end

    it "should have an activation date for each user" do
      @users.detect { |user| user.activation_date }.should_not be_nil
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
