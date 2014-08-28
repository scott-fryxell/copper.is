guard 'process', name:'worker', command:'env TERM_CHILD=1 COUNT=1 bundle exec rake resque:work', stop_signal:'KILL' do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/authorization_rules.rb')
  watch(%r{^config/environments/.+\.rb})
  watch(%r{^config/initializers/.+\.rb})
  watch('/app/models/**/*.rb')
  watch('/app/models/*.rb')
  watch('/app/jobs/*.rb')
  watch('/lib/**/*.rb')
end

guard 'process', name:'web', command:'bundle exec puma -p 3000', stop_signal:'KILL' do
  # puma requres caching files to run multithreaded.
  # let's restart the server every time we change a ruby file.
  # :sigh:
  watch('config/routes.rb')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/authorization_rules.rb')
  watch(%r{^config/environments/.+\.rb})
  watch(%r{^config/initializers/.+\.rb})
  watch('/app/**/*.rb')
  watch('/lib/**/*.rb')
end

guard :rspec, cmd:"spring rspec", all_on_start:false, all_after_pass:false, parallel: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})                                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')                                           { "spec" }
  watch('.rspec')                                                        { "spec" }
  watch(%r{^app/(.+)\.rb$})                                              { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                                    { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})                     { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                                     { "spec" }
  watch('config/routes.rb')                                              { "spec/routing" }
  watch('app/controllers/application_controller.rb')                     { "spec/controllers" }
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})                             { |m| "spec/features/#{m[1]}_spec.rb" }
  watch(/^spec\/.+\.rb$/)                                                { 'spec' }
  watch(/^app\/.+\.rb$/)                                                 { 'spec' }
  watch(/^config\/.+\.rb$/)                                              { 'spec' }
  watch(%r{(public/|app/assets|app/views).+\.(js|html|coffee|erb|json)}) {'spec/features'}
end

# guard :livereload do
#   watch(%r{^app/.+\.(erb|haml|js|css|scss|sass|styl|coffee|svg|png|gif|jpg)})
#   watch(%r{^app/helpers/.+\.rb})
#   watch(%r{^public/.+\.html})
#   watch(%r{^config/locales/.+\.yml})
# end
