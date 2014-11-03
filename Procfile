web: bundle exec puma -C config/puma.rb
worker: env TERM_CHILD=1 bundle exec rake resque:work
