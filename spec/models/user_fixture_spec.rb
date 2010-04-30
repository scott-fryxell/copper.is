require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users
  
  it "should find the sample user from the fixture" do
    User.find_by_email('test@test.com').should_not be_nil
  end
  
  it "should not find a sample user that's not in the fixtures" 
  
end
