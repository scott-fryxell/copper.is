describe Authorizer::Youtube, :type => :model do
  subject(:author) {create!(:author_youtube, username:'_ugly')}

  describe '#populate_uid_and_username!' do

    it 'finds the uid if username is set' # do
    #   @author.uid = nil
    #   @author.username = '_ugly'
    # end

    it 'finds the username if uid is set' # do
    #   @author.uid = '26368397'
    #   @author.username = nil
    # end

    after do
      author.populate_uid_and_username!
      expect(author.username).to eq('_ugly')
      expect(author.uid).to eq('26368397')
    end
  end

  context '#identity_from_url' do

    context 'identifiable' do

      it 'http://www.youtube.com/user/machinima?ob=4' do
        expect(Author.identity_from_url('http://www.youtube.com/user/machinima?ob=4')).to be_truthy
      end

      it 'http://www.youtube.com/pitchforktv' do
        expect(Author.identity_from_url('http://www.youtube.com/pitchforktv')).to be_truthy
      end

    end

    context 'unidentifiable' do

      it 'https://www.youtube.com/watch?v=JEJpmDUMKco' do
        expect(Author.identity_from_url('https://www.youtube.com/watch?v=JEJpmDUMKco')).to be_nil
      end

      it 'https://www.youtube.com/embed/DX0fX47rQMc' do
        expect(Author.identity_from_url('https://www.youtube.com/embed/DX0fX47rQMc')).to be_nil
      end

    end

  end

end
