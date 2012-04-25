class InformAuthorOfEarnedRoyaltyCheckJob
  @queue = :high
  
  def self.perform(royalty_check_id)
    royalty_check = RoyaltyCheck.find(royalty_check_id)
    puts "InformAuthorOfEarnedRoyaltyCheckJob starting for: #{royalty_check.inspect}"
    royalty_check.identity.inform_author_of_earned_royalty_check!
  end
end
