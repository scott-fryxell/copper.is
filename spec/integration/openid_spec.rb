require File.dirname(__FILE__) + '/../spec_helper'

describe "OpenID integration" do
  it "should be installed" do
    defined?(OpenID).should == "constant"
  end
end