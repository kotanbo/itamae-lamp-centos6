# timezone設定
file "/etc/localtime" do
  action :delete
  only_if "test -e /etc/localtime"
end
link "/etc/localtime" do
  to "/usr/share/zoneinfo/Asia/Tokyo"
  not_if "test -e /etc/localtime"
end

# 言語設定
case node[:platform_version].to_i
when 7
  execute "set locale" do
    user "root"
    command <<-EOS
      localectl set-locale LANG=ja_JP.utf8
      source /etc/locale.conf
    EOS
  end
when 6
  execute "add locale" do
    user "root"
    command "localedef -f UTF-8 -i ja_JP ja_JP.utf8"
  end
  file "/etc/sysconfig/i18n" do
    action :edit
    user "root"
    block do |content|
      content.gsub!(/^LANG=.+/, 'LANG="ja_JP.UTF-8"')
    end
  end
end

# libcurl更新
package "http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-1-13.rhel#{node[:platform_version].to_i}.noarch.rpm" do
  not_if "rpm -q 'city-fan.org-release-1-13.rhel#{node[:platform_version].to_i}.noarch'"
end
file "/etc/yum.repos.d/city-fan.org.repo" do
  user "root"
  action :edit
  block do |content|
    content.gsub!("enabled=1", "enabled=0")
  end
end
execute "yum update -y --enablerepo=city-fan.org libcurl"

# firewalld停止、無効化
service "firewalld" do
	action [:stop, :disable]
end
