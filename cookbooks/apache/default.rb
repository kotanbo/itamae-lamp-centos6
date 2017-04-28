package "httpd"
 
execute "backup apache httpd.conf" do
  user "root"
  command "cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.org"
  not_if "test -f /etc/httpd/conf/httpd.conf.org"
end

file "/etc/httpd/conf/httpd.conf" do
  user "root"
  action :edit
  block do |content|
    content.gsub!("AllowOverride None", "AllowOverride All")
  end
  only_if "test -f /etc/httpd/conf/httpd.conf"
end
 
execute "add www user" do
  user "root"
  command <<-EOS
    useradd www
    gpasswd -a apache www
    chown -R www:www /var/www/html
  EOS
end

service "httpd" do
  action [:enable, :start]
end
