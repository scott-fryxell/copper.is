require 'spec_helper'

describe Identities::Twitter do
  before do
    @identity = FactoryGirl.create(:identities_twitter)
  end
  
  it "has a method to send a tweet" do
    @identity.respond_to?(:send_tweet).should be_true
  end
end
