# Generator inspired by R.Bates' Episode 148

# README initialization 
run 'echo -n "(c) G.Betous " > README'
run 'date +%Y >> README'

# database.yml initialization
run "cp config/database.yml config/example_database.yml"  

# git initialization
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"  
git :init  
git :add => "."
git :commit => "-m 'initial commit from template generator'"

file '.gitignore', <<-END  
.DS_Store  
log/*.log  
tmp/**/*  
config/database.yml  
db/*.sqlite3  
END

# Welcome controller
if yes?("Do you want a Welcome controller ?")
  generate :controller, "welcome index"  
  route "map.root :controller => 'welcome'"  
  git :rm => "public/index.html"  
  git :add => "."
  git :commit => "-m 'adding welcome controller.'"
end