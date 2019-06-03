## IBMCLOUD-TERRAFORM-VPC-NTIER-PLAN
A typical requirement for a Virtual Private Cloud (VPC) is the ability to logically isolate a public cloud into different private networks made up tiers and/or different applications environments.
Within each VPC your application leverage different availability zones to increase the resilience of the application.   Building the required construct for the network and security across VPC's,
Availability Zones, and the individual network subnets with each can be tedious to implement manually.

The IBM Cloud Terraform provider can simplify the provisioning and management of the infratsructure easier.    The included Terraform plan enables the creation of the specified VPC, security-groups, network acls,
subnets, compute resources and the required public and private load balancers across the desired availability zones within the region specified.

## Typical Application Topology
A typical Ecommerce web app deployed across 2or 3 availability zones, each consisting of 2 or 3 segmented network tiers for different application functions such as static web serving, application hosting,
and databases.   Often capabilities like Cloud Object Storage are used for static images/media, and cloud databases are used for sessions data or search.  Addition a VPN is often required for
on-premise API services or management of the cloud infrastructure.    To logically isolate environments, Separate VPCs are created to completely isolate PROD from other DEV and test environments.  

![](topology.png?raw=true)


# vpc-ibm-terraform-provider
This project is currently for documentation purposes and is based on v.0.17.0 version the IBM Cloud Terraform provider which has not yet been merged with the public provider.
This provider can be found at: https://github.com/IBM-Cloud/terraform-provider-ibm

Documentation https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/

The v.0.17.0 add support for:   

## Current support

* IBM IS Virtual Private Cloud (ibm_is_vpc)
* IBM IS Virtual Private Cloud Address Prefix (ibm_is_vpc_address_prefix)
* IBM IS Floating IP (ibm_is_floating_ip)
* IBM IS Instance (ibm_is_instance)
* IBM IS Public Gateway (ibm_is_public_gateway)
* IBM IS Network ACL (ibm_is_network_acl)
* IBM IS Security Group (ibm_is_security_group)
* IBM IS Security Group Rule (ibm_is_security_group_rule)
* IBM IS Security Group Network Interface Attachment (ibm_is_security_group_network_interface_attachment)
* IBM IS Subnet (ibm_is_subnet)
* IBM IS SSH Key (ibm_is_ssh_key)
* IBM IS VPN Gateway (ibm_is_vpn_gateway)
* IBM IS VPN Gateway (ibm_is_vpn_gateway_connection)
* IBM IS IKE Policy (ibm_is_ike_policy)
* IBM IS IPSec Policy (ibm_is_ip_sec_policy)
* IBM IS load balancer (ibm_is_lb)
* IBM IS load balancer listener (ibm_is_lb_listener) ** not working
* IBM IS load balancer pool (ibm_is_lb_pool)
* IBM IS load balancer pool memeber(ibm_is_lb_pool_member) ** not working

# Configuring your n-tiered VPC

* Configure your terraform.tfvars with your IBM Cloud credential

* Modify variables located in the variable.tf file.

    * DEFINE VPC section defines the name and location of VPC
    * DEFINE Zones section defined the zones to be used.
    * DEFINE CIDR Blocks section defines the CIDR blocks used in each zone
    * DEFINE Subnets Section(s) defines the subnet and subnet mask for each subnet in each zone.
    * DEFINE OS & SSHKEY define common attributes for compute instances
    * DEFINE Webtier, AppTier and DB Tier profiles allow you to configure profiles for each, the quantity, and name template.
    * DEFINE Load Balancer section allow you to configure the webtier LBaaS
    * DEFINE VPNaaS section allows you to configure a site-to-VPN connection

* Modify network ACLs for each subnet in the network-acls.tf file.
* Modify Security Group rules for each tier in the securitygroups.tf file.
* Modify GLB configuration in the cis.cf file.
* Modify the cloud-init-*.tf files to customize post provisioning installation and configuration

# Execute plan with Terraform
For planning phase

```shell
terraform plan
```

For apply phase

```shell
terraform apply
```

For destroy

```shell
terraform destroy
```
