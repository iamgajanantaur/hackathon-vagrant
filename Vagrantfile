Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu"

  config.vm.define "worker1" do |worker1|
    worker1.vm.network "private_network", ip: "192.168.10.113"
    worker1.vm.hostname = "worker1"
    worker1.vm.provision "shell", path: "scripts/worker.sh"
  end

  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: "192.168.10.112"
    master.vm.hostname = "master"
    master.vm.provision "shell", path: "scripts/master.sh"
  end
end
