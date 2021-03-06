set :application, "wieners"
set :repository,  "git@github.com:railsrumble/rr10-team-156.git"
set :user, "theman"

set :scm, :git
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"

role :web, "ananasblau.com"
role :app, "ananasblau.com"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code", "deploy:link_shared_files"
after "deploy:update_code", "bundle:install"

namespace :bundle do
  task :install do
#    run "cd #{release_path}; #{try_sudo} bundle"
  end
end

namespace :deploy do
  desc "link shared files"
  task :link_shared_files, :roles => [:app] do
    %w(
      log
    ).each do |f|
      run "ln -nsf #{shared_path}/#{f} #{release_path}/#{f}"
    end
  end
end