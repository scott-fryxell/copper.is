class NonUserChecksJob
  @queue = :high
  
  def self.perform
    puts "NonUserChecksJob started"
    Identity.non_users.select(:id).find_each do |non_user|
      Resque.enqueue TryToCreateCheckJob, non_user.id
    end
  end
end
