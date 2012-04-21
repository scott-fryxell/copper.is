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
    end
  end
end
