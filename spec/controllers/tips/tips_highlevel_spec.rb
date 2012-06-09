require 'spec_helper'

describe TipsController,:pending do
  describe 'high level' do
    before :each do
      raise '@me not set' unless @me
      user = @me
      controller.instance_eval do
        cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
        @current_user = user
      end
      Identity.any_instance.stub(:_send_wanted_message)
    end
    
    after :each do
      @me.current_order.tips.first.destroy
      @page.identity.destroy
      @page.destroy
    end
    
    it 'tips pages' do
      proc do
        post :create, tip:{url:'http://twitter.com/#!/ableton'}
        @page = Page.find_by_url('http://twitter.com/#!/ableton')
        @page.tips.size.should eq(1)
        @me.reload
        @me.current_order.tips.first.page.should eq(@page)
      end.should change(Tip,:count).by(1)
    end
    
    it 'finds authors of tipped pages' do
      post :create, tip:{url:'http://twitter.com/#!/ableton'}
      @page = Page.find_by_url('http://twitter.com/#!/ableton')
      @page.identity.should_not be_nil
      @page.identity.username.should eq('ableton')
    end
    
    it 'messages wanted authors' do
      post :create, tip:{url:'http://twitter.com/#!/ableton'}
      @me.current_order.tips.first.destroy
      @page = Page.find_by_url('http://twitter.com/#!/ableton')
    end
    
    it 'pays known authors',:pending do
      post :create, tip:{url:"http://example.com/#{@her_identity.username}"}
      @page = Page.find_by_url("http://example.com/#{@her_identity.username}")
      @page.identity.should eq(@her_identity)
    end
  end
end
