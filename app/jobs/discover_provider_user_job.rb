class DiscoverProviderUserJob
  @queue = :high
  
  def self.perform page_id
    Page.find(page_id).discover_provider_user!
  end
end
