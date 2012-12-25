require 'spec_helper'
# http://plus.google.com/110547857076579322423/
describe Identities::Twitter do
  before do
    @identity = FactoryGirl.create(:identities_google, username:"_ugly")
    # http://plus.google.com/110547857076579322423/
  end

  describe '#populate_uid_and_username!' do
    it 'finds the uid if username is set' do
      @identity.uid = nil
      @identity.username = '_ugly'
    end

    it 'finds the username if uid is set' do
      @identity.uid = '26368397'
      @identity.username = nil
    end

    after do
      @identity.save.should be_true
      @identity.reload
      @identity.populate_uid_and_username!
      @identity.username.should == '_ugly'
      @identity.uid.should == '26368397'
    end
  end
end

