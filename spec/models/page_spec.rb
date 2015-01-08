describe Page, :type => :model do

  subject {build!(:page)}

  describe '#save' do
    before(:each) do
      subject.url = 'http://example.com/path1'
    end

    it "should save with a valid url" do
      expect(subject.save).to be_truthy
    end

    it "should not save with an invalid url" do
      subject.url = '666'
      expect(subject.save).to be_falsey
    end
  end

  it '#create' do
    subject.save
    expect(Page).to have_queued(subject.id, :learn).once
    expect(Page).to have_queued(subject.id, :discover_author_from_url!).once
    expect(Page).to have_queue_size_of(2)
    expect(subject.orphaned?) == true
  end

  it_behaves_like 'State::Ownable'

  it_behaves_like 'URL::Learnable'

  it_behaves_like 'Itemable'

end
