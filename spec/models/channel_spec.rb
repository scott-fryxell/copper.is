require 'spec_helper'

include Channels

describe Channel do
  it 'there is a Channels::Phone' do
    Phone.superclass.should eq(Channel)
  end
  
  describe Channels::Email do
    it 'there is a Channels::Email' do
      Email.superclass.should eq(Channel)
    end
    
    it 'save on Channel creates an Email when address matches an email address' do
      channel = Channel.new(address:'me@test.com')
      channel.save!
      Channel.find(channel.id).class.should eq(Email)
    end
    
    it 'create on Channel creates an Email when address matches an email address' do
      channel = Channel.create!(address:'me@test.com')
      Channel.find(channel.id).class.should eq(Email)
    end
    
    it 'create on Channel creates an Email when address matches an email address' do
      channel = Channel.create!(address:'me@test.com')
      Channel.find(channel.id).class.should eq(Email)
    end
    
    it 'a save on Phone with an email address forces a Phone' do
      phone = Phone.create!(address:'me@test.com')
      Channel.find(phone.id).type.should eq('Channels::Phone')
    end
  end
  
  describe Channels::Phone do
    it 'there is a Channels::Email' do
      Email.superclass.should eq(Channel)
    end
    
    it 'save on Channel creates an Phone when address matches a phone number' do
      channel = Channel.create!(address:'415-234-0394')
      Channel.find(channel.id).type.should eq('Channels::Phone')
    end
    
    it 'Phone matches with no dashes' do
      channel = Channel.create!(address:'4152340394')
      Channel.find(channel.id).class.should eq(Phone)
    end
    
    it 'Phone matches with ()s' do
      channel = Channel.create!(address:'(415)2340394')
      Channel.find(channel.id).class.should eq(Phone)
    end
    
    it 'Phone matches with periods' do
      channel = Channel.create!(address:'415.234.0394')
      Channel.find(channel.id).class.should eq(Phone)
    end
  end
end
