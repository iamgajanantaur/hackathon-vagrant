Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu"

  # Run worker setup only once
  config.vm.provision "shell", path: "scripts/worker.sh", run: "once"

  # Define the worker nodes
  ["worker1", "worker2", "worker3"].each_with_index do |name, index|
    config.vm.define name do |worker|
      worker.vm.network "public_network", ip: "192.168.80.#{101 + index}"
      worker.vm.hostname = name
    end
  end

  config.vm.define "master" do |master|
    master.vm.network "public_network", ip: "192.168.80.100"
    master.vm.hostname = "master"
    master.vm.provision "shell", path: "scripts/master.sh"
  end
end
