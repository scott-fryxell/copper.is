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


  describe "Root level url's" do

    it "shouldn't try to find an identity for tumblr.com" do
      Identity.provider_from_url("http://www.tumblr.com/").should be_false
    end
    
    it "shouldn't try to find an identity for google.com" do
      Identity.provider_from_url("http://google.com/").should be_false
    end

    it "shouldn't try to find an identity for github.com" do
      Identity.provider_from_url("http://github.com/").should be_false
    end

    it "shouldn't try to find an identity for youtube.com" do
      Identity.provider_from_url("http://youtube.com/").should be_false
    end

    it "shouldn't try to find an identity for vimeo.com" do
      Identity.provider_from_url("http://vimeo.com/").should be_false
    end

    it "shouldn't try to find an identity for soundcloud.com" do
      Identity.provider_from_url("http://soundcloud.com/").should be_false
    end

    it "shouldn't try to find an identity for flickr.com" do
      Identity.provider_from_url("http://flickr.com/").should be_false
    end

    it "shouldn't try to find an identity for twitter.com" do
      Identity.provider_from_url("http://twitter.com/").should
    end

    it "shouldn't try to find an identity for plus.google.com" do
      Identity.provider_from_url("http://plus.google.com/").should be_false
    end
  end

  describe "url's that shouldn't result in identities being created" do
    it "https://soundcloud.com/dashboard" do
      Identity.provider_from_url("https://soundcloud.com/dashboard").should be_false
    end 

    it "http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/" do
      Identity.provider_from_url("http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/").should be_false
    end 

    it "http://code.flickr.net/2008/10/27/counting-timing/" do
      Identity.provider_from_url("http://code.flickr.net/2008/10/27/counting-timing/").should be_false
    end

    it "https://gist.github.com/1367918" do
      Identity.provider_from_url("https://gist.github.com/1367918").should be_false
    end 

    it "https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo" do
      Identity.provider_from_url("https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo").should be_false
    end 

    it "http://vimeo.com/groups/waza2012/videos/49720072" do
      Identity.provider_from_url("http://vimeo.com/groups/waza2012/videos/49720072").should be_false
    end
  end

end
