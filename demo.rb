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

# Application template
file 'app/views/layouts/application.html.erb', <<-CODE
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title><%= yield :title %></title>
<%= stylesheet_link_tag "site.css" %>
</head>

<body>
  <%= render :partial => "shared/menu" %>

  <% flash.each do |key, msg| %>
    <%= content_tag :div, msg, :id => key %>
  <% end %>

  <%=yield%>

  <%= render :partial => "shared/footer" %>
</body>

</html>
CODE

file 'app/views/shared/_menu.html.erb', <<-CODE
(menu)
CODE

file 'app/views/shared/_footer.html.erb', <<-CODE
<hr />
CODE

file 'public/stylesheets/site.css', <<-CODE
body
{
  font-size:75%;
  font-family:verdana,arial,'sans serif';
  background-color:#FFFFF0;
  color:#505050;
  margin:10px;
}
CODE

# Welcome controller
if yes?("Do you want a Welcome controller ?")
  generate :controller, "welcome index"  
  route "map.root :controller => 'welcome'"  
  git :rm => "public/index.html"  
  git :add => "."
  git :commit => "-m 'adding welcome controller.'"
end


# Authlogic 
if yes?("Do you want to use Authlogic ?")

  TEMPLATES = "/home/guillaume/src/template"
   
  load_template("#{TEMPLATES}/authlogic.rb")

  git :add => "."
  git :commit => "-m 'adding authlogic'"

  rake('db:migrate')
end
