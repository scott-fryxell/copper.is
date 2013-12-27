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

guard 'process', :name => 'web', :command => 'rails s -p 3001', :stop_signal => 'TERM' do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('config/routes.rb')
  watch('config/authorization_rules.rb')
end

guard 'spork', wait: 20, cucumber: false, rspec: true, test_unit: false do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb})
  watch(%r{^config/initializers/.+\.rb})
  watch('spec/spec_helper.rb')
  watch('spec/factories.rb')
  watch('.rspec')
end

guard 'rspec', cli:'--color --format doc --drb', all_on_start:false, all_after_pass:false do
  watch(/^spec\/.+\.rb$/) { 'spec' }
  watch(/^app\/.+\.rb$/) { 'spec' }
  watch(/^lib\/.+\.rb$/) { 'spec' }
  watch(/^config\/.+\.rb$/) { 'spec' }
  watch(%r{(public/|app/assets|app/views).+\.(js|html|coffee|erb|json)}) {'spec/requests'}
end

guard :livereload do
  watch(%r{^app/.+\.(erb|haml|js|css|scss|sass|coffee|svg|png|gif|jpg)})
  watch(%r{^app/helpers/.+\.rb})
  watch(%r{^public/.+\.html})
  watch(%r{^config/locales/.+\.yml})
end
