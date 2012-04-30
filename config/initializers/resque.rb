Dir[File.join(Rails.root, 'app', 'jobs', '*.rb')].each do |file| 
  require file
end
# config = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env]
# Resque.redis = Redis.new host: config['host'], port: config['port']
