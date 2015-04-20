require 'spec_helper'

describe Author do
  before do
    mock_page_and_user
    @user = User.create!
  end

  after do
    @user.save!
    @user.reload
    @user.should be_valid
  end

  it 'user has #authors' do
    @user.authors.should be_empty
  end

  it '#authors can add_facebook' do
    @user.authors.create!(provider:'facebook', username:'scott.fryxell')
  end

  it '#authors can add google!' do
    @user.authors.create!(provider:'google', username:'mgarriss@gmail.com')
  end

  describe 'add_twitter!' do
    it 'is method on authors relation' do
      @user.authors.create!(provider:'twitter', username:'_ugly')
    end

    it 'steals auth from another user if it exists' do
      twitter = @user.authors.create!(provider:'twitter', username:'_ugly')
      @new_user = create!(:user)
      twitter.user = @new_user
      twitter.join!
      @new_user.reload
      @user.reload
      @user.authors.should be_empty
      @new_user.authors.size.should == 1
    end
  end

  it 'a user can add many authors of same type' do
    @user.authors.create!(provider:'twitter', username:'_ugly')
    @user.authors.create!(provider:'twitter', username:'dude')
  end

  describe "Root level url's" do

    it "shouldn't try to find an author for tumblr.com" do
      Author.provider_from_url("http://www.tumblr.com/").should be_false
    end

    it "shouldn't try to find an author for google.com" do
      Author.provider_from_url("http://google.com/").should be_false
    end

    it "shouldn't try to find an author for github.com" do
      Author.provider_from_url("http://github.com/").should be_false
    end

    it "shouldn't try to find an author for youtube.com" do
      Author.provider_from_url("http://youtube.com/").should be_false
    end

    it "shouldn't try to find an author for vimeo.com" do
      Author.provider_from_url("http://vimeo.com/").should be_false
    end

    it "shouldn't try to find an author for soundcloud.com" do
      Author.provider_from_url("http://soundcloud.com/").should be_false
    end

    it "shouldn't try to find an author for flickr.com" do
      Author.provider_from_url("http://flickr.com/").should be_false
    end

    it "shouldn't try to find an author for twitter.com" do
      Author.provider_from_url("http://twitter.com/").should
    end

    it "shouldn't try to find an author for plus.google.com" do
      Author.provider_from_url("http://plus.google.com/").should be_false
    end
  end

  describe "url's that shouldn't result in authors being created" do
    it "https://soundcloud.com/dashboard" do
      Author.provider_from_url("https://soundcloud.com/dashboard").should be_false
    end

    it "https://www.facebook.com/apps/application.php?id=265853386838821" do
      Author.provider_from_url("https://www.facebook.com/apps/application.php?id=265853386838821").should be_false
    end

    it "http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/" do
      Author.provider_from_url("http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/").should be_false
    end

    it "http://code.flickr.net/2008/10/27/counting-timing/" do
      Author.provider_from_url("http://code.flickr.net/2008/10/27/counting-timing/").should be_false
    end

    it "https://gist.github.com/1367918" do
      Author.provider_from_url("https://gist.github.com/1367918").should be_false
    end

    it "https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo" do
      Author.provider_from_url("https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo").should be_false
    end

    it "http://vimeo.com/groups/waza2012/videos/49720072" do
      Author.provider_from_url("http://vimeo.com/groups/waza2012/videos/49720072").should be_false
    end
  end
end