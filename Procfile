web: bundle exec rails server thin -p $PORT
redis: /usr/local/bin/redis-server ./config/redis.conf
worker: bundle exec rake jobs:work
