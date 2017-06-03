#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -u
set -x

# required shell params
: "${YUM_HOST:?"should not be empty"}"

# git
yum install -y git

# epel
rpm -qa epel-release* | egrep -q epel-release || {
    rpm -Uvh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/i386/epel-release-6-8.noarch.rpm
    sed -i \
	-e 's,^#baseurl,baseurl,' \
	-e 's,^mirrorlist=,#mirrorlist=,' \
	-e 's,http://download.fedoraproject.org/pub/epel/,http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/,' \
	/etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
    yum install -y ca-certificates
}
yum repolist

# update libcurl
rpm -Uvh http://www.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-1-13.rhel6.noarch.rpm
sed -i "s,enabled=1,enabled=0," /etc/yum.repos.d/city-fan.org.repo
yum update -y --enablerepo=city-fan.org libcurl

# install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
# setup rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec $SHELL -l

# install build require for ruby-build
yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel libffi-devel

# install ruby-build
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# install ruby
ruby_version="2.2.2"

rbenv install -v "${ruby_version}"
rbenv rehash
rbenv versions
rbenv global "${ruby_version}"
ruby -v

# install bundler
gem install bundler --no-ri --no-rdoc


