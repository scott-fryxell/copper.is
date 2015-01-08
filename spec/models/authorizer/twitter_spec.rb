describe Authorizer::Twitter, :type => :model do
  subject(:author) { create!(:author_twitter, username:'copper_is') }
  let(:user){double('user', id:398095666, screen_name:'copper_is', determine_image_url:'https://pbs.twimg.com/determine_images/1303637209/nostrals.jpg')}

  before do
    allow(author).to receive(:send_tweet)
    allow(::Twitter).to receive(:user).and_return(user)
  end

  describe '#identity_from_url' do

    context 'identifiable' do

      it 'https://twitter.com/#!/nytopinion' do
        expect(Author.find_or_create_from_url('https://twitter.com/#!/nytopinion')).to be_truthy
      end

      it 'https://twitter.com/nytopinion' do
        expect(Author.find_or_create_from_url('https://twitter.com/nytopinion')).to be_truthy
      end

    end

    context 'unidentifiable' do

      it 'https://www.twitter.com/' do
        expect(Author.identity_from_url('https://www.twitter.com/')).to be_falsey
      end

      it 'http://twitter.com/share' do
        expect(Author.identity_from_url('http://twitter.com/share')).to be_falsey
      end

    end


  end

  describe '#populate_uid_and_username!' do

    after do
      author.populate_uid_and_username!
      expect(author.username).to eq('copper_is')
      expect(author.uid).to eq('398095666')
    end

    it 'finds the uid if usenname is set', :vcr do
      author.uid = nil
      author.username = 'copper_is'
    end

    it 'finds the username if uid is set', :vcr do
      author.uid = '398095666'
      author.username = nil
    end

  end

  it '#url' do
    expect(author.url).to eq('https://twitter.com/copper_is')
  end

  it '#determine_image', :vcr do
    expect(author.determine_image).to eq('http://pbs.twimg.com/profile_images/3625367668/b5622df6cc1937bd86674450896fb182.png')
  end

end
