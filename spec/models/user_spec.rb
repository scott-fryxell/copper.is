require 'spec_helper'

describe User do
  before :each do
    @me = create!(:user)
  end
  describe 'authors' do
    it 'doesn\'t allow removal of last' do pending
      @me.authors.count.should == 1
      author = @me.authors.first
      @her.authors << author
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

  describe 'email', :focus do
    it 'should validate emails with a + sign' do
      @me = create!(:user_email)
    end
  end
end
