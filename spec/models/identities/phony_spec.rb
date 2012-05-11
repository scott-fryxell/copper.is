require 'spec_helper'

describe Identities::Phony do
  before do
    @identity = FactoryGirl.create(:identities_phony)
  end

  describe '#populate_uid_and_username!' do
    it 'finds the uid if username is set' do
      @identity.uid = nil
      @identity.username = '1'
    end

    it 'finds the username if uid is set' do
      @identity.uid = '1'
      @identity.username = nil
    end

    after do
      @identity.save.should be_true
      @identity.reload
      @identity.populate_uid_and_username!
      @identity.username.should == '1'
      @identity.uid.should == '1'
    end
  end
end
