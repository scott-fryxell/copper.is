require 'spec_helper'

describe Channel do
  it 'there is a Channels::Phone' do
    Channels::Phone.superclass.should eq(Channel)
  end
  
  it 'there is a Channels::Email' do
    Channels::Email.superclass.should eq(Channel)
  end
end
