require 'spec_helper'

describe 'fan tips a page' do
  before do
    @fan = Fan.create!
  end
  
  it 'creates a tip' do
    proc do
      @fan.tip!(30,'http://example.com','Example Page')
    end.should change(Tip,:count).by(1)
  end
end
