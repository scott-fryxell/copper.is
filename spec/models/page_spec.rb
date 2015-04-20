 require 'spec_helper'

describe Page do
  describe "url" do
    before(:each) do
      mock_page
      @page = Page.new
      @page.url = 'http://example.com/path1'
    end

    it "should save with a valid url" do
      @page.save.should be_true
    end

    it "should not save with an invalid url" do
      @page.url = '666'
      @page.save.should be_false
    end
  end

  describe "transitions from :orphaned to :adopted" do
    before do
      @page = FactoryGirl.build(:page)
    end

    after do
      @page.save!
      @page.reload
      # puts @page.url
      @page.adopted?.should be_true
      Author.count.should == 1
    end

    describe "from a provider service" do
      it "finds author on facebook.com", :vcr do
        @page.url = "https://www.facebook.com/scott.fryxell"
      end

      it "finds author on facebook.com via their photo", :vcr do
        @page.url = "https://www.facebook.com/photo.php?fbid=559044474113512&set=t.580281278&type=3&theater"
      end

      it "finds author on facebook.com old style id", :vcr do
        @page.url = "https://www.facebook.com/profile.php?id=1340075098"
      end

      it "finds author on twitter.com", :vcr do
        @page.url = "https://twitter.com/ChloesThinking"
      end

      it "finds author on flickr.com", :vcr do
        @page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
      end

      it "finds author on youtube.com from a video url", :vcr do
        @page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
      end

      it "finds author on youtube.com from a user profile", :vcr do
        @page.url = 'http://www.youtube.com/user/machinima?ob=4'
      end

      it "finds author from a youtube.com channel", :vcr do
        @page.url = 'http://www.youtube.com/pitchforktv'
      end

      it "finds author from a youtube.com embed link", :vcr do
        @page.url = 'https://www.youtube.com/embed/DX0fX47rQMc'
      end

      it "finds author on vimeo.com", :vcr do
        @page.url = "http://vimeo.com/31453929"
      end

      it "finds author from a soundcloud.com set", :vcr do
        @page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
      end

      it "finds author from a github.com repo", :vcr do
        @page.url = "https://github.com/rails/commands"
      end

      it "finds author from plus.google.com", :vcr do
        @page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
      end

      it "finds author for facebook.com/home.php", :vcr do
        @page.url = "https://www.facebook.com/home.php"
      end

      it "finds author from a tumblr.com subdomain", :vcr do
        @page.url = "http://staff.tumblr.com/"
      end

      it "finds author for https://www.copper.is", :vcr, :broken do
        @page.url = "https://www.copper.is"
      end

      it "finds author for http://www.missionmission.org/", :vcr do
        @page.url = "http://www.missionmission.org/"
      end

    end

    describe "transitions from :orphaned to :adopted if from a page that's fostered", :vcr do
      it 'spiders a fostered page' do
        @page.url = 'http://prettypennyrecords.com/woodsboro/pocket_comb'
      end
    end
  end

  describe "transitions from :orphaned to :manual" do
    before do
      @page = FactoryGirl.build(:page)
    end

    after do
      @page.save!
      @page.reload
      @page.manual?.should be_true
    end

    it 'http://ruby-doc.org/', :vcr do
      @page.url = "http://ruby-doc.org/"
    end
  end

  describe "transitions from :orphaned to :manual" do
    before do
      @page = FactoryGirl.build(:page)
    end

    after do
      @page.save!
      @page.reload
      @page.manual?.should be_true
    end

    it 'for a site that can\'t be reached', :broken do
      @page.url = "http://test.com/"
    end
  end

  describe "can be displayed on different pages" do
    before(:each) do
      mock_page
      @page = Page.new
      @page.url = 'http://example.com/path1'
    end

    it "can be shown during the onboarding process" do
      @page.onboarding = true
      @page.save!
      @page.reload
      @page.onboarding?.should be_true
    end

    it "can be shown on the welcome page " do
      @page.welcome = true
      @page.save!
      @page.reload
      @page.welcome?.should be_true
    end

    it "can be shown on the trending content page " do
      @page.trending = true
      @page.save!
      @page.reload
      @page.trending?.should be_true
    end

    it "can be marked as not safe for work" do
      @page.nsfw = true
      @page.save!
      @page.reload
      @page.nsfw?.should be_true
    end
  end

end
