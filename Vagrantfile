APP_NAME = "your-app" || ENV["DOCKER_APP_NAME"]
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = APP_NAME

  config.vm.box = "docker-ubuntu-12.04.3-amd64-vbox"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.synced_folder ".", "/#{APP_NAME}"

  config.vm.provision "docker" do |d|
    d.pull_images "ubuntu"

    d.pull_images "tutum/mysql"
    d.run "tutum/mysql",
      args: '-e MYSQL_PASS="docker" -name mysql'

    d.pull_images "crosbymichael/redis"
    d.run "crosbymichael/redis",
      args: "-name redis"
    #
    # d.build_image "/#{APP_NAME}/.", args: "-t #{APP_NAME}/rails"
    # d.run "#{APP_NAME}/rails",
    #   args: "-link mysql:mysql -link redis:redis -v /#{APP_NAME}:/var/www/#{APP_NAME} -p 3000:3000"
  end

  cmd = <<SCRIPT
  # this builds the rails container
  docker build -t #{APP_NAME}/rails /#{APP_NAME}/.
  # and this actually kicks up the rails server
  # http://docs.docker.io/en/latest/use/working_with_volumes/#volume-def
  # http://docs.docker.io/en/latest/use/working_with_links_names/
  docker run --link=mysql:mysql --link=redis:redis -v /#{APP_NAME}:/var/www/#{APP_NAME} -p 3000:3000 #{APP_NAME}/rails
SCRIPT

  # docker run -i -link redis:db -link mysql:mysql -t rails /bin/bash
  # see http://stackoverflow.com/questions/21167531/how-do-i-provision-a-dockerfile-from-vagrant
  # after vagrant 1.5, can switch this out for d.build and d.run command
  config.vm.provision "shell", inline: cmd
end
