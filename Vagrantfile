VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "your-app"

  config.vm.box = "docker-ubuntu-12.04.3-amd64-vbox"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.synced_folder ".", "/your-app"

  config.vm.provision "docker" do |d|
    d.pull_images "ubuntu"

    d.pull_images "tutum/mysql"
    d.run "tutum/mysql",
      args: '-e MYSQL_PASS="docker" -name mysql'

    d.pull_images "crosbymichael/redis"
    d.run "crosbymichael/redis",
      args: "-name redis"
  end

  cmd = "docker build -t your-app/rails /your-app/.
        docker run --link=mysql:mysql --link=redis:redis -p 3000:3000 -t your-app/rails"

  config.vm.provision "shell", inline: cmd
end
