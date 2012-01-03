# create rvmrc file
create_file ".rvmrc", "rvm gemset use #{app_name}"

# authentication and authorization
gem "devise"
gem "cancan"

# rspec, factory girl, webrat, autotest for testing
gem "rails3-generators", :group => [ :development ]
gem "rspec-rails", :group => [ :development, :test ]
gem "factory_girl_rails", :group => [ :development, :test ]
gem "therubyracer"

run 'bundle install'

rake "db:create", :env => 'development'
rake "db:create", :env => 'test'

generate 'rspec:install'
inject_into_file 'spec/spec_helper.rb', "\nrequire 'factory_girl'", :after => "require 'rspec/rails'"
inject_into_file 'config/application.rb', :after => "config.filter_parameters += [:password]" do
  <<-eos
    
    # Customize generators
    config.generators do |g|
      g.stylesheets false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  eos
end

# authentication and authorization setup
generate "devise:install"
generate "devise User"
generate "devise:views"
rake "db:migrate"
generate "cancan:ability"

# clean up rails defaults
remove_file 'public/index.html'
remove_file 'rm public/images/rails.png'
run 'cp config/database.yml config/database.example'
run "echo 'config/database.yml' >> .gitignore"

# commit to git
git :init
git :add => "."
git :commit => "-a -m 'create initial application'"

say <<-eos
  ============================================================================
  Your new Rails application is ready to go.
  
  Don't forget to scroll up for important messages from installed generators.
eos

