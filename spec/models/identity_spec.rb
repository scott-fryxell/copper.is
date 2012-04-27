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
        twitter_user = OpenStruct.new(uid:'123',username:'dude')
        Twitter.stub(:user).and_return(twitter_user)
      end

      it 'has a method to inform a non-user of an earned royalty check' do
        @identity.respond_to?(:inform_non_user_of_promised_tips)
      end

      it 'has a factory creation method based on passsed in provider' do
        Identity.factory provider:provider, uid:FactoryGirl.generate(:uid)
      end


      it 'has a method that populates uid or username depending on what\'s missing' do
        proc{ @identity.populate_uid_and_username! }.should_not raise_error
      end
      
      it 'has a method that populates uid given a username' do
        proc{ @identity.populate_uid_from_username! }.should_not raise_error
      end
      
      it 'has a method that populates username given a uid' do
        proc{ @identity.populate_username_from_uid! }.should_not raise_error
      end

      describe 'with a page and some tips' do
        before do
          @identity = FactoryGirl.create factory
          @identity_id = @identity.id
          @fan = FactoryGirl.create(:user)
          @page = FactoryGirl.create(:page,url:"http://example.com/dudeham",author_state:'adopted')
          @page.identity = @identity
          @page.save!
          @tip_order = FactoryGirl.create(:tip_order_paid,user:@fan)
          @tip_order.paid?.should be_true
          tip = @tip_order.tips.build
          tip.assign_attributes({page:@page,amount_in_cents:50,paid_state:'charged'},without_protection:true)
          @tip_order.save!
        end
        
        it 'can find all :charged tips for an identity' do
          @identity.tips.charged.count.should == 1
        end
        
        #   describe '#try_to_create_check!' do
        #     it 'responds' do
        #       @identity.respond_to?(:try_to_create_check!).should be_true
        #     end
        
        #     it 'returns a Check object' do
        #       @identity.try_to_create_check!.class.should == Check
        #     end
        
        #     describe 'the returned royalty check' do
        #       before do
        #         @check = @identity.try_to_create_check!
        #         @identity = Identity.find(@identity_id)
        #       end
        
        #       it 'has 4 tips' do
        #         @check.tips.count.should == 1
        #       end
        
        #       it 'is in the :earned state' do
        #         @check.earned?.should be_true
        #       end

        #       it 'is saved to @identity' do
        #         @identity.checks.earned.first.id.should == @check.id
        #       end
        #     end
        #   end
      end
      
      describe "state machine" do
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
end
