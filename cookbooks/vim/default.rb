package "vim"

execute "backup vimrc" do
  user "root"
  command <<-EOS
    cp /etc/vimrc /etc/vimrc.org
  EOS
  not_if "test -f /etc/vimrc.org"
end
execute "init vimrc" do
  user "root"
  command <<-EOS
    rm -f /etc/vimrc
    cp /etc/vimrc.org /etc/vimrc
  EOS
  only_if "test -f /etc/vimrc.org"
end
file "/etc/vimrc" do
  user "root"
  action :edit
  block do |content|
    content << File.read(File.expand_path('../files/etc/vimrc', __FILE__))
  end
  only_if "test -f /etc/vimrc.org"
end
