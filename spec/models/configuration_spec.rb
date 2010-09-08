require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Configuration do

  before(:each) do
    @fee_percent = Configuration.find_by_property('fee_percent')
  end

  it "should store a billing rate percent for use when calculating fees and refills" do
    @fee_percent.property.should == "fee_percent"
    @fee_percent.value.should == "7"
  end

end