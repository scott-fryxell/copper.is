require 'spec_helper'

describe ProviderablePagesJob do
  it 'has a method :find_all_and_place_on_queue' do
    ProviderablePagesJob.respond_to?(:find_all_and_place_on_queue).should be_true
  end
  
  describe 'no providerable pages in DB' do
    it 'perform should be called once on ProviderablePagesJob'
  end
  
  describe 'one providerable page in DB' do
    before do
      FactoryGirl.create :page, author_state:'providerable'
    end
    
    it 'perform should be called once on ProviderablePagesJob'
  end
  
  describe 'two providerable pages in DB' do
    before do
      2.times { FactoryGirl.create :page, author_state:'providerable' }
    end
    
    it 'perform should be called once on ProviderablePagesJob'
  end
end
