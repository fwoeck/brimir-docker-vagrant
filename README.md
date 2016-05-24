# Brimir via Docker in a Vagrant driven VM

This example is not intended to be production-ready.  
It doesn't focus on security and contains some default credentials (e.g. in conf/secrets.yml or conf/database.yml).


## Requirements


#### VirtualBox incl. Extension Pack

Download: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)


#### Vagrant

Download: [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)


#### Vagrant Plugins

    > vagrant plugin install vagrant-omnibus vagrant-vbguest


## Initial Provisioning

    > git clone https://github.com/fwoeck/brimir-docker-vagrant.git
    > cd ./brimir-docker-vagrant
    > vagrant up --provision --provider virtualbox
    > vagrant ssh

    $ cd ./brimir
    $ ./run_console.sh
      u = User.new({email: 'admin@example.com', password: 'P4ssw0rd', password_confirmation: 'P4ssw0rd'})
      u.agent = true
      u.save!
      exit


## Web Server Access

[http://127.0.0.1:8080/users/sign_in](http://127.0.0.1:8080/users/sign_in)


## Stopping and Starting the outer VM

Stop the VM with:

    > vagrant halt

It's necessary to provision during each consecutive start, because the Docker containers are launched this way.
Of course, this would be better done by an internal tool (systemd, runit, ...):

    > vagrant up --provision