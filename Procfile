web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: env TERM_CHILD=1 bundle exec rake jobs:work COUNT=1 