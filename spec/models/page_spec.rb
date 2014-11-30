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

  it_behaves_like 'State::Ownable'

  it_behaves_like 'URL::Learnable'

  it_behaves_like 'Itemable'

end
