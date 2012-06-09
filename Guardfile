guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
end

guard 'rspec', :version => 2, :cli => '--color --format doc --drb',
               :all_on_start => true, :all_after_pass => false do
  watch(/spec\/.+_spec\.rb/) { "spec" }
  # watch(/^lib\/([^#]+)\.rb$/)
  watch('spec/spec_helper.rb')  { "spec" }
  # watch(%r{^spec/support/.+\.rb$}) { 'spec' }

  # watch(%r{^app/([^\#]+)\.rb$})                       { |m| "spec/#{m[1]}_spec.rb" }
  # watch('app/models/identity.rb') do
  #   400.times do
  #     puts "RESTART guard because STI doesn't play well with others"
  #   end
  #   sleep 10
  # end
  # watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { "spec/requests" }
  # watch('spec/spec_helper.rb')                        { "spec" }
  # watch('spec/factories.rb')                          { "spec" }
  # watch('config/routes.rb')                           { "spec/routing" }
  # watch('app/controllers/application_controller.rb')  { "spec/requests" }

  # watch(%r{^app/assets/javascripts/(.+)\.js})         { "spec/requests" }

  # # Capybara request specs
  # watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end

# guard 'livereload' do
#   # default rails 3.1
#   watch(%r{app/.+\.(erb|haml)})
#   watch(%r{app/helpers/.+\.rb})
#   watch(%r{(public/|app/assets).+\.(css|js|html)})
#   watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
#   watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
#   watch(%r{config/locales/.+\.yml})
# end

# guard 'rake', :task => 'copper:old_production' do
#  watch 'extras/migrate_to_new_schema.rb'
# end
