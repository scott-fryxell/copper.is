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
    before do
      @identity = FactoryGirl.create factory
    end
    
    it 'has a method to inform a non-user of an earned royalty check' do
      @identity.respond_to?(:inform_non_user_of_promised_tips)
    end

    it 'has a factory creation method based on passsed in provider' do
      Identity.factory provider:factory.to_s.sub(/identities_/,''), uid:FactoryGirl.generate(:uid)
    end
  end
  
end
