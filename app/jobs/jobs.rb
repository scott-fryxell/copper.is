class UsersJob
  @queue = :high
  def self.perform
    User.select(:id).find_each do |user|
      Resque.enqueue user.class, user.id, :try_to_create_check!
    end
  end
end

class EarnedChecksJob
  @queue = :high
  def self.perform
    Check.earned.select(:id).find_each do |check|
      # Resque.enqueue check.class, check.id, :message_author!
    end
  end
end

class WantedAuthorsJob
  @queue = :high
  def self.perform
    Author.wanted.select(:id).find_each do |wanted|
      Resque.enqueue wanted.class, wanted.id, :message_wanted!
    end
  end
end

class StrangerAuthorsJob
  @queue = :high
  def self.perform
    Author.strangers.select(:id).find_each do |non_user|
      Resque.enqueue non_user.class, non_user.id, :try_to_add_to_wanted_list!
    end
  end
end
