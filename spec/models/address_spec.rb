require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Address do
  before(:each) do
    @address = Address.new
    @address.line_1      = "150 S 5th E"
    @address.city        = "Missoula"
    @address.state       = 'MT'
    @address.postal_code = 59801
    @address.country     = 'USA'
  end

  it "should save if all values are acceptable" do
    @address.save.should be_true
  end

  it "should require at least one address line" do
    @address.line_1 = nil
    @address.save.should be_false
  end

  it "should require a city" do
    @address.city = nil
    @address.save.should be_false
  end

  it "should require a state" do
    @address.state = nil
    @address.save.should be_false
  end

  it "should require the state to be exactly two letters long" do
    @address.state = 'Montana'
    @address.save.should be_false

    @address.state = 'M'
    @address.save.should be_false

    @address.state = 'MON'
    @address.save.should be_false
  end

  it "should require a postal code" do
    @address.postal_code = nil
    @address.save.should be_false
  end

  it "should require a country" do
    @address.country = nil
    @address.save.should be_false
  end

  it "should default the country to 'USA'" do
    address = Address.new
    address.country.should == 'USA'
  end
end
