require 'spec_helper'

describe Author do
  before do
    @author = Author.create!
  end
  
  it 'is valid empty' do
    @author.should be_valid
  end
  
  it 'starts with no checks' do
    @author.checks.size.should eq(0)
  end
  
  it 'has many pages' do
    proc do
      @author.pages.create!(url:'http://test.com')
    end.should change(@author.pages,:count).by(1)
  end
  
  describe 'primary_channel' do
    before do
      @author.channels.create!(address:'me@test.com')
    end
    
    it 'responds' do
      @author.should respond_to(:primary_channel)
    end
    
    it 'returns a Channl' do
      @author.primary_channel.class.ancestors.should include(Channel)
    end
    
    it 'is the only if there is only one' do
      
    end
  end
  
  describe '#merge!' do
    before do
      @other = Author.create!(city:'Denver')
      @other.checks.create!
      @author.city = 'San Francisco'
      @author.save!
      @author.merge! @other
      @author.reload
    end
    
    it 'the receiver remains in DB' do
      @author.should be_valid
    end
    
    it 'the given is destroyed' do
      proc { @other.reload }.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it 'the receiver overrides address details' do
      @author.city.should eq('San Francisco')
    end
    
    it 'the receiver has the union on checks' do
      @author.checks.size.should eq(1)
    end
  end
end
