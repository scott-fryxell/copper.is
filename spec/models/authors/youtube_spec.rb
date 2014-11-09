require 'spec_helper'

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
end
