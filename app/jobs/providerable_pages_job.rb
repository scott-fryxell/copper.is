class ProviderablePagesJob
  @queue = :high
  
  def self.perform
    puts "ProviderablePagesJob started. Found #{Page.providerable.count} :providerable pages"
    find_all_and_place_on_queue
  end
  
  def self.find_all_and_place_on_queue
    Page.providerable.select(:id).find_each do |page|
      Resque.enqueue(DiscoverIdentityJob,page.id)
    end
  end
end
