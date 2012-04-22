class SpiderablePagesJob
  @queue = :high
  
  def self.perform
    Page.spiderable.select(:id).find_each do |page|
      Resque.enqueue FindProviderFromAuthorLinkJob, page.id
    end
  end
end
