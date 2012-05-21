require 'spec_helper'

describe User do
  describe 'identities' do
    describe 'at least one', :broken do
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
end
