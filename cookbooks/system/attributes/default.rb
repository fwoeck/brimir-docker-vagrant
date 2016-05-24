default[:users][:sudoer]        = "vagrant"
default[:docker][:machine_vers] = "0.7.0"

default[:apt][:debs] = %w{
  apt-transport-https
  aptitude
  build-essential
  ca-certificates
  curl
  git
  haveged
  nginx
  pkg-config
  python-dev
  python-setuptools
  rsync
  silversearcher-ag
  ssh-askpass
  ssl-cert
  tmux
  tree
  unzip
  vim
  wget
  zip
}

default[:python][:eggs] = %w{
  docker-compose
}
