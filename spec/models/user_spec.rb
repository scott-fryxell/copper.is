require 'spec_helper'

describe User do
  before :each do
    mock_user
    @me = create!(:user_with_facebook_author)
    @her = create!(:user)
  end
  describe 'authors' do
    it 'there should be always one' do pending
      Author.count.should == 1
      @me.authors.count.should == 1
      author = @me.authors.first
      @her.authors << author
      proc { @me.save! }.should raise_error
      proc { author.save! }.should raise_error
      @me.authors.count.should > 0
      @her.authors.count.should > 0
    end
  end

  describe 'email' do
    it 'should validate emails with a + sign' do
      @me = create!(:user_with_email)
    end
  end

  describe "lists" do

    it "should know all the fans who have tipped" do
      User.should respond_to(:tipped)
    end

    it "should know all the fans who have provided payment info" do
      User.should respond_to(:payment_info)
    end

  end
end
