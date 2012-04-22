class EarnedRoyaltyChecksJob
  @queue = :high
  
  def self.perform
    puts "EarnedRoyaltyChecksJob started"
    RoyaltyCheck.earned.select(:id).find_each do |check|
      Resque.enqueue InformAuthorOfEarnedRoyaltyCheckJob, check.id
    end
  end
end
