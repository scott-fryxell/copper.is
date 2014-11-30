
# TODO: this is where i tie all the gears together.
# once scheduled these jobs cycle through the service
# billing fans for their tips
# finding authorse to invite to the service
# paying authors that have proviced their bank info
class CreateRoyaltiesJob
  @queue = :normal
  def self.perform
    User.select(:id).find_each do |id|
      Resque.enqueue User, id, :try_to_create_check!
    end
  end
end

class PayRoyaltiesJob
  @queue = :normal
  def self.perform
    Check.earned.pluck(:id).find_each do |id|
      Resque.enqueue Check, id, :try_to_deposit
    end
  end
end

class InviteAuthorsJoin
  @queue = :normal
  def self.perform
    Author.wanted.pluck(:id).find_each do |id|
      Resque.enqueue Author, id, :message_wanted!
    end
  end
end

class StrangerAuthorsJob
  @queue = :normal
  def self.perform
    Author.strangers.pluck(:id).find_each do |id|
      Resque.enqueue Author, id, :try_to_add_to_wanted_list!
    end
  end
end
