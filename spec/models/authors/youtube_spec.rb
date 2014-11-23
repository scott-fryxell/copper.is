describe Authors::Youtube, :type => :model do

  describe '#populate_uid_and_username!' do
    before do
      @author = create!(:author_youtube, username:"_ugly")
    end

    it 'finds the uid if username is set' # do
    #   @author.uid = nil
    #   @author.username = '_ugly'
    # end

    it 'finds the username if uid is set' # do
    #   @author.uid = '26368397'
    #   @author.username = nil
    # end

    after do
      expect(@author.save).to be_truthy
      @author.reload
      @author.populate_uid_and_username!
      expect(@author.username).to eq('_ugly')
      expect(@author.uid).to eq('26368397')
    end
  end

  context "youtube.com", :broken do
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

end
