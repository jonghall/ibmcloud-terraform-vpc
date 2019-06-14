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
 - mkdir /var/www
 - cd /var/www
 - sudo wget http://wordpress.org/latest.tar.gz
 - sudo tar xzvf latest.tar.gz
 - cd /var/www/wordpress
 - sudo cp wp-config-sample.php wp-config.php
 - sudo chown -R www-data:www-data /var/www/wordpress
 - sudo find /var/www/wordpress -type d -exec chmod g+s {} \;
 - sudo chown -R www-data:www-data /var/www/wordpress
 - sudo chmod g+w /var/www/wordpress/wp-content
 - sudo chmod -R g+w /var/www/wordpress/wp-content/themes
 - sudo chmod -R g+w /var/www/wordpress/wp-content/plugins
 - sudo apt-get install unit unit-php unit-python2.7 unit-python3.5 unit-go unit-perl unit-ruby unit-dev unit-jsc-common unit-jsc8 unit-php --yes
 - sudo service unit restart
 - sudo curl -X PUT --data-binary @/usr/share/doc/unit-php/examples/unit.config --unix-socket /run/control.unit.sock http://localhost/config
 - cd /etc/nginx/conf.d
 - sudo systemctl enable unit
 - sudo systemctl enable nginx
 - sudo ngninx -s reload
 - reboot
 EOF
  }
}
