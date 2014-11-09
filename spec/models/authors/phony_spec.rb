require 'spec_helper'

describe Authors::Phony, :type => :model do
  before do
    mock_page
    @author = create!(:author_phony)
  end

  describe '#populate_uid_and_username!' do
    it 'finds the uid if username is set' do
      @author.uid = nil
      @author.username = '1'
    end

    it 'finds the username if uid is set' do
      @author.uid = '1'
      @author.username = nil
    end

    after do
      expect(@author.save).to be_truthy
      @author.reload
      @author.populate_uid_and_username!
      expect(@author.username).to eq('1')
      expect(@author.uid).to eq('1')
    end
  end
end
