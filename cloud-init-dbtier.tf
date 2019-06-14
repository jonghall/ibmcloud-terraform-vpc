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
- python3-pymysql

runcmd:
 - reboot
 EOF
  }
}
