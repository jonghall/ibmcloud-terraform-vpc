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
 - echo "deb https://repo.logdna.com stable main" | sudo tee /etc/apt/sources.list.d/logdna.list
 - wget -O- https://repo.logdna.com/logdna.gpg | sudo apt-key add -
 - sudo apt-get update
 - sudo apt-get install logdna-agent < "/dev/null"
 - sudo logdna-agent -k cfb5a2306a83917968afc44d4691cf6b
 - sudo logdna-agent -s LOGDNA_APIHOST=api.us-south.logging.cloud.ibm.com
 - sudo logdna-agent -s LOGDNA_LOGHOST=logs.us-south.logging.cloud.ibm.com
 - sudo logdna-agent -t databases
 - sudo update-rc.d logdna-agent defaults
 - sudo /etc/init.d/logdna-agent start

 - '\curl -sL https://ibm.biz/install-sysdig-agent | sudo bash -s -- --access_key 94563265-2cea-4c3a-938f-36539f8fa3ee  -c ingest.us-south.monitoring.cloud.ibm.com --collector_port 6443 --secure true -ac "sysdig_capture_enabled: false" --tags role:database'
 - reboot
 EOF
  }
}
