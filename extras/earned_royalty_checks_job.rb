class EarnedChecksJob
  @queue = :high
  
  def self.perform
    puts "EarnedChecksJob started"
    Check.earned.select(:id).find_each do |check|
      Resque.enqueue InformAuthorOfEarnedCheckJob, check.id
    end
  end
end
