require 'spec_helper'

describe Page do
  before do
    # DatabaseCleaner.clean
  end
  
  describe 'without resque' do
    before do
      @page = Page.create!(url:'http://test.com/dude')
    end
    
    it 'causes a #find_author! job to enqueue' do
      Page.should have_queued(@page.id, :find_author!)
    end
  end
  
  describe 'with resque' do
    before do
      with_resque do
        @page = Page.create!(url:'http://test.com/dude')
        @page.reload
      end
      @page.site.reload
    end
    
    it 'finds an author' do
      @page.author.should_not be_nil
    end
    
    it 'finds a site' do
      @page.site.should_not be_nil
    end
    
    it 'finds a site with the correct name' do
      @page.site.name.should eq('test.com')
    end
    
    it 'creates a site with the correct subclass' do
      @page.site.type.should eq('Sites::Phony')
    end
  end

  describe 'no subclass' do
    it "scrapes for 'follow me' links" do
      with_resque do
        @page = Page.create!(url:'http://crooked-hideout.blogspot.com/')
        @page.reload
      end
      @page.author.channels.map(&:class).should include(Channels::Github)
      @page.author.channels.map(&:class).should include(Channels::Twitter)
      @page.author.channels.map(&:class).should include(Channels::Soundcloud)
      # @page.author.channels.map(&:class).should include(Channels::Email)
    end
    
    it "scrapes for email addresses" do
      pending
      with_resque do
        @page = Page.create!(url:'https://rubygems.org/profiles/bmo')
      end
      @page.author.primary_channel.address.should eq('bmoran@onehub.com')
    end
    
    it 'sets page to manual if no channel can be found' do
      pending
      with_resque do
        @page = Page.create!(url:'http://www.chicagotribune.com/news/')
      end
      @page.manual?.should be_true
    end
  end
  
  describe 'sites' do
    before do
      DatabaseCleaner.clean
      with_resque do
        @site = Sites::Phony.create!(name:'test.com')
        @page = Page.create!(url:'http://test.com/dude')
        @page.reload
      end
    end
    
    it 'finds a site if it already exists' do
      @page.site.should eq(@site)
    end
    
    it 'sets path on Page' do
      @page.path.should eq('/dude')
    end

    it 'finds the phony author with a dude@test.com email channel' do
      @page.author.primary_channel.address.should eq('dude@test.com')
      @page.author.primary_channel.class.should eq(Channels::Email)
    end
  end
end
