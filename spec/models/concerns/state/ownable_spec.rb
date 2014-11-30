shared_examples_for "State::Ownable" do

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
