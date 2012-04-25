class OrphanedPagesJob
  @queue = :high
  
  def self.perform
    Page.orphaned.select(:id).find_each do |page|
      Resque.enqueue MatchUrlToProviderJob, page.id
    end
  end
end
