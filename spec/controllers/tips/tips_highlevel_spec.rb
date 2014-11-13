require 'spec_helper'

describe TipsController, :type => :controller do
  describe 'high level'do
    before :each do
      mock_user
      @me = create!(:user)
      allow_any_instance_of(Author).to receive(:_send_wanted_message)
      allow_any_instance_of(Page).to receive(:learn)
      @twitter_user = double('user', id:666, username:'ableton')
      allow(::Twitter).to receive(:user).and_return(@twitter_user)
    end

    it 'tips pages', :vcr do
      expect do
        post_with @me, :create, tip:{url:'http://twitter.com/ableton'}
        @page = Page.find_by(url:'http://twitter.com/ableton')
        expect(@page.tips.size).to eq(1)
        @me.reload
        expect(@me.current_order.tips.first.page).to eq(@page)
      end.to change(Tip,:count).by(1)
    end

    it 'finds authors of tipped pages' do
      post_with @me, :create, tip:{url:'https://twitter.com/ableton'}
      @page = Page.find_by(url:'https://twitter.com/ableton')

      expect(Page).to have_queued(@page.id, :discover_author!).once
      expect(Page).to have_queued(@page.id, :learn).once

    end

    it 'messages wanted authors', :vcr do
      post_with @me, :create, tip:{url:'http://twitter.com/ableton'}
      @me.current_order.tips.first.destroy
      @page = Page.find_by(url:'http://twitter.com/ableton')
    end

    it 'assign tips to known authors' do
      @her_author = create!(:author_phony)
      post_with @me, :create, tip:{url:"http://example.com/#{@her_author.username}"}
      @page = Page.find_by(url:"http://example.com/#{@her_author.username}")
      @page.discover_author!
      expect(@page.author).to eq(@her_author)
    end
  end
end
