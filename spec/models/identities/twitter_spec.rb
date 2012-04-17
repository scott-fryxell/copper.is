require 'spec_helper'

describe Identities::Twitter do
  before do
    @identity = FactoryGirl.create(:identities_twitter, username:"dude_ham")
  end
  
  it "has a method to send a tweet" do
    @identity.respond_to?(:send_tweet).should be_true
  end
  
  it "updates tweets to the copper @username about their tip" do
    Twitter.stub(:update).with("@#{@identity.username} has some tips at copper.is/author")
    @identity.send_tweet("has some tips at copper.is/author")
  end
  
  it "should send a non copper user a tweet that they have royalties" do
    Twitter.stub(:update).with("@#{@identity.username} Somebody loves you. You have money waiting for you go to copper.is/p/7657658675 to see")
    @identity.inform_non_user_of_promised_tips
  end
  
  it "should not send a copper user a tweet that tweet trying to get them to use the service" do
    @identity.user = FactoryGirl.create(:user)
    Twitter.should_not_receive(:update)
    @identity.inform_non_user_of_promised_tips
  end

end
