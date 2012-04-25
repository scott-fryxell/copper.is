class FindProviderFromAuthorLinkJob
  @queue = :high
  
  def self.perform page_id
    Page.find(page_id).find_provider_from_author_link!
  end
end
