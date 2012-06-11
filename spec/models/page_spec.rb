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
        @page = Page.create! url:'http://test.com/dude'
      end
    end
    
    it 'finds an author' do pending
      @page.author.should_not be_nil
    end
  end
end
