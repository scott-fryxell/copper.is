class NonUserRoyaltyChecksJob
  @queue = :high
  
  def self.perform
    puts "NonUserRoyaltyChecksJob started"
    Identity.non_users.select(:id).find_each do |non_user|
      Resque.enqueue TryToCreateRoyaltyCheckJob, non_user.id
    end
  end
end
