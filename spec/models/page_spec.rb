require 'spec_helper'

describe Page, :type => :model do
  subject(:page) do
    build!(:page)
  end

  describe "url" do
    before(:each) do
      mock_page
      page.url = 'http://example.com/path1'
    end

    it "should save with a valid url" do
      expect(page.save).to be_truthy
    end

    it "should not save with an invalid url" do
      page.url = '666'
      expect(page.save).to be_falsey
    end
  end

  describe "ownable" do

    describe "by URL scheme" do

      after do
        page.discover_author!
        expect(page.adopted?).to be_truthy
        expect(page.author).not_to be_nil
        expect(Author.count).to eq(1)
      end

      context "facebook.com" do
        it "from a profile", :vcr do
          page.url = "https://www.facebook.com/scott.fryxell"
        end

        it "from a photo", :vcr do
          page.url = "https://www.facebook.com/photo.php?fbid=559044474113512&set=t.580281278&type=3&theater"
        end

        it "finds author on facebook.com old style id", :vcr do
          page.url = "https://www.facebook.com/profile.php?id=1340075098"
        end
      end

      context "twitter.com" do
        it "from a profile",:vcr do
          allow(::Twitter).to receive(:user).and_return(double('user',id:666, screen_name:'ChloesThinking'))
          allow_any_instance_of(Page).to receive(:learn)
          page.url = "https://twitter.com/ChloesThinking"
        end
      end

      context "flicker.com" do
        it "from a photo", :vcr do
          page.url = "http://www.flickr.com/photos/floridamemory/7067827087/"
        end
      end

      context "youtube.com" do
        it "from a video" do
          page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
          author = double('author',  uri:'http://www.youtube.com/user/BHVthe81st', author_name:'BHVthe81st' )
          allow(Authors::Youtube).to receive_message_chain(:connect_to_api, :video_by, :author).and_return(author)
          allow_any_instance_of(Page).to receive(:learn)
        end

        it "finds author on youtube.com from a video url" do
          page.url = "http://www.youtube.com/watch?v=h8YlfYpnXL0"
          author = double('author',  uri:'http://www.youtube.com/user/BHVthe81st', author_name:'BHVthe81st' )
          allow(Authors::Youtube).to receive_message_chain(:connect_to_api, :video_by, :author).and_return(author)
          allow_any_instance_of(Page).to receive(:learn)
        end

        it "finds author on youtube.com from a user profile" do
          page.url = 'http://www.youtube.com/user/machinima?ob=4'
        end

        it "finds author from a youtube.com channel" do
          page.url = 'http://www.youtube.com/pitchforktv'
        end

        it "finds author from a youtube.com embed link" do
          page.url = 'https://www.youtube.com/embed/DX0fX47rQMc'
        end

      end

      context "vimeo.com" do
        it "from a video", :vcr do
          page.url = "http://vimeo.com/31453929"
        end
      end

      context "soundcloud.com" do
        it "from a set" do
          page.url = "http://soundcloud.com/snoopdogg/sets/samples-106/"
        end
      end

      context "github.com" do
        it "from a repo" do
          page.url = "https://github.com/rails/commands"
        end
      end

      context "plus.google.com" do
        it "prom a profile" do
          page.url = "https://plus.google.com/u/0/110700893861235018134/posts?hl=en"
        end
      end

      context "tumblr.com" do
        it "from a subdomain" do
          page.url = "http://staff.tumblr.com/"
        end
      end

    end

    describe "by spidering" do
      after do
        page.reject!
        expect(page.fostered?).to be_truthy
        page.discover_author_from_page_links!
        expect(page.adopted?).to be_truthy
        expect(page.author).not_to be_nil
        expect(Author.count).to eq(1)
        expect(Page).to have_queued(page.id, :discover_author_from_page_links!)
        expect(Page).to have_queue_size_of(1)
      end

      context "www.missionmission.org" do
        it "for social networks we can authorize", :vcr do
          allow(::Twitter).to receive(:user).and_return(double('user', id:398095666, screen_name:'ChloesThinking'))
          page.url = "http://www.missionmission.org/"
        end
      end

      context "local page" do
        it "for a <link rel=author >", :vcr do
          page.url = "#{Copper::Application.config.hostname}/test"
        end
      end

    end

    context "can't do it" do

      it "init to orphaned" do
        page = create!(:page, url:"https://www.facebook.com/scott.fryxell")
        expect(Page).to have_queued(page.id, :learn).once
        expect(Page).to have_queued(page.id, :discover_author!).once
        expect(Page).to have_queue_size_of(2)
        expect(page.orphaned?).to be_truthy
      end

      it 'from :orpaned to :fostered' do
        # page = create!(:page, url:"http://ruby-doc.org/")
        expect(page.orphaned?).to be_truthy
        page.reject!
        expect(page.fostered?).to be_truthy
        expect(Page).to have_queued(page.id, :discover_author_from_page_links!).once
        expect(Page).to have_queue_size_of(1)
      end

      it "from adopted to orphaned" do
        page = create!(:page, url:"https://www.facebook.com/scott.fryxell", author_state:"adopted")
        expect(page.adopted?).to be_truthy
        page.reject!
        expect(page.orphaned?).to be_truthy
        expect(Page).to have_queued(page.id, :discover_author!).once
        expect(Page).to have_queue_size_of(1)
      end


      it "from :manual to :dead" do
        page = create!(:page, url:"http://ruby-doc.org/", author_state:"manual")
        expect(page.manual?).to be_truthy
        page.reject!
        expect(page.dead?).to be_truthy
        expect(Page).to have_queue_size_of(1)
      end

    end

  end


  describe "learnable" do
    it "learns everything" do
      page.url = "#{Copper::Application.config.hostname}/test"
      page.learn

      expect(page.title).to eq("copper-test page")
      expect(page.description).to eq("I'm round")
      expect(page.url).to eq("http://www.copper.is/test")
      expect(page.thumbnail_url).to eq("http://www.copper.is/logo.svg")
    end

    context "learn title" do
      it "by title tag"
      it "by og:title"
    end

    context "learn description"

    context "learn image"

    context "learn canonicle url"

  end


  describe "itemable" do
    it "gives you an item_id" do
      expect(page.item_id).to eq("/pages/#{page.id}")
    end

    it "let's you know if it's nested insid an item" do
      expect(page.nested?).to be_falsey
    end

    it "gives you the full item spec attributes" do
      expect(page.as_item_attributes).to eq %Q[
        itemscope itemtype='page'
        itemid='#{page.item_id}'
        itemprop='author_state'
        data-author_state='#{page.author_state}'
      ]


    end

  end

  it "from adopted to adopted" do
    page = create!(:page, url:"https://www.facebook.com/scott.fryxell", author_state:"adopted")
    expect(page.adopted?).to be_truthy
    page.adopt!
    expect(page.adopted?).to be_truthy
    expect(Page).to have_queued(page.id, :learn)
    expect(Page).to have_queue_size_of(1)

  end

  it 'to dead for a site that can\'t be reached', :broken do
    page.url = "http://test.com/"
  end


  it "can keep the workplace clean (nsfw)" do
    mock_page
    page = Page.new
    page.url = 'http://example.com/path1'

    page.nsfw = true
    page.save!
    page.reload
    expect(page.nsfw?).to be_truthy
  end


end
