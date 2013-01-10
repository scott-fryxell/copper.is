require 'spec_helper'

describe Authors::Phony do
  before do
    @author = FactoryGirl.create(:authors_phony)
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
      @author.save.should be_true
      @author.reload
      @author.populate_uid_and_username!
      @author.username.should == '1'
      @author.uid.should == '1'
    end
  end
end
