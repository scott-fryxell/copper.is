guard 'process', :name => 'worker', :command => 'rake jobs:work', :stop_signal => 'TERM' do
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

guard 'process', :name => 'web', :command => 'rails s thin -p 3003', :stop_signal => 'TERM' do
  watch('config/routes.rb')
  watch('config/authorization_rules.rb')
end

guard 'rspec', all_on_start:false, all_after_pass:false, zeus:false, bundler: false, parallel: false do
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

guard 'bundler' do
  watch('Gemfile')
end


# guard 'livereload' do
#   watch(%r{app/.+\.(erb|haml)})
#   watch(%r{app/helpers/.+\.rb})
#   watch(%r{(public/|app/assets).+\.(css|js|html|svg)})
#   watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
#   watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
#   watch(%r{(app/assets/.+\.svg)}) { |m| m[1] }
#   watch(%r{config/locales/.+\.yml})
# end

# guard 'zeus' do
#   # uses the .rspec file
#   # --colour --fail-fast --format documentation --tag ~slow
#   watch(%r{^spec/.+_spec\.rb$})
#   watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#   watch(%r{^app/(.+)\.haml$})                         { |m| "spec/#{m[1]}.haml_spec.rb" }
#   watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
#   watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
# end
