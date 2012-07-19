require 'spec_helper'

describe Identity, :broken do
  before do
    DatabaseCleaner.clean
    @user = User.create!
  end

  after do
    @user.save!
    @user.reload
    @user.should be_valid
  end

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

  it 'a user can exist without an auth_source, aka an author' do
    # before and after check this
  end
end
