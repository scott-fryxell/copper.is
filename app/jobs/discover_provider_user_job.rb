class DiscoverIdentityJob
  @queue = :high
  
  def self.perform page_id
    page = Page.find(page_id)
    puts "DiscoverIdentityJob started: BEFORE:  #{page.inspect}"
    page.discover_identity!
    page = Page.find(page_id)
    puts "DiscoverIdentityJob started: AFTER:  #{page.inspect}"
  end
end
