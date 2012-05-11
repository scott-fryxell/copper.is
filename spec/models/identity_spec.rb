require 'spec_helper'

describe Identity do
  [
    :identities_twitter,
    :identities_phony,
    #:identities_facebook,
    #:identities_google,
    #:identities_youtube,
    #:identities_tumblr,
    #:identities_vimeo,
    #:identities_flickr,
    #:identities_github,
    #:identities_soundcloud
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
    
    describe 'tipping a stranger', :broken do
      before do
        Stripe::Customer.stub(:create) { OpenStruct.new(id:1) }
        @me.create_stripe_customer(1)
        @me.save!
        
        # create an author with 3 pages
        @stranger = FactoryGirl.create(factory)
      end

      it 'is a stranger because tip is not charged' do
        @author.stranger?.should be_true
      end

      describe 'with charged tips' do
        before do
          @order_id = @me.current_order.id
          @fan.current_order.rotate!
          Order.find(@order_id).charge!
        end

        it 'a new current order is created after the old one is charged' do
          @fan.current_order.id.should_not == @order_id 
        end
        
        describe 'after wanted' do
          before do
            @author.try_to_make_wanted!
            @author.reload
          end
          
          it 'is wanted because tip is charged' do
            @author.wanted?.should be_true
          end
          
          it 'has been messaged' do
            @author.message.should_not be_nil
          end
        end
      end
    end
  end
end
