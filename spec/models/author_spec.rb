require 'spec_helper'

describe Author, :type => :model do
  before do
    mock_page_and_user
    @user = User.create!
  end

  after do
    @user.save!
    @user.reload
    expect(@user).to be_valid
  end

  it 'user has #authors' do
    expect(@user.authors).to be_empty
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
      expect(@user.authors).to be_empty
      expect(@new_user.authors.size).to eq(1)
    end
  end

  it 'a user can add many authors of same type' do
    @user.authors.create!(provider:'twitter', username:'_ugly')
    @user.authors.create!(provider:'twitter', username:'dude')
  end

  describe "Root level url's" do

    it "shouldn't try to find an author for tumblr.com" do
      expect(Author.authorizer_from_url("http://www.tumblr.com/")).to be_falsey
    end

    it "shouldn't try to find an author for google.com" do
      expect(Author.authorizer_from_url("http://google.com/")).to be_falsey
    end

    it "shouldn't try to find an author for github.com" do
      expect(Author.authorizer_from_url("http://github.com/")).to be_falsey
    end

    it "shouldn't try to find an author for youtube.com" do
      expect(Author.authorizer_from_url("http://youtube.com/")).to be_falsey
    end

    it "shouldn't try to find an author for vimeo.com" do
      expect(Author.authorizer_from_url("http://vimeo.com/")).to be_falsey
    end

    it "shouldn't try to find an author for soundcloud.com" do
      expect(Author.authorizer_from_url("http://soundcloud.com/")).to be_falsey
    end

    it "shouldn't try to find an author for flickr.com" do
      expect(Author.authorizer_from_url("http://flickr.com/")).to be_falsey
    end

    it "shouldn't try to find an author for twitter.com" do
      expect(Author.authorizer_from_url("http://twitter.com/")).to be_falsey
    end

    it "shouldn't try to find an author for plus.google.com" do
      expect(Author.authorizer_from_url("http://plus.google.com/")).to be_falsey
    end
  end

  describe "url's that shouldn't result in authors being created" do
    it "https://soundcloud.com/dashboard" do
      expect(Author.authorizer_from_url("https://soundcloud.com/dashboard")).to be_falsey
    end

    it "https://www.facebook.com/apps/application.php?id=265853386838821" do
      expect(Author.authorizer_from_url("https://www.facebook.com/apps/application.php?id=265853386838821")).to be_falsey
    end

    it "http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/" do
      expect(Author.authorizer_from_url("http://www.tumblr.com/customize?redirect_to=http://brokenbydawn.tumblr.com/")).to be_falsey
    end

    it "http://www.tumblr.com/share" do
      expect(Author.authorizer_from_url("http://www.tumblr.com/share")).to be_falsey
    end

    it "http://code.flickr.net/2008/10/27/counting-timing/" do
      expect(Author.authorizer_from_url("http://code.flickr.net/2008/10/27/counting-timing/")).to be_falsey
    end

    it "https://gist.github.com/1367918" do
      expect(Author.authorizer_from_url("https://gist.github.com/1367918")).to be_falsey
    end

    it "https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo" do
      expect(Author.authorizer_from_url("https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo")).to be_falsey
    end

    it "http://vimeo.com/groups/waza2012/videos/49720072" do
      expect(Author.authorizer_from_url("http://vimeo.com/groups/waza2012/videos/49720072")).to be_falsey
    end
  end
end
