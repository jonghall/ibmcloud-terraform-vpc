data "template_cloudinit_config" "cloud-init-webtier" {
  base64_encode = false
  gzip          = false

  part {
    content = <<EOF
#cloud-config
manage_etc_hosts: true
package_upgrade: true
packages:
- locales
- build-essential
- acl
- ntp
- htop
- git
- supervisor
- python-pip
- python3-pip
- nginx

runcmd:
 - echo "deb https://repo.logdna.com stable main" | sudo tee /etc/apt/sources.list.d/logdna.list
 - wget -O- https://repo.logdna.com/logdna.gpg | sudo apt-key add -
 - sudo apt-get update
 - sudo apt-get install logdna-agent < "/dev/null"
 - sudo logdna-agent -k logdnakey
 - sudo logdna-agent -s LOGDNA_APIHOST=api.us-south.logging.cloud.ibm.com
 - sudo logdna-agent -s LOGDNA_LOGHOST=logs.us-south.logging.cloud.ibm.com
 - sudo logdna-agent -t webapp-demo
 - sudo update-rc.d logdna-agent defaults
 - sudo /etc/init.d/logdna-agent start
 - '\curl -sL https://ibm.biz/install-sysdig-agent | sudo bash -s -- -a sysdig_account -c ingest.us-south.monitoring.cloud.ibm.com --collector_port 6443 --secure true -ac "sysdig_capture_enabled: fals
EOF
  }
}
