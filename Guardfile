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
  watch(/^spec\/.+\.rb$/) { 'spec' }
  watch(/^spec\/.+\.yml$/) { 'spec' }
  watch(/^app\/.+\.rb$/) { 'spec' }
  watch(/^lib\/.+\.rb$/) { 'spec' }
  watch(/^config\/.+\.rb$/) { 'spec' }

  watch('app/models/identity.rb') do
    puts; puts "RESTART guard because STI doesn't play well with others"
    Thread .current.kill # this is probably a bad idea
  end
end

guard 'livereload' do
  # default rails 3.1
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end

# guard 'rake', :task => 'copper:old_production' do
#  watch 'extras/migrate_to_new_schema.rb'
# end
