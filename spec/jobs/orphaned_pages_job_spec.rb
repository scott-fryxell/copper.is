require 'spec_helper'

describe OrphanedPagesJob do
  before :all do
    Resque.inline = true
  end
  it 'has a method :find_all_and_place_on_queue' do
    OrphanedPagesJob.respond_to?(:find_all_and_place_on_queue).should be_true
  end

  describe 'no orphaned pages in DB' do
    it 'perform should be called once on OrphanedPagesJob' do
      OrphanedPagesJob.should_receive(:perform).once
      Resque.enqueue OrphanedPagesJob
    end
    
    it 'perform should be called 0 times on OrphanedPageCatagorizeJob' do
      OrphanedPageCatagorizeJob.should_not_receive(:perform)
      Resque.enqueue OrphanedPagesJob
    end
  end
  
  describe 'one orphaned page in DB' do
    before do
      FactoryGirl.create :page, author_state:'orphaned'
    end
    
    it 'perform should be called once on OrphanedPagesJob' do
      OrphanedPagesJob.should_receive(:perform).once
      Resque.enqueue OrphanedPagesJob
    end
    
    it 'perform should be called 1 time on OrphanedPageCatagorizeJob' do
      OrphanedPageCatagorizeJob.should_receive(:perform).once
      Resque.enqueue OrphanedPagesJob
    end
  end
  
  describe 'two orphaned pages in DB' do
    before do
      2.times { FactoryGirl.create :page, author_state:'orphaned' }
    end
    
    it 'perform should be called once on OrphanedPagesJob' do
      OrphanedPagesJob.should_receive(:perform).once
      Resque.enqueue OrphanedPagesJob
    end
    
    it 'perform should be called 2 times on OrphanedPageCatagorizeJob' do
      OrphanedPageCatagorizeJob.should_receive(:perform).twice
      Resque.enqueue OrphanedPagesJob
    end
  end
end
