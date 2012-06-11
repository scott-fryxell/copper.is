class TryToCreateCheckJob
  @queue = :high
  
  def self.perform(identity_id)
    identity = Identity.find(identity_id)
    if identity and identity.user_id.nil?
      puts "TryToCreateCheckJob started for: #{identity.inspect}"
      identity.try_to_create_check!
    else
      puts 'WARN: an identity with a user sent to the TryToCreateCheckJob'
    end
  end
end

