class ProviderablePagesJob
  @queue = :high
  
  def self.perform
    puts "Providerable pages job started"
    find_all_and_place_on_queue
  end
  
  def self.find_all_and_place_on_queue
    Page.providerable.select(:id).find_each do |page|
      Resque.enqueue(DiscoverProviderUserJob,page.id)
    end
  end
end
