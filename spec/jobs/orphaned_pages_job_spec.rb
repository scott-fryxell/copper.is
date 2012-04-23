require 'spec_helper'

describe OrphanedPagesJob do
  before :all do
    Resque.inline = true
  end

  describe 'no orphaned pages in DB' do
    it 'perform should be called once on OrphanedPagesJob' do
      OrphanedPagesJob.should_receive(:perform).once
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
    
  end
  
  describe 'two orphaned pages in DB' do
    before do
      2.times { FactoryGirl.create :page, author_state:'orphaned' }
    end
    
    it 'perform should be called once on OrphanedPagesJob' do
      OrphanedPagesJob.should_receive(:perform).once
      Resque.enqueue OrphanedPagesJob
    end
  end
end
