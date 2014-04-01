FROM ubuntu:precise
MAINTAINER "marshall@yountlabs.com"

# update packages
RUN apt-get update
# install editors
RUN apt-get -y install vim tmux emacs apache2-mpm-worker mysql-server redis-server mysql-client libmysql-ruby libmysqlclient-dev build-essential git-core curl nodejs

# install RVM
# adapted from http://www.powpark.com/blog/programming/2013/11/11/using-docker-and-vagrant-on-mac-osx-for-a-ruby-on-rails-app/
RUN curl -L https://get.rvm.io | bash -s stable
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc

RUN /bin/bash -l -c 'rvm install 2.1.0'
RUN /bin/bash -l -c 'rvm use 2.1.0 --default'

WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
ADD .ruby-version /tmp/.ruby-version
ADD .ruby-gemset /tmp/.ruby-gemset
# must upgrade bundler to 1.5.1+ or minitest will not install
RUN /bin/bash -l -c 'gem install bundler'
RUN /bin/bash -l -c 'bundle install -j2'

EXPOSE 3000
CMD "bin/docker_entrypoint.sh"
