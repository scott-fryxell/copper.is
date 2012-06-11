class InformAuthorOfEarnedCheckJob
  @queue = :high
  
  def self.perform(check_id)
    check = Check.find(check_id)
    puts "InformAuthorOfEarnedCheckJob starting for: #{check.inspect}"
    check.identity.inform_author_of_earned_check!
  end
end
