require 'spec_helper'

describe Identity do
  [
    :identities_twitter,
    :identities_facebook,
    :identities_google,
    :identities_youtube,
    :identities_tumblr,
    :identities_vimeo,
    :identities_flickr,
    :identities_github,
    :identities_soundcloud
  ].each do |factory|
    provider = factory.to_s.sub(/identities_/,'')

    describe provider do
      before do
        @identity = FactoryGirl.create factory
      end
      
      it "transitions from :stranger to :wanted on a publicize! event" do
        @identity.stranger?.should be_true
        @identity.publicize!
        @identity.wanted?.should be_true
      end

      it "transitions from :stranger to :known on a join! event" do
        @identity.stranger?.should be_true
        @identity.user_id = 1
        @identity.join!
        @identity.known?.should be_true
      end
      
      it "transitions from :wanted to :known on a join! event" do
        @identity = FactoryGirl.create(factory, identity_state:'wanted')
        @identity.wanted?.should be_true
        @identity.user_id = 1
        @identity.join!
        @identity.known?.should be_true
      end
      
      it "does not transition from :wanted on a publicize! event" do
        @identity = FactoryGirl.create(factory, identity_state:'wanted')
        @identity.wanted?.should be_true
        proc { @identity.publicize! }.should raise_error(StateMachine::InvalidTransition)
      end
    end
  end
end
