require 'spec_helper'

describe Page do
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
      @page.site.class.should eq(Sites::Phony)
    end

  end
  
  describe 'sites' do
    before do
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
      @page.path.should eq('dude')
    end
  end

  it 'finds the phony author with a dude@test.com email channel' do
    @page.author.primary_channel.address.should eq('dude@test.com')
    @page.author.primary_channel.class.should eq(Channels::Email)
  end
end
