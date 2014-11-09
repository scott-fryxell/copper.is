require 'spec_helper'

describe User, :type => :model do
  before :each do
    mock_user
    @me = create!(:user_with_facebook_author)
    @her = create!(:user)
  end
  describe 'authors' do
    it 'there should be always one' do skip
      expect(Author.count).to eq(1)
      expect(@me.authors.count).to eq(1)
      author = @me.authors.first
      @her.authors << author
      expect { @me.save! }.to raise_error
      expect { author.save! }.to raise_error
      expect(@me.authors.count).to be > 0
      expect(@her.authors.count).to be > 0
    end
  end

  describe 'email' do
    it 'should validate emails with a + sign' do
      @me = create!(:user_with_email)
    end
  end

  describe "lists" do

    it "should know all the fans who have tipped" do
      expect(User).to respond_to(:tipped)
    end

    it "should know all the fans who have provided payment info" do
      expect(User).to respond_to(:payment_info)
    end

  end
end
