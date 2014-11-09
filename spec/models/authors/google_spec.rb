require 'spec_helper'
# http://plus.google.com/110547857076579322423/
describe Authors::Google, :type => :model do
  before do
    @author = create!(:author_google, username:"_ugly", uid:'666')
    # http://plus.google.com/110547857076579322423/
  end

  it "should render a profile url" do
    expect(@author.url).to eq("https:///plus.google.com/666")
  end

  it "should render a profile image" do
    expect(@author.profile_image).to eq("https://plus.google.com/s2/photos/profile/666")
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
      expect(@author.save).to be_truthy
      @author.reload
      @author.populate_uid_and_username!
      expect(@author.username).to eq('_ugly')
      expect(@author.uid).to eq('26368397')
    end
  end
end

