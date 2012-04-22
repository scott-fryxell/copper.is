# single

class DiscoverIdentityJob
  @queue = :high
  def self.perform page_id
    Page.find(page_id).discover_identity!
  end
end

class FindProviderFromAuthorLinkJob
  @queue = :high
  def self.perform page_id
    Page.find(page_id).find_provider_from_author_link!
  end
end

class InformAuthorOfEarnedRoyaltyCheckJob
  @queue = :high
  def self.perform(royalty_check_id)
    RoyaltyCheck.find(royalty_check_id).identity.inform_author_of_earned_royalty_check!
  end
end

class MatchUrlToProviderJob
  @queue = :high
  def self.perform page_id
    Page.find(page_id).match_url_to_provider!
  end
end

class TryToCreateRoyaltyCheckJob
  @queue = :high
  def self.perform(identity_id)
    Identity.find(identity_id).try_to_create_royalty_check!
  end
end

# collection based job

class EarnedRoyaltyChecksJob
  @queue = :high
  def self.perform
    RoyaltyCheck.earned.select(:id).find_each do |check|
      Resque.enqueue InformAuthorOfEarnedRoyaltyCheckJob, check.id
    end
  end
end

class SpiderablePagesJob
  @queue = :high
  def self.perform
    Page.spiderable.select(:id).find_each do |page|
      Resque.enqueue FindProviderFromAuthorLinkJob, page.id
    end
  end
end

class NonUserRoyaltyChecksJob
  @queue = :high
  def self.perform
    Identity.non_users.select(:id).find_each do |non_user|
      Resque.enqueue TryToCreateRoyaltyCheckJob, non_user.id
    end
  end
end

class OrphanedPagesJob
  @queue = :high
  def self.perform
    Page.orphaned.select(:id).find_each do |page|
      Resque.enqueue MatchUrlToProviderJob, page.id
    end
  end
end

class ProviderablePagesJob
  @queue = :high
  def self.perform
    Page.providerable.select(:id).find_each do |page|
      Resque.enqueue DiscoverIdentityJob, page.id
    end
  end
end

