include_recipe "../cookbooks/system/default.rb"
include_recipe "../cookbooks/vim/default.rb"
include_recipe "../cookbooks/yum/default.rb"
include_recipe "../cookbooks/apache/default.rb"
include_recipe "../cookbooks/php/default.rb"
include_recipe "../cookbooks/mysql/default.rb"

service "httpd" do
  action [:enable, :start, :restart]
end
