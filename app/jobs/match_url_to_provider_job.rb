class MatchUrlToProviderJob
  @queue = :high
  
  def self.perform page_id
    page = Page.find(page_id)
    puts "MatchUrlToProviderJob started BEFORE: #{page.inspect}"
    page.match_url_to_provider!
    page = Page.find(page_id)
    puts "MatchUrlToProviderJob started: AFTER:  #{page.inspect}"
  end
end
