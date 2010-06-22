require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BillingPeriod do
  # no fixtures loaded because the Billing Cycles are loaded by seeds.rb

  it "should not have a billing period with a day of the month (ID) of 0" do
    lambda { BillingPeriod.find(0) }.should raise_error ActiveRecord::RecordNotFound
  end
  
  it "should not have a billing period with a day of the month (ID) greater than 31" do
    lambda { BillingPeriod.find(32) }.should raise_error ActiveRecord::RecordNotFound
  end

  it "should have a day of the month (ID) for each of the 31 possible billing period start dates" do
    (1..31).each do |id|
      BillingPeriod.find(id).class.should == BillingPeriod
      BillingPeriod.find(id).id.should == id
    end
  end
end
