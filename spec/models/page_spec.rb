require 'spec_helper'

describe Page do
  before do
    DatabaseCleaner.clean
  end
  
  describe 'without resque' do
    before do
      @page = Page.create! url:'http://test.com/dude'
    end
    
    it 'creates a site on demand' do
      @page.site.should be_valid
    end
    
    it 'causes a #find_author! job to enqueue' do
      Page.should have_queued(@page.id, :find_author!)
    end
  end
  
  describe 'with resque' do
    before :all do
      with_resque do
        @page = Page.create! url:'http://test.com/dude'
      end
    end
    
    it 'finds an author' do
      @page.author.should be_valid
    end
  end
end
