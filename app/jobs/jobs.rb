class UsersJob
  @queue = :high
  def self.perform
    User.select(:id).find_each do |user|
      Resque.enqueue User, user.id, :try_to_create_check!
    end
  end
end

class EarnedChecksJob
  @queue = :high
  def self.perform
    Check.earned.select(:id).find_each do |check|
      # Resque.enqueue Check, check.id, :message_author!
    end
  end
end

class WantedAuthorsJob
  @queue = :high
  def self.perform
    Author.wanted.select(:id).find_each do |wanted|
      Resque.enqueue Author, wanted.id, :message_wanted!
    end
  end
end

class StrangerAuthorsJob
  @queue = :high
  def self.perform
    Author.strangers.select(:id).find_each do |non_user|
      Resque.enqueue Author, non_user.id, :try_to_add_to_wanted_list!
    end
  end
end
