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

  describe 'addresses' do
    it 'has 2 lines, a postal code, a country, a state, a territory, and a city' do
      @me.should respond_to(:payable_to)
      @me.should respond_to(:line1)
      @me.should respond_to(:line2)
      @me.should respond_to(:postal_code)
      @me.should respond_to(:country_code)
      @me.should respond_to(:subregion_code)
      @me.should respond_to(:city)

      @me.should respond_to(:payable_to=)
      @me.should respond_to(:line1=)
      @me.should respond_to(:line2=)
      @me.should respond_to(:postal_code=)
      @me.should respond_to(:country_code=)
      @me.should respond_to(:subregion_code=)
      @me.should respond_to(:city=)
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
