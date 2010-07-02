require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :roles_users, :users

  it "should find the sample user from the fixture" do
    User.find_by_email('test@test.com').should_not be_nil
  end

  it "should not find a sample user that's not in the fixtures" do
    User.find_by_email('nonexistent@test.com').should be_nil
  end
  
  it "should be a patron" do
    User.find_by_email('test@test.com').roles.collect {|role| role.name }.should include("Patron")
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
  end
end
