require File.dirname(__FILE__) + '/../spec_helper'

describe TipOrderChargeJob do
  before do
  #   Resque.inline = true
  #   @worker = Resque::Worker.new(:high)
    @tip_order = TipOrder.create fan:users(:a_developer)
    @tip_order.valid?.should be_true
  end
  
  # it "queue onto the Resque high priority queue" do
  #   Resque.enqueue(TipOrderChargeJob, @tip_order.id)
  #   @worker.failed.should == 0
  #   @worker.processed.should == 0
  #   @worker.work do |job|
  #     @worker.failed.should == 0
  #     @worker.processed.should == 1
  #   end
  # end
  
  it 'has a working .perform' do
    @tip_order.stub(:charge)
    TipOrderChargeJob.perform(@tip_order.id)
  end
end

