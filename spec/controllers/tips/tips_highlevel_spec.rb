require 'spec_helper'

describe TipsController do
  describe 'high level' do
    before :each do
      mock_user
      @me = create!(:user)
      Author.any_instance.stub(:_send_wanted_message)
    end

    it 'tips pages', :vcr do
      proc do
        post_with @me, :create, tip:{url:'http://twitter.com/ableton'}
        @page = Page.find_by_url('http://twitter.com/ableton')
        @page.tips.size.should eq(1)
        @me.reload
        @me.current_order.tips.first.page.should eq(@page)
      end.should change(Tip,:count).by(1)
    end

    it 'finds authors of tipped pages', :vcr do
      post_with @me, :create, tip:{url:'https://twitter.com/ableton'}
      @page = Page.find_by_url('https://twitter.com/ableton')
      @page.author.should_not be_nil
      @page.author.username.should eq('ableton')
    end

    it 'messages wanted authors', :vcr do
      post_with @me, :create, tip:{url:'http://twitter.com/ableton'}
      @me.current_order.tips.first.destroy
      @page = Page.find_by_url('http://twitter.com/ableton')
    end

    it 'assign tips to known authors' do
      Page.any_instance.stub(:learn)
      @her_author = create!(:author_phony)
      post_with @me, :create, tip:{url:"http://example.com/#{@her_author.username}"}
      @page = Page.find_by_url("http://example.com/#{@her_author.username}")
      @page.author.should eq(@her_author)
    end
  end
end
