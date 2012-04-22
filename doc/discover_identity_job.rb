class DiscoverIdentityJob
  @queue = :high
  
  def self.perform page_id
    Page.find(page_id).discover_identity!
  end
end
