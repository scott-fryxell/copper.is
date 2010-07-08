require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CardType do
  before(:each) do
    @type = CardType.new
    @type.name = 'bastardcard'
  end

  it "should save if all values are acceptable" do
    @type.save.should be_true
  end

  it "should require a name" do
    @type.name = nil
    @type.save.should be_false
  end
end
