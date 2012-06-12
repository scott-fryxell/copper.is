require 'spec_helper'

describe Channel do
  before do
    DatabaseCleaner.clean
    @user = User.create!
  end
  
  after do
    @user.save!
    @user.reload
    @user.should be_valid
  end
  
  it 'a user has message_channels' do
    @user.channels.should be_empty
  end
  
  it 'emails is not a field on user, it\'s a has_many relationship' do
    @user.channels.create!(username:'mgarriss@gmail.com')
  end
  
  it 'adds a twitter message channel when a twitter auth_source is added' do
    @user.channels.size.should eq(0)
    @user.auth_sources.create!(twitter:'_ugly')
    @user.channels.size.should eq(1)
  end
  
  it 'the relation has methods that get called on best choice' do
    obj = @user.channels.send_message(:you_have_tips_waiting!)
    obj.class.should eq(Message)
  end
  
  it 'there is a helper right on user that picks best message channel' do
    @user.you_have_tips_waiting!
  end
  
  it 'there is a plural scope for each message channel type' do
    channel = @user.channels.create!(email:'mgarriss@gmail.com')
    channel.reload
    @user.reload
    @user.emails.first eq(channel)
  end
  
  it 'there is a singular scope that makes best pick' do
    channel = @user.channels.create!(email:'mgarriss@gmail.com')
    channel.reload
    @user.reload
    @user.email eq(channel)
  end
  
  it 'has_many messages' do
    @user.channels.create!(email:'mgarriss@gmail.com')
    @user.email.you_have_tips_waiting!
    @user.email.messages.size.should eq(1)
  end
end