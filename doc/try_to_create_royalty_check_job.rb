class TryToCreateRoyaltyCheckJob
  @queue = :high
  
  def self.perform(identity_id)
    identity = Identity.find(identity_id)
    if identity and identity.user_id.nil?
      puts "TryToCreateRoyaltyCheckJob started for: #{identity.inspect}"
      identity.try_to_create_royalty_check!
    else
      puts 'WARN: an identity with a user sent to the TryToCreateRoyaltyCheckJob'
    end
  end
end

