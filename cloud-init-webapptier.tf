data "template_cloudinit_config" "cloud-init-webapptier" {
  base64_encode = false
  gzip          = false

  part {
    content = <<EOF
#cloud-config
apt:
  primary:
    - arches: [default]
      uri:  http://mirrors.adn.networklayer.com/ubuntu
package-update: true
package_upgrade: true
packages:
- locales
- build-essential
- acl
- ntp
- htop
- git
- unzip
- supervisor
- python-pip
- python3-pip
- nginx
- mysql-client
- php7.0
- php7.0-common
- php7.0-mbstring
- php7.0-gd
- php7.0-intl
- php7.0-xml
- php7.0-mcryp
- php7.0-mysql
- php7.0-cli
- php7.0-cgi
- php7.0-gd

runcmd:
 - echo "deb https://packages.nginx.org/unit/ubuntu/ xenial unit" | sudo tee /etc/apt/sources.list.d/unit.list
 - echo "deb-src https://packages.nginx.org/unit/ubuntu/ xenial unit" | sudo tee -a /etc/apt/sources.list.d/unit.list
 - wget -O- https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
 - sudo apt-get update
 - sudo apt-get install unit unit-php unit-python2.7 unit-python3.5 unit-go unit-perl unit-ruby unit-dev unit-jsc-common unit-jsc8 unit-php --yes
 - reboot
 EOF
  }
}
