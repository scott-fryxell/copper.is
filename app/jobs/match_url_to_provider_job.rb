class MatchUrlToProviderJob
  @queue = :high
  
  def self.perform page_id
    Page.find(page_id).match_url_to_provider!
  end
end
