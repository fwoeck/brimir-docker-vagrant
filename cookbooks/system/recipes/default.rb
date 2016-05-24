# Cookbook Name:: system
# Recipe:: default

bash 'apt_get_upgrade' do
  user 'root'
  code <<-EOH
    apt-get update
    apt-get -y dist-upgrade
    touch /root/.apt_upgrade_finished
  EOH

  not_if "test -e /root/.apt_upgrade_finished"
end

node[:apt][:debs].each { |pkg|
  package pkg do
    options '--no-install-recommends'
  end
}

bash 'install_python_pip' do
  user 'root'
  code 'easy_install pip'
  not_if 'pip --version | grep -q "pip 8"'
end

node[:python][:eggs].each do |egg|
  bash "install_python_#{egg}" do
    user 'root'
    code "pip install #{egg}"

    not_if "pip show #{egg[/[^=]+/]} 2>&1 | grep -qi #{egg[/[^=]+/]}"
  end
end

bash 'install_docker' do
  user 'root'
  code <<-EOH
    groupadd docker
    gpasswd -a #{node[:users][:sudoer]} docker
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list
    apt-get update
  EOH

  not_if "dpkg -l docker-engine | grep -q '^ii'"
end

package 'docker-engine'

service 'docker' do
  action [:enable, :start]
  supports restart: true, stop: true, start: true
end

bash 'install_docker_machine' do
  user 'root'
  code <<-EOH
    curl -qL https://github.com/docker/machine/releases/download/v#{node[:docker][:machine_vers]}/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
    chmod +x /usr/local/bin/docker-machine
  EOH

  not_if "/usr/local/bin/docker-machine --version | grep -q #{node[:docker][:machine_vers]}"
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, "service[nginx]", :delayed
end

directory '/etc/nginx/sites-available' do
  owner 'root'
  group 'root'
end

directory '/etc/nginx/sites-enabled' do
  owner 'root'
  group 'root'
end

cookbook_file '/etc/nginx/sites-available/default' do
  source 'default'
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, "service[nginx]", :delayed
end

link '/etc/nginx/sites-enabled/default' do
  to '/etc/nginx/sites-available/default'
end

service 'nginx' do
  action [:enable, :start]
  supports restart: true, stop: true, start: true
end

remote_directory "/home/#{node[:users][:sudoer]}/brimir" do
  source 'brimir'
  owner node[:users][:sudoer]
  group node[:users][:sudoer]
  mode '0755'

  not_if { File.exist? "/home/#{node[:users][:sudoer]}/brimir" }
end

bash 'build_brimir_docker' do
  user node[:users][:sudoer]
  group 'docker'

  code <<-EOH
    export HOME=/home/#{node[:users][:sudoer]}
    cd $HOME/brimir
    sudo chown -R #{node[:users][:sudoer]}: .
    sudo chmod +x *.sh
    ./setup.sh
  EOH

  not_if { File.exist? "/home/#{node[:users][:sudoer]}/brimir/brimir/app" }
end

bash 'run_brimir_docker' do
  user node[:users][:sudoer]
  group 'docker'

  code <<-EOH
    export HOME=/home/#{node[:users][:sudoer]}
    cd $HOME/brimir
    ./run_server.sh
  EOH
end
