guard 'process', :name => 'worker', :command => 'rake jobs:work', :stop_signal => 'TERM' do
  # watch('Gemfile')
  # watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  # watch('config/routes.rb')
  watch('config/authorization_rules.rb')
  watch(%r{^config/environments/.+\.rb})
  watch(%r{^config/initializers/.+\.rb})
  watch('/app/models/**/*.rb')
  watch('/app/models/*.rb')
  watch('/app/jobs/*.rb')
  watch('/lib/**/*.rb')
end

guard 'process', :name => 'web', :command => 'rails s thin', :stop_signal => 'TERM' do
  # watch('Gemfile')
  # watch('Gemfile.lock')
  # watch('config/application.rb')
  # watch('config/environment.rb')
  # watch('config/routes.rb')
  # watch('config/authorization_rules.rb')
  # watch(%r{^config/environments/.+\.rb})
  # watch(%r{^config/initializers/.+\.rb})
  # watch('/app/**/*.rb')
  # watch('/lib/**/*.rb')
end

guard :pow do
  watch('.rvmrc')
  watch(%r{^\.pow(rc|env)$})
  watch('Gemfile.lock')
  watch(%r{^config/.+\.rb$})
end

guard 'spork', wait: 60, cucumber: false, rspec: true, test_unit: false do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb})
  watch(%r{^config/initializers/.+\.rb})
  watch('spec/spec_helper.rb')
  watch('spec/support.rb')
  watch('.rspec')
end

guard 'rspec', :cli => '--color --format doc --drb',
               :all_on_start => false, :all_after_pass => false do
  watch(/^spec\/.+\.rb$/) { 'spec' }
  watch(/^app\/.+\.rb$/) { 'spec' }
  watch(/^lib\/.+\.rb$/) { 'spec' }
  watch(/^config\/.+\.rb$/) { 'spec' }
  watch(%r{(public/|app/assets|app/views).+\.(js|html|coffee|erb|json)}) {'spec/requests'}
end

guard 'livereload' do
  # default rails 3.1
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html|svg)})
  watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end