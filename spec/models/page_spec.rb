require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  context do
    before(:each) do
      @page = Page.new
      @page.url = 'http://example.com/path1'
    end

    it "should save with a valid url" do
      @page.save.should be_true
    end

    it "should have a title" do
      @page.title = 'this is a page'
      @page.save.should be_true
      Page.find(@page.id).title.should == 'this is a page'
    end

    it "should not save with an invalid url" do
      @page.url = '666'
      @page.save.should be_false
    end

    it "should allow tips to be added" do
      @page.save!
      tip = @page.tips.build
      tip.amount_in_cents = 50
      order = tip.build_order
      order.user = FactoryGirl.create(:user)
      tip.save!
      Page.find(@page.id).tips.first.id.should == tip.id
    end
  end
  
  describe 'scopes' do
    before do
      [:orphaned, :spiderable, :manual, :fostered, :adopted].each do |state|
        FactoryGirl.create :page, author_state:state
      end
    end

    [:orphaned, :spiderable, :manual, :fostered, :adopted].each do |state|
      it "has an .#{state} scope" do
        Page.send(state).count.should == 1
      end
    end
  end

  describe 'author state machine' do
    describe "happy path" do
      describe "tranistions from :orphaned to :adopted on adopted!" do
        before do
          @page = FactoryGirl.build(:page, url:'http://dude.com')
        end
        
        after do
          @page.save!
          Page.find(@page.id).adopted?.should be_true
        end
        
        it "finds user on facebook.com" do
          @page.url = "http://www.facebook.com/scott.fryxell"
        end
        
        it "finds user on flickr.com" #do
        #  @page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
        #end
        
        slow_test do
          it "finds user on twitter.com" do
            @page.url = "https://twitter.com/#!/ChloesThinking"
          end
        end
        
        it "finds user on youtube.com" #do
        #  @page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
        #end
        it "finds user on vimeo.com" #do
        #  @page.url = "http://vimeo.com/31453929"
        #end
        it "finds user on soundcloud.com" #do
        #  @page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
        #end
        it "finds user on github.com" #do
        #  @page.url = "https://github.com/mgarriss/Echo-Chamber"
        #end
        it "finds user on google.com" #do
        #  @page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
        #end
        it "finds user on tumblr.com" #do
        #  @page.url = "http://staff.tumblr.com/"
        #end
      end
    end

    describe "slightly less happy path" do
      it "tranistions from :orphaned to :spiderable on reject! when not matched"  do
        page = FactoryGirl.create(:page, url:'http://dude.com',author_state:'orphaned')
        page.orphaned?.should be_true
        page.discover_identity!
        page.spiderable?.should be_true
      end
      
      slow_test do
        it "transitions from :spiderable to :adopted when there is a link tag" do
          page = FactoryGirl.create(:page, url:'http://prettypennyrecords.com/woodsboro/pocket_comb', author_state:'spiderable')
          page.spiderable?.should be_true
          page.find_identity_from_author_link!
          page.identity.username.should == "brokenbydawn"
          page.adopted?.should be_true
        end
      end
    end
    describe "unhappy path" do
      it "transitions from :spiderable to :manual on a missing!" # do
       #        page = FactoryGirl.create(:page, url:'http://dude.com',author_state:'spiderable')
       #        page.spiderable?.should be_true
       #        page.find_provider_from_author_link!
       #        page.manual?.should be_true
       #      end
      it "transitions from :manual to :fostered on a lose!" do
        page = FactoryGirl.create(:page, url:'http://dude.com',author_state:'manual')
        page.manual?.should be_true
        page.reject!
        page.fostered?.should be_true
      end
      it "transitions from :manual to :adopted on a adopt!" do
        page = FactoryGirl.create(:page, url:'http://dude.com',author_state:'manual')
        page.manual?.should be_true
        page.identity = Identity.factory(uid:'dude',provider:'facebook')
        page.adopt!
        page.adopted?.should be_true
      end
    end
  end

  describe 'discovering facebook uid' do
    it 'finds the uid from a photo url' do
      page = FactoryGirl.create(:page,url:'http://www.facebook.com/photo.php?fbid=193861260731689&set=a.148253785292437.29102.148219955295820&type=1')
      page.discover_identity!
      page = Page.find(page.id)
      page.identity.uid.should == '148219955295820'
      page.identity.provider.should == 'facebook'
      page.adopted?.should be_true
    end
    it 'finds the uid from a photo url' do
      page = FactoryGirl.create(:page,url:'http://www.facebook.com/photo.php?fbid=3336195612943&set=t.580281278&type=3&theater')
      page.discover_identity!
      page = Page.find(page.id)
      page.identity.uid.should == '580281278'
      page.identity.provider.should == 'facebook'
      page.adopted?.should be_true
    end
    it 'finds the uid from a event url' do
      page = FactoryGirl.create(:page,url:'http://www.facebook.com/events/221709371259138/')
      page.discover_identity!
      page = Page.find(page.id)
      page.identity.uid.should == '601117415'
      page.identity.provider.should == 'facebook'
      page.adopted?.should be_true
    end
    it 'finds the uid from a profile page' do
      page = FactoryGirl.create(:page,url:'http://www.facebook.com/scott.fryxell')
      page.discover_identity!
      page = Page.find(page.id)
      page.identity.uid.should == '580281278'
      page.identity.provider.should == 'facebook'
      page.adopted?.should be_true
    end
    it "finds a uid that already exists in our system" do
      identity_id = FactoryGirl.create(:identities_facebook,uid:'580281278').id
      page = FactoryGirl.create(:page,url:'http://www.facebook.com/photo.php?fbid=303196899750980&set=t.580281278&type=3&theater')
      page.discover_identity!
      page = Page.find(page.id)
      page.identity.id.should == identity_id
      page.identity.provider.should == 'facebook'
      page.adopted?.should be_true
    end
  end

  slow_test do
    describe 'discovering twitter uid' do
      it 'finds a uid from a twitter status url' do
        page = FactoryGirl.create(:page,url:'https://twitter.com/#!/bleikamp/status/191682126138191873')
        page.discover_identity!
        page.identity.provider.should == 'twitter'
        page.adopted?.should be_true
        page2 = Page.find(page.id)
        page2.id.should == page.id

        page2.identity.uid.should == '14062332'
        page2.identity.provider.should == 'twitter'
      end
      it 'finds a uid from a twitter user page' do
        page = FactoryGirl.create(:page,url:'https://twitter.com/#!/bleikamp')
        page.discover_identity!
        page.adopted?.should be_true
        page.identity.uid.should == '14062332'
        page.identity.provider.should == 'twitter'
      end
    end
  end

  describe 'discovering youtube uid' do
    after do
      @page.discover_identity!
      @page.adopted?.should be_true
      page2 = Page.find(@page.id)
      page2.id.should == @page.id

      page2.identity.uid.should == 'sfryxell'
      page2.identity.provider.should == 'youtube'
    end
    
    it 'finds a uid from a youtube video' # do
     #      @page = FactoryGirl.create(:page,url:'http://www.youtube.com/watch?v=r4rd1i3Ar9k')
     #    end

    it 'finds a uid from a youtube profile page' # do
     #      @page = FactoryGirl.create(:page,url:'http://www.youtube.com/user/sfryxell')
     #    end
  end
end
