require 'spec_helper'

describe User do
  before :each do
    @me = create!(:user)
  end
  describe 'identities' do
    describe 'at least one' do
      it 'doesn\'t allow removal of last' do pending
        @me.identities.count.should == 1
        @me.identities.first.destroy
        @me.identities.count.should > 0
        @her.identities.count.should > 0
      end
      
      it 'doesn\'t allow removal of last' do pending
        @me.identities.count.should == 1
        identity = @me.identities.first
        @her.identities << identity
        proc { identity.save! }.should raise_error
        @me.identities.count.should > 0
        @her.identities.count.should > 0
      end
    end
  end
  
  describe 'addresses' do
    it 'has 2 lines, a postal code, a country, a state, a territory, and a city' do
      @me.should respond_to(:payable_to)
      @me.should respond_to(:line1)
      @me.should respond_to(:line2)
      @me.should respond_to(:postal_code)
      @me.should respond_to(:country_code)
      @me.should respond_to(:subregion_code)
      @me.should respond_to(:city)

      @me.should respond_to(:payable_to=)
      @me.should respond_to(:line1=)
      @me.should respond_to(:line2=)
      @me.should respond_to(:postal_code=)
      @me.should respond_to(:country_code=)
      @me.should respond_to(:subregion_code=)
      @me.should respond_to(:city=)
    end
  end
end
