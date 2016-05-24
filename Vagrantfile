Vagrant.configure("2") do |config|

  config.vm.box = "bento/debian-8.4"
  config.vbguest.auto_update = false
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.nodes_path = "nodes"
    chef.roles_path = "roles"
    chef.add_recipe "system"
  end
end
