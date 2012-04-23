class ProviderablePagesJob
  @queue = :high
  
  def self.perform
    Page.providerable.select(:id).find_each do |page|
      Resque.enqueue(DiscoverIdentityJob,page.id)
    end
  end
end
