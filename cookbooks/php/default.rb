%w(php php-mbstring php-xml php-gd php-pear php-mysqlnd php-intl phpMyAdmin php-openssl mod_ssl).each do |pkg|
  package pkg do
    options "--enablerepo=remi-php56"
  end
end

execute "backup php.ini" do
  user "root"
  command "cp /etc/php.ini /etc/php.ini.org"
  not_if "test -f /etc/php.ini.org"
  only_if "test -f /etc/php.ini"
end

file "/etc/php.ini" do
  user "root"
  action :edit
  block do |content|
    content.gsub!(";date.timezone = ", "date.timezone = Asia/Tokyo")
  end
  not_if "grep - E '^date.timezone = Asia/Tokyo' /etc/php.ini"
  only_if "test -f /etc/php.ini"
end

file "/etc/php.ini" do
  user "root"
  action :edit
  block do |content|
    content.gsub!("session.gc_maxlifetime = 1440", "session.gc_maxlifetime = 86400")
  end
  not_if "grep '^session.gc_maxlifetime = 86400' /etc/php.ini"
  only_if "test -f /etc/php.ini"
end

execute "phpMyAdmin permission" do
  user "root"
  command "chown -R root:apache /usr/share/phpMyAdmin/"
end
 
execute "backup phpMyAdmin.conf" do
  user "root"
  command "cp /etc/httpd/conf.d/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf.org"
  not_if "test -f /etc/httpd/conf.d/phpMyAdmin.conf.org"
  only_if "test -f /etc/httpd/conf.d/phpMyAdmin.conf"
end

execute "backup phpMyAdmin config.inc.php" do
  user "root"
  command "cp /etc/phpMyAdmin/config.inc.php /etc/phpMyAdmin/config.inc.php.org"
  not_if "test -f /etc/phpMyAdmin/config.inc.php.org"
  only_if "test -f /etc/phpMyAdmin/config.inc.php"
end

file "/etc/httpd/conf.d/phpMyAdmin.conf" do
  user "root"
  action :edit
  block do |content|
    content.gsub!("Allow from ::1", "Allow from ::1\n     Allow from 192.168.")
  end
  not_if "grep 'Allow from 192.168.' /etc/httpd/conf.d/phpMyAdmin.conf"
  only_if "test -f /etc/httpd/conf.d/phpMyAdmin.conf"
end

file "/etc/phpMyAdmin/config.inc.php" do
  user "root"
  action :edit
  block do |content|
    content.gsub!("?>", "$cfg['LoginCookieValidity'] = 86400;\n?>")
  end
  not_if "grep 'LoginCookieValidity' /etc/phpMyAdmin/config.inc.php"
  only_if "test -f /etc/phpMyAdmin/config.inc.php"
end

execute "Composer install" do
  user "root"
  command <<-EOS
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '#{node.php.composer.installer_sha384}') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    mv composer.phar /usr/local/bin/composer
  EOS
end
