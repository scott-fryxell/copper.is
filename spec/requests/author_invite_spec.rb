require File.dirname(__FILE__) + '/../spec_helper'

describe "a author being invited to the service" do
  
  it 'should be able to authorize with the service', :focus do
    twitter = FactoryGirl.create(:identities_twitter,identity_state: :wanted)
    visit"/identities/#{twitter.id}/edit"
    page.should have_css('#banner', visible:true)
  end
  it 'should return to the invite after authorization'
  it 'should validate the email address'
  it 'should validate the address'
  it 'should take Author to their profile page after submit'
end
