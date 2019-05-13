data "template_cloudinit_config" "cloud-init-dbtier" {
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
- supervisor
- python3
- python-pip
- python3-pip
- mysql-client
- mysql-server

runcmd:
 - echo "deb https://repo.logdna.com stable main" | sudo tee /etc/apt/sources.list.d/logdna.list
 - wget -O- https://repo.logdna.com/logdna.gpg | sudo apt-key add -
 - sudo apt-get update
 - sudo apt-get install logdna-agent < "/dev/null"
 - sudo mysql -u root -Bse "CREATE DATABASE wordpress;"
 - sudo mysql -u root -Bse "CREATE USER wpuser;"
 - sudo mysql -u root -Bse "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wpuser@'%' IDENTIFIED BY 'DBpassword';"
 - sudo mysql -u root -Bse "FLUSH PRIVILEGES;"
 - sudo logdna-agent -k logdnakey
 - sudo logdna-agent -s LOGDNA_APIHOST=api.us-south.logging.cloud.ibm.com
 - sudo logdna-agent -s LOGDNA_LOGHOST=logs.us-south.logging.cloud.ibm.com
 - sudo logdna-agent -t webapp-demo
 - sudo update-rc.d logdna-agent defaults
 - sudo /etc/init.d/logdna-agent start
 - sudo sed -i "s/^\(bind-address\s*=\s*\).*\$/\0.0.0.0/" mysqld.cnf
 - reboot
 EOF
  }
}
