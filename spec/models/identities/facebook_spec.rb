require 'spec_helper'

describe Identities::Facebook do
  before do
    @identity = FactoryGirl.create(:identities_facebook, username:"mgarriss")
  end
  
  it "has a method to send an email" do
    @identity.respond_to?(:send_email).should be_true
  end
  
  it "should send a non copper user an email that they have royalties" # do
  #  Twitter.stub(:update).with("@#{@identity.username} Somebody loves you. You have money waiting for you go to copper.is/p/7657658675 to see")
  #  @identity.inform_non_user_of_promised_tips
  # end
  
  it "should not send a copper user an email that we're trying to get them to use the service" # do
  #  @identity.user = FactoryGirl.create(:user)
  #   Twitter.should_not_receive(:update)
  #   @identity.inform_non_user_of_promised_tips
  # end


  describe '#populate_uid_and_username!' do
    before do
    end
    
    after do
      @identity.save.should be_true
      @identity.populate_uid_and_username!
      @identity.username.should == 'mgarriss'
      @identity.uid.should == '597463246'
    end
    
    it 'finds the uid if usenname is set' # do
     #      @identity.uid = nil
     #      @identity.username = 'mgarriss'
     #    end
    
    it 'finds the username if uid is set' # do
     #      @identity.uid = '597463246'
     #      @identity.username = nil
     #    end
  end
  
end
