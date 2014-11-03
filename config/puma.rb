require 'resque/server'

workers Integer(ENV['PUMA_WORKERS'] || 2)
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

prune_bundler

on_restart do
  puts "***************** on puma restart ******************************º"

  if defined?(Resque)

  end
end

on_worker_boot do

  puts "***************** on worker boot ******************************º"
  if defined?(Resque)

  end
end
