require 'spec_helper'

describe Page, :broken do
  context do
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
      
      it "finds user on twitter.com" do
        @page.url = "https://twitter.com/#!/ChloesThinking"
      end
      
      context '' do
        it "finds user on flickr.com" do
          @page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
        end
        
        it "finds user on youtube.com" do
          @page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
        end
        
        it "finds user on vimeo.com" do
          @page.url = "http://vimeo.com/31453929"
        end
        
        it "finds user on soundcloud.com" do
          @page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
        end
        
        it "finds user on github.com" do
          @page.url = "https://github.com/mgarriss/Echo-Chamber"
        end
        
        it "finds user on google.com" do
          @page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
        end
        
        it "finds user on tumblr.com" do
          @page.url = "http://staff.tumblr.com/"
        end
      end
    end
    
    describe "transitions from :orphaned to :adopted if from a spiderable page" do
      it 'spiders a spiderable page' do
        @page.url = 'http://prettypennyrecords.com/woodsboro/pocket_comb'
      end
    end
  end
  
  describe "transitions from :orphaned to :manual", :broken do
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
    
    it 'for a site that can\'t be reached' do pending
      @page.url = "http://test.com/"
    end
  end
end
