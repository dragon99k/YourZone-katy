server '43.207.153.156', port: 22, roles: [:web, :app, :db], primary: true
set :repo_url, "git@bitbucket.org:dekisugi2512/warashibe.git"
set :stage, :staging
set :branch, :master
