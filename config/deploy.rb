# In all comments :stage represents the stage you want to use (i.e. production, staging, etc.)

# Follow these steps AFTER modifying your /etc/apache2/httpd.conf file to add a new rails instance and running `sudo apachectl restart`
# Steps to setup capistrano for the first time:
# - cap :stage deploy:setup                 # this creates the correct directory tree
# - cap :stage deploy:check                 # this checks to make sure setup ran
# - cap :stage deploy:update                # this updates the server with the app code
# - ssh :user@:main_server                  # fill in the correct user and server here
# - cd :deploy_to/current                   # again fill in the correct deploy to dir
# - RAILS_ENV=:stage sudo rake gems:install # this installs gems that need native compiling
# - RAILS_ENV=:stage rake db:schema:load    # loads the database
# - RAILS_ENV=:stage rake db:seed           # loads any seed data
# - script/console :stage                   # load the console for testing
# - app.get('/')                            # test to see if this returns '200'
# - exit                                    # exit the console
# - exit                                    # exit ssh
# - cap :stage deploy:restart               # kickstart the server

# The following MUST be defined in the /config/deploy/:stage.rb file:
# default_environment['PATH']= # This is the $PATH environment variable for the host systems
# set :application_directory   # This is the directory being deployed to in the deployment environment
# set :rails_env               # This is the $RAILS_ENV environment variable, should be the same as the stage name
# set :main_server             # This is the name of the main server we will be deploying on

# Enable multi-stage support
require 'capistrano/ext/multistage'

# don't use sudo
set :use_sudo, false

# Stage definitions
set :stages,        %w(staging production)
set :default_stage, "staging"

# Deployment environment information
set :application, "weave"
set :user,        "flb"
set :deploy_via,  :remote_cache

# Git information
set :scm,                   :git
set :branch,                'master'
set :git_user,              'flb'
set :git_domain,            'fasterlighterbetter.com'
set :repository,            "#{git_user}@#{git_domain}:~/git/site_hub.git"

# For Explanation: http://www.mail-archive.com/capistrano@googlegroups.com/msg02817.html
default_run_options[:pty] = true

# Deployment tasks
namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "restart mod_rails instance"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
