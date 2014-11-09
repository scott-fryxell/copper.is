 require 'spec_helper'

describe Page do
  describe "url" do
    before(:each) do
      mock_page
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
      puts " "
      @page = build!(:page)
    end

    after do
      @page.save!
      @page.reload
      @page.adopted?.should be_true
      Author.count.should == 1
      puts "      #{@page.url}"
    end

    describe "from a provider service" do
      it "finds author on facebook.com", :vcr do
        @page.url = "https://www.facebook.com/scott.fryxell"
      end

      it "finds author on facebook.com via their photo", :vcr do
        @page.url = "https://www.facebook.com/photo.php?fbid=559044474113512&set=t.580281278&type=3&theater"
      end

      it "finds author on facebook.com old style id", :vcr do
        @page.url = "https://www.facebook.com/profile.php?id=1340075098"
      end

      it "finds author on twitter.com", :vcr do
        ::Twitter.stub(:user).and_return(double('user',id:666, screen_name:'ChloesThinking'))
        Page.any_instance.stub(:learn)
        @page.url = "https://twitter.com/ChloesThinking"
      end

      it "finds author on flickr.com", :vcr do
        @page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
      end

      it "finds author on youtube.com from a video url", :vcr do
        @page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
        author = double('author',  uri:'http://www.youtube.com/user/BHVthe81st', author_name:'BHVthe81st' )
        Authors::Youtube.stub_chain(:connect_to_api, :video_by, :author).and_return(author)
        Page.any_instance.stub(:learn)
      end

      it "finds author on youtube.com from a user profile", :vcr do
        @page.url = 'http://www.youtube.com/user/machinima?ob=4'
      end

      it "finds author from a youtube.com channel", :vcr do
        @page.url = 'http://www.youtube.com/pitchforktv'
      end

      it "finds author from a youtube.com embed link", :vcr do
        @page.url = 'https://www.youtube.com/embed/DX0fX47rQMc'
      end

      it "finds author on vimeo.com", :vcr do
        @page.url = "http://vimeo.com/31453929"
      end

      it "finds author from a soundcloud.com set", :vcr do
        @page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
      end

      it "finds author from a github.com repo", :vcr do
        @page.url = "https://github.com/rails/commands"
      end

      it "finds author from plus.google.com", :vcr do
        @page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
      end

      it "finds author from a tumblr.com subdomain", :vcr do
        @page.url = "http://staff.tumblr.com/"
      end

      it "finds author for http://www.missionmission.org/", :vcr do
        ::Twitter.stub(:user).and_return(double('user', id:398095666, screen_name:'ChloesThinking'))
        Page.any_instance.stub(:learn)
        @page.url = "http://www.missionmission.org/"
      end

    end

    it "via link tag with with rel=author", :vcr do
      @page.url = "#{Copper::Application.config.hostname}/test"
    end
  end

  it "transitions from adopted to adopted", :vcr do
    #  mock_page
    @page = create!(:page, url:"https://www.facebook.com/scott.fryxell", author_state:"adopted")
    @page.adopted?.should be_true
    # @page.should_receive(:learn)
    @page.adopt!
    @page.adopted?.should be_true
  end

  it "transitions from adopted to orphaned", :vcr do
    @page = create!(:page, url:"https://www.facebook.com/scott.fryxell", author_state:'adopted')
    @page.adopted?.should be_true
    @page.reject!
    # @page.should_receive(:discover_author!)
    @page.orphaned?.should be_true
  end

  it "transitions from :manual to :dead", :vcr do
    @page = create!(:page, url:"http://ruby-doc.org/", author_state:"manual")
    @page.manual?.should be_true
    @page.reject!
    @page.dead?.should be_true
  end

  it 'transitions from :orphaned to :manual', :vcr do
    @page = build!(:page, url:"http://ruby-doc.org/")
    @page.orphaned?.should be_true
    @page.save!
    @page.reload
    @page.manual?.should be_true
  end

  it 'transitions to dead for a site that can\'t be reached', :broken do
    @page.url = "http://test.com/"
  end


  it "can be marked as not safe for work" do
    mock_page
    @page = Page.new
    @page.url = 'http://example.com/path1'

    @page.nsfw = true
    @page.save!
    @page.reload
    @page.nsfw?.should be_true
  end

  it "can discover the page author", :vcr do
    @page = build!(:page)
    @page.url = "https://www.facebook.com/scott.fryxell"
    @page.discover_author!
    @page.author.should_not be_nil
  end
end
