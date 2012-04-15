class FindProviderAuthorJob
  @queue = :high
  
  def self.perform page_id
    Page.find(page_id).find_provider_author!
  end
end
