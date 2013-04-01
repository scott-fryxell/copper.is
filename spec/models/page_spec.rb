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
      it "finds user on facebook.com", :vcr do
        @page.url = "https://www.facebook.com/scott.fryxell"
      end
      
      it "finds user on facebook.com via their photo", :vcr do
        @page.url = "https://www.facebook.com/photo.php?fbid=559044474113512&set=t.580281278&type=3&theater"
      end
      
      it "finds user on facebook.com old style id", :vcr do
        @page.url = "https://www.facebook.com/profile.php?id=1340075098"
      end
      
      it "finds user on twitter.com", :vcr do
        @page.url = "https://twitter.com/ChloesThinking"
      end
      
      it "finds user on flickr.com", :vcr do
        @page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
      end
      
      it "finds user on youtube.com from a video url", :vcr do
        @page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
      end

      it "finds user on youtube.com from a user profile", :vcr do
        @page.url = 'http://www.youtube.com/user/machinima?ob=4'
      end

      it "finds user on youtube.com from a channel", :vcr do
        @page.url = 'http://www.youtube.com/pitchforktv'
      end

      it "finds user on youtube.com from a embed link", :vcr do
        @page.url = 'https://www.youtube.com/embed/DX0fX47rQMc'
      end

      it "finds user on vimeo.com", :vcr do
        @page.url = "http://vimeo.com/31453929"
      end
      
      it "finds user on soundcloud.com", :vcr do
        @page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
      end
      
      it "finds user on github.com", :vcr do
        @page.url = "https://github.com/rails/commands"
      end
      
      it "finds user on plus.google.com", :vcr do
        @page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
      end
      
      it "finds an author for facebook.com/home.php", :vcr do
        @page.url = "https://www.facebook.com/home.php"
      end

      it "finds user on tumblr.com", :vcr do
        @page.url = "http://staff.tumblr.com/"
      end

      it "finds author for https://www.copper.is", :vcr do
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
end
