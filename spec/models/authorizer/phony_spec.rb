describe Authorizer::Phony, :type => :model do
  subject(:author) {create!(:author_phony)}

  describe '#populate_uid_and_username!' do
    it 'finds the uid if username is set' do
      author.uid = nil
      author.username = '1'
    end

    it 'finds the username if uid is set' do
      author.uid = '1'
      author.username = nil
    end

    after do
      author.populate_uid_and_username!
      expect(author.username).to eq('1')
      expect(author.uid).to eq('1')
    end
  end
end
