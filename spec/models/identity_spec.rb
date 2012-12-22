require 'spec_helper'

describe Identity do
  before do
    @user = User.create!
  end

  after do
    @user.save!
    @user.reload
    @user.should be_valid
  end

  it 'user has #identities' do
    @user.identities.should be_empty
  end

  it '#identities can add_facebook' do
    @user.identities.create!(provider:'facebook', username:'mgarriss')
  end

  it '#identities can add google!' do
    @user.identities.create!(provider:'google', username:'mgarriss@gmail.com')
  end

  describe 'add_twitter!' do
    it 'is method on identities relation' do
      @user.identities.create!(provider:'twitter', username:'_ugly')
    end

    it 'steals auth from another user if it exists' do pending
      twitter = @user.identities.create!(provider:'twitter', username:'_ugly')
      @new_user = User.create!
      twitter.reload
      @new_user.identities.create!(provider:'twitter', username:'_ugly').should eq(twitter)
      @user.identities.should be_empty
      @new_user.identities.size.should eq(1)
    end
  end

  it 'a user can add many identities of same type' do
    @user.identities.create!(provider:'twitter', username:'_ugly')
    @user.identities.create!(provider:'twitter', username:'dude')
  end

  it 'a user can exist without an identity, aka an author'

  it 'only messages an identity that doesn\'t have an author associated with it'

end
