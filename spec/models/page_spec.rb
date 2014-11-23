describe Page, :type => :model do

  subject(:page) {build!(:page)}

  describe '#save' do
    before(:each) do
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

  it '#create' do
    page = create!(:page, url:"https://www.facebook.com/scott.fryxell")
    expect(Page).to have_queued(page.id, :learn).once
    expect(Page).to have_queued(page.id, :discover_author!).once
    expect(Page).to have_queue_size_of(2)
    expect(page.orphaned?) == true
  end

  describe "ownable" do

    describe '#discover_author!' do

      after do
        page.discover_author!
        expect(page.adopted?) == true
        expect(page.author).not_to be_nil
        expect(Author.count).to == 1
      end

    end

    describe '#discover_author_from_page_links!' do
      after do
        page.reject!
        expect(page.fostered?) == true
        page.discover_author_from_page_links!
        expect(page.adopted?) == true
        expect(page.author).not_to be_nil
        expect(Author.count).to eq(1)
        expect(Page).to have_queued(page.id, :discover_author_from_page_links!)
        expect(Page).to have_queue_size_of(1)
      end

      context "wordpress" do
        it "for www.missionmission.org", :vcr do
          page.url = "http://www.missionmission.org/"
        end
      end

      context "/test" do
        it "for a <link rel=author >", :vcr do
          page.url = "#{Copper::Application.config.hostname}/test"
        end
      end

    end

    describe '#reject!' do

      it "adopted => orphaned" do
        page = create!(:page, url:"https://www.facebook.com/scott.fryxell", author_state:"adopted")
        expect(page.adopted?) == true
        page.reject!
        expect(page.orphaned?) == true
        expect(Page).to have_queued(page.id, :discover_author!).once
        expect(Page).to have_queue_size_of(1)
      end

      it 'orpaned => fostered' do
        # page = create!(:page, url:"http://ruby-doc.org/")
        expect(page.orphaned?) == true
        page.reject!
        expect(page.fostered?) == true
        expect(Page).to have_queued(page.id, :discover_author_from_page_links!).once
        expect(Page).to have_queue_size_of(1)
      end

      it 'fostered => manual'

      it ":manual => :dead" do
        page = create!(:page, url:"http://ruby-doc.org/", author_state:"manual")
        expect(page.manual?) == true
        page.reject!
        expect(page.dead?) == true
        expect(Page).to have_queue_size_of(1)
      end

    end


    describe '#adopt!' do
      it ":orphaned => :adopted"
      it ":fostered => :adopted"
      it ":manual => :adopted"

      it ":adopted => :adopted" do
        page = create!(:page, url:"https://www.facebook.com/scott.fryxell", author_state:"adopted")
        expect(page.adopted?) == true
        page.adopt!
        expect(page.adopted?) == true
        expect(Page).to have_queued(page.id, :learn)
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
    it '#item_id' do
      expect(page.item_id).to eq("/pages/#{page.id}")
    end

    it '#nested' do
      expect(page.nested?).to be_falsey
    end

    it '#as_item_attributes' do
      expect(page.as_item_attributes).to eq %Q[
        itemscope itemtype='page'
        itemid='#{page.item_id}'
        itemprop='author_state'
        data-author_state='#{page.author_state}'
      ]
    end

  end

end
