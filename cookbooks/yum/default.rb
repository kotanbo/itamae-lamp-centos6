package "epel-release"

package "http://rpms.famillecollet.com/enterprise/remi-release-#{node[:platform_version][0]}.rpm" do
  not_if "rpm -q remi-release"
end

package "http://dev.mysql.com/get/mysql57-community-release-el#{node[:platform_version][0]}-9.noarch.rpm" do
  not_if "rpm -q mysql57-community-release-el#{node[:platform_version][0]}-9"
end
