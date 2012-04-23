require 'spec_helper'

describe Identities::Twitter do
  before do
    @identity = FactoryGirl.create(:identities_twitter, username:"_ugly")
  end

  it "should send a non copper user a tweet that they have royalties" do
    Twitter.stub(:update).with("@#{@identity.username} Somebody loves you. You have money waiting for you go to copper.is/p/7657658675 to see")
    @identity.message_wanted!
  end

  it "should not send a copper user a tweet trying to get them to use the service" do
    @identity.user = FactoryGirl.create(:user)
    Twitter.should_not_receive(:update)
    proc { @identity.message_wanted! }.should raise_error
  end

  describe '#populate_uid_and_username!' do
    before do
    end

    it 'finds the uid if usenname is set' do
       @identity.uid = nil
       @identity.username = '_ugly'
    end

    it 'finds the username if uid is set' do
      @identity.uid = '26368397'
      @identity.username = nil
    end

    after do
      @identity.save.should be_true
      @identity.populate_uid_and_username!
      @identity.username.should == '_ugly'
      @identity.uid.should == '26368397'
    end
  end

end
