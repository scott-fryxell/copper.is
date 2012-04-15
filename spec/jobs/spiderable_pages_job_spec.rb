require 'spec_helper'

describe SpiderablePagesJob do
  before :all do
    Resque.inline = true
  end
  
  it 'has a method :find_all_and_place_on_queue' do
    SpiderablePagesJob.respond_to?(:find_all_and_place_on_queue).should be_true
  end

  describe 'no orphaned pages in DB' do
    it 'perform should be called once on SpiderablePagesJob' do
      SpiderablePagesJob.should_receive(:perform).once
      Resque.enqueue SpiderablePagesJob
    end
  end
  
  describe 'one orphaned page in DB' do
    before do
      FactoryGirl.create :page, author_state:'orphaned'
    end
    
    it 'perform should be called once on SpiderablePagesJob' do
      SpiderablePagesJob.should_receive(:perform).once
      Resque.enqueue SpiderablePagesJob
    end
  end
  
  describe 'two orphaned pages in DB' do
    before do
      2.times { FactoryGirl.create :page, author_state:'orphaned' }
    end
    
    it 'perform should be called once on SpiderablePagesJob' do
      SpiderablePagesJob.should_receive(:perform).once
      Resque.enqueue SpiderablePagesJob
    end
  end
end
