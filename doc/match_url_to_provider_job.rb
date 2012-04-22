class MatchUrlToProviderJob
  @queue = :high
  
  def self.perform page_id
    page = Page.find(page_id)
    puts "MatchUrlToProviderJob started for: #{page.inspect}"
    page.match_url_to_provider!
  end
end
