require 'spec_helper'

describe Authors::Youtube do

  describe '#populate_uid_and_username!' do
    before do
      @author = FactoryGirl.create(:authors_youtube, username:"_ugly")
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
      @author.save.should be_true
      @author.reload
      @author.populate_uid_and_username!
      @author.username.should == '_ugly'
      @author.uid.should == '26368397'
    end
  end
end
