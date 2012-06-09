require 'spec_helper'

describe User do
  describe 'identities' do
    describe 'at least one', :pending do
      before do
        @me.identities.count.should == 1
      end
      
      after do
        @me.identities.count.should > 0
        @her.identities.count.should > 0
      end
     
      it 'doesn\'t allow removal of last' do
        @me.identities.first.destroy
      end
      
      it 'doesn\'t allow removal of last' do
        identity = @me.identities.first
        @her.identities << identity
        proc { identity.save! }.should raise_error
      end
    end
  end
  
  describe 'addresses' do
    it 'has 2 lines, a postal code, a country, a state, a territory, and a city' do
      @me.should respond_to(:line1)
      @me.should respond_to(:line2)
      @me.should respond_to(:postal_code)
      @me.should respond_to(:country)
      @me.should respond_to(:state)
      @me.should respond_to(:territory)
      @me.should respond_to(:city=)
      @me.should respond_to(:line1=)
      @me.should respond_to(:line2=)
      @me.should respond_to(:postal_code=)
      @me.should respond_to(:country=)
      @me.should respond_to(:state=)
      @me.should respond_to(:territory=)
      @me.should respond_to(:city=)
    end
  end
end
