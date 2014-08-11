require 'spec_helper'
# http://plus.google.com/110547857076579322423/
describe Authors::Google do
  before do
    @author = create!(:author_google, username:"_ugly", uid:'666')
    # http://plus.google.com/110547857076579322423/
  end

  it "should render a profile url" do
    @author.url.should == "https:///plus.google.com/666"
  end

  it "should render a profile image" do
    @author.profile_image.should == "https://plus.google.com/s2/photos/profile/666"
  end

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
      @author.save.should be_true
      @author.reload
      @author.populate_uid_and_username!
      @author.username.should == '_ugly'
      @author.uid.should == '26368397'
    end
  end
end

