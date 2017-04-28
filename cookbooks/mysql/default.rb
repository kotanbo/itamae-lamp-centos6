package "mysql-community-server" do
  options "--enablerepo='mysql57-community*'"
end

service "mysqld" do
  action [:enable, :start]
end

execute "set mysql root password" do
  user "root"
  command <<-EOS
    tmp_pass=$(grep 'temporary password' /var/log/mysqld.log | awk -F'root@localhost: ' '{print $2}') &&
    mysql -u root -p"$tmp_pass" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '#{node.mysql.root_password}';"
  EOS
  not_if "mysql -u root -p#{node.mysql.root_password} -e 'show databases' | grep information_schema"
end

execute "backup mysql my.cnf" do
  user "root"
  command "cp /etc/my.cnf /etc/my.cnf.org"
  not_if "test -f /etc/my.cnf.org"
end

service "mysqld" do
  action :restart
end
