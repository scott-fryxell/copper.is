class SpiderablePagesJob
  @queue = :high
  
  def self.perform
    puts "Spiderable pages job started"
    find_all_and_place_on_queue
  end
  
  def self.find_all_and_place_on_queue
    Page.spiderable.select(:id).find_each do |page|
      Resque.enqueue FindProviderFromAuthorLinkJob, page.id
    end
  end
end
