Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu"

  config.vm.define "worker1" do |worker1|
    worker1.vm.network "public_network", ip: "192.168.80.101"
    worker1.vm.hostname = "worker1"
    worker1.vm.provision "shell", path: "scripts/worker.sh"
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.network "public_network", ip: "192.168.80.102"
    worker2.vm.hostname = "worker2"
    worker2.vm.provision "shell", path: "scripts/worker.sh"
  end

  config.vm.define "worker3" do |worker1|
    worker3.vm.network "public_network", ip: "192.168.80.103"
    worker3.vm.hostname = "worker3"
    worker3.vm.provision "shell", path: "scripts/worker.sh"
  end

  config.vm.define "master" do |master|
    master.vm.network "public_network", ip: "192.168.80.100"
    master.vm.hostname = "master"
    master.vm.provision "shell", path: "scripts/master.sh"
  end
end
