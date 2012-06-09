require 'spec_helper'

describe 'Fantasy API', :pending do
  before do
    DatabaseCleaner.clean
  end
  
  describe User do
    before do
      @user = User.create!
    end
    
    after do
      @user.save!
      @user.reload
      @user.should be_valid
    end
     
    describe AuthSource do
      it 'user has #auth_sources' do
        @user.auth_sources.should be_empty
      end
      
      it '#auth_sources can add_facebook' do
        @user.auth_sources.create!(facebook:'mgarriss')
      end
      
      it '#auth_sources can add google!' do
        @user.auth_sources.create!(google:'mgarriss@gmail.com')
      end
      
      describe 'add_twitter!' do
        it 'is method on auth_sources relation' do
          @user.auth_sources.add_twitter!(username:'_ugly')
        end
        
        it 'steals auth from another user if it exists' do
          twitter = @user.auth_sources.create!(twitter:'_ugly')
          @new_user = User.create!
          twitter.reload
          @new_user.create!(twitter:'_ugly').should eq(twitter)
          @user.auth_sources.should be_empty
          @new_user.auth_sources.size.should eq(1)
        end
      end
      
      it 'a user can had many auth sources of same type' do
        @user.auth_sources.create!(twitter:'_ugly')
        @user.auth_sources.create!(twitter:'dude')
      end
    end
    
    it 'a user can exist without an auth_source, aka an author' do
      # before and after check this
    end
    
    describe MessageChannel do
      it 'a user has message_channels' do
        @user.message_channels.should be_empty
      end
      
      it 'emails is not a field on user, it\'s a has_many relationship' do
        @user.message_channels.create!(username:'mgarriss@gmail.com')
      end
      
      it 'adds a twitter message channel when a twitter auth_source is added' do
        @user.message_channels.size.should eq(0)
        @user.auth_sources.create!(twitter:'_ugly')
        @user.message_channels.size.should eq(1)
      end
      
      it 'the relation has methods that get called on best choice' do
        obj = @user.message_channels.send_message(:you_have_tips_waiting!)
        obj.class.should eq(Message)
      end
      
      it 'there is a helper right on user that picks best message channel' do
        @user.you_have_tips_waiting!
      end
      
      it 'there is a plural scope for each message channel type' do
        channel = @user.message_channels.create!(email:'mgarriss@gmail.com')
        channel.reload
        @user.reload
        @user.emails.first eq(channel)
      end
      
      it 'there is a singular scope that makes best pick' do
        channel = @user.message_channels.create!(email:'mgarriss@gmail.com')
        channel.reload
        @user.reload
        @user.email eq(channel)
      end
      
      it 'has_many messages' do
        @user.message_channels.create!(email:'mgarriss@gmail.com')
        @user.email.you_have_tips_waiting!
        @user.email.messages.size.should eq(1)
      end
    end
  end
end
