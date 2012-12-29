require 'spec_helper'

describe Page do
  describe "url" do
    before(:each) do
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
      @page.adopted?.should be_true
    end
    
    describe "from a provider service" do
      it "finds user on facebook.com" do
        @page.url = "http://www.facebook.com/scott.fryxell"
      end
      
      it "finds user on facebook.com via their photo" do
        @page.url = "https://www.facebook.com/photo.php?fbid=415648305162300&set=a.304808032912995.69593.286232048103927&type=1&theater"
      end

      it "finds user on facebook.com old style id" do
        @page.url = "www.facebook.com/profile.php?id=1340075098"
      end
      
      it "finds user on twitter.com" do
        @page.url = "https://twitter.com/ChloesThinking"
      end
      
      it "finds user on flickr.com" do
        @page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
      end
      
      it "finds user on youtube.com from a video url" do
        @page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
      end

      it "finds user on youtube.com from a user profile" do
        @page.url = 'http://www.youtube.com/user/machinima?ob=4'
      end

      it "finds user on youtube.com from a channel" do
        @page.url = 'http://www.youtube.com/pitchforktv'
      end
    
      it "finds user on vimeo.com" do
        @page.url = "http://vimeo.com/31453929"
      end
      
      it "finds user on soundcloud.com" do
        @page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
      end
      
      it "finds user on github.com" do
        @page.url = "https://github.com/rails/commands"
      end
      
      it "finds user on plus.google.com" do
        @page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
      end
      
      it "finds user on tumblr.com" do
        @page.url = "http://staff.tumblr.com/"
      end
    end
    
    describe "transitions from :orphaned to :adopted if from a page that's fostered" do
      it 'spiders a fostered page' do
        @page.url = 'http://prettypennyrecords.com/woodsboro/pocket_comb'
      end
    end
  end

  describe "shouldn't try to find an identity for root level pages " do
    before do
      @page = FactoryGirl.build(:page)
    end

    it "shouldn't try to find an identity for tumblr.com" do
      @page.url = "http://tumblr.com/"
    end
    
    it "shouldn't try to find an identity for google.com" do
      @page.url = "http://google.com/"
    end

    it "shouldn't try to find an identity for github.com" do
      @page.url = "http://github.com/"
    end

    it "shouldn't try to find an identity for youtube.com" do
      @page.url = "http://youtube.com/"
    end

    it "shouldn't try to find an identity for vimeo.com" do
      @page.url = "http://vimeo.com/"
    end

    it "shouldn't try to find an identity for soundcloud.com" do
      @page.url = "http://soundcloud.com/"
    end

    it "shouldn't try to find an identity for flickr.com" do
      @page.url = "http://flickr.com/"
    end

    it "shouldn't try to find an identity for twitter.com" do
      @page.url = "http://twitter.com/"
    end

    it "shouldn't try to find an identity for twitter.com" do
      @page.url = "http://twitter.com/"
    end


    it "shouldn't try to find an identity for facebook.com/home.php" do
      @page.url = "https://www.facebook.com/home.php"
    end

    it "shouldn't try to find an identity for plus.google.com" do
      @page.url = "http://plus.google.com/"
    end

    after do
      @page.save!
      @page.reload
      @page.manual?.should be_true
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
    
    it 'http://ruby-doc.org/' do
      @page.url = "http://ruby-doc.org/"
    end
    
    it 'http://api.jquery.com' do
      @page.url = "http://api.jquery.com"
    end
  end
  
  describe "transitions from :orphaned to :fostered" do
    before do
      @page = FactoryGirl.build(:page)
    end
    
    after do
      @page.save!
      @page.reload
      @page.fostered?.should be_true
    end
    
    it 'for a site that can\'t be reached' do
      @page.url = "http://test.com/"
    end
  end
end
