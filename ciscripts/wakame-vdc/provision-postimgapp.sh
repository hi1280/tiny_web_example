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

# install tiny-web-example.repo
cat <<-EOS > /etc/yum.repos.d/tiny-web-example.repo
[tin-web-example]
name=tiny-web-example
baseurl=http://${YUM_HOST}/pub/
enabled=1
gpgcheck=0
EOS

# show available repo list
yum repolist

# install tiny-web-example.rpm
yum install -y tiny-web-example

## /etc/default/tiny-web-example-webapi
cat <<-'EOS' > /etc/default/tiny-web-example-webapi
	# tiny-web-example
	EXAMPLE_ROOT=/opt/axsh/tiny-web-example
	PATH=/root/.rbenv/shims:$PATH

	# Commnet out to run the vdc init script.
	#RUN=yes

	## rack params
	RACK_ENV=development
	BIND_ADDR=0.0.0.0
	PORT=8080
	UNICORN_CONF=/etc/tiny-web-example/unicorn-common.conf
	EOS

## /etc/default/tiny-web-example-webapp
cat <<-'EOS' > /etc/default/tiny-web-example-webapp
	# tiny-web-example
	EXAMPLE_ROOT=/opt/axsh/tiny-web-example
	PATH=/root/.rbenv/shims:$PATH

	# Commnet out to run the vdc init script.
	#RUN=yes

	## rack params
	RACK_ENV=development
	BIND_ADDR=0.0.0.0
	PORT=80
	UNICORN_CONF=/etc/tiny-web-example/unicorn-common.conf
	EOS
