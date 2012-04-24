# ======  RoyaltyCheck observers =======

class UsersJob
  @queue = :high
  def self.perform
    User.select(:id).find_each do |user|
      Resque.enqueue User, user.id, :try_to_create_royalty_check!
    end
  end
end

class EarnedRoyaltyChecksJob
  @queue = :high
  def self.perform
    RoyaltyCheck.earned.select(:id).find_each do |check|
      Resque.enqueue RoyaltyCheck, check.id, :message_author!
    end
  end
end
    
class WantedIdentitiesJob
  @queue = :high
  def self.perform
    Identity.wanted.select(:id).find_each do |wanted|
      Resque.enqueue Identity, wanted.id, :message_wanted!
    end
  end
end

class StrangerIdentitiesJob
  @queue = :high
  def self.perform
    Identity.strangers.select(:id).find_each do |non_user|
      Resque.enqueue Identity, non_user.id, :try_to_add_to_wanted_list!
    end
  end
end


# ======  Page observers =======

class OrphanedPagesJob
  @queue = :high
  def self.perform
    Page.orphaned.select(:id).find_each do |page|
      Resque.enqueue Page, page.id, :match_url_to_provider!
    end
  end
end

class ProviderablePagesJob
  @queue = :high
  def self.perform
    Page.providerable.select(:id).find_each do |page|
      Resque.enqueue Page, page.id, :discover_identity!
    end
  end
end

class SpiderablePagesJob
  @queue = :high
  def self.perform
    Page.spiderable.select(:id).find_each do |page|
      Resque.enqueue Page, page.id, :find_identity_from_author_link!
    end
  end
end
