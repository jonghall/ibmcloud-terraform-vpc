# Deploying the VPC Infrastructure using Terraform
A typical use case for a Virtual Private Cloud (VPC) is the ability to logically isolate an application running on the public cloud from other applications and environments.  Additionally many
application architectures require different tiers to isolate and secure critical aspects of the application.   An application may also need to leverage different availability zones
to increase the overall resilience of the application.   However, building these required constructs for the network and security across VPC's, Availability Zones, and the individual network subnets
can be tedious to implement manually.   Additionally today's development cycles often require quick turn around and frequent updates driving the need for automation.

[HashiCorp's Terraform](https://www.terraform.io/) makes defining your cloud infrastructure in code possible.   Using the [IBM Cloud Terraform Provider](https://github.com/IBM-Cloud/terraform-provider-ibm)
simplifies the provisioning and management of infrastructure in the IBM Cloud using Terraform by automating and saving the state of VPCs, security-groups, network acls, subnets, compute resources,
load balancers and VPN endpoints across the desired availability zones within and accross the regions specified.

## vpc-ibm-terraform-provider
This project is currently based on Terraform v0.11.14 and the IBM Cloud Terraform Provider v.0.17.1.
This provider can be found at: [https://github.com/IBM-Cloud/terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

Documentation for the IBM provider can be found at: [https://ibm-cloud.github.io/tf-ibm-docs/v0.17.1/](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.1/)

## Steps to modify sample Terraform Plan

1. [Download and install Terraform for your system](https://www.terraform.io/intro/getting-started/install.html). 

2. [Download the IBM Cloud provider plugin for Terraform](https://github.com/IBM-Bluemix/terraform-provider-ibm/releases).

3. Unzip the release archive to extract the plugin binary (`terraform-provider-ibm_vX.Y.Z`).

4. Move the binary into the Terraform [plugins directory](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins) for the platform.
    - Linux/Unix/OS X: `~/.terraform.d/plugins`
    - Windows: `%APPDATA%\terraform.d\plugins`

6. Modify [variables.tf](../variables.tf) for the following variables:
    - Change `vpc-name` to the desired VPC name.  This must be unique within your account
    - Change `resource_group` to an existing resource_group in your account
    - Change `cis_resource_group` to the resource group that your CIS instance exists in
    - Change `address-pregix-vpc` to the desired CIDR block for the VPC.  Though technically not requires to be on contiguous block this simplifies the network-acls and VPN setup
    - Change `address-prefix-1` and `address-prefix-2` to the desired CIDR blocks for each availability zone
    - Change `webapptier`, `dbtier`, and `VPN` subnet CIDR blocks for Zone 1 and Zone 2.  These must be from within Zone 1 and Zone 2 address-prefix blocks
    - Change `domain` and `dns_name` to the application URL which will be registered with the Global Load Balancer
    - Change `cis_instance_name` to the Cloud Internet Services service instance
    - Change `ssh_public_key` to the directory of the public SSH key you wish to use for all server creation
    - Change `webappserver-name` and `dbserver-name` to the desired hostname prefix for provisioned servers
    - change `webappserver-count` and `dbserver-count` to the desired quantity of each server in each zone
    - change `onprem_vpn_ip_address` to the public IP of your on prem VPN concentrator.  If  behind a NAT device leave as `0.0.0.0`
    - change `onprem_cidr` CIDR block of your onprem network
    - change `vpn-preshared-key` to the desired pre-shared-key witch will be used for the VPN connection to your VPC

7. (optional) Tailor profiles, images, etc as needed in `variables.tf`

8. (optional) Review and change the following Terraform files as needed.

    - [main.tf](../main.tf) defines  the VPC and network constructs such as address-blocks, subnets, and Gateways for VPC 
    - [network-acls.tf](../network-acls.tf) defines the ACLS assigned to the subnets
    - [securitygroups.tf](../securitygroups.tf) defines the security groups for the webapptier and dbtier.
    - [compute.tf](../compute.tf) provisions the webapptier and dbtier virtual servers
    - [cloud-init-dbtier.tf](../cloud-init-dbtier.tf) defines the cloud-init configuration for the dbtier servers
    - [cloud-init-webapptier.tf](../cloud-init-webapptier.tf) defines the cloud-init configuration for the webapptier servers
    - [lbaas.tf](../lbaas.tf) defines the Load Balancers, Listeners, and Pools of servers for the web application
    - [cis.tf](../cis.tf) defines the Global Load Balancer, Listeners, and Pools, DDOS Proxy and registers the URL with DNS
    - [vpn.tf](../vpn.tf) defines the VPN service and connections from on-prem to the VPC
    - [provider.tf](../provider.tf) defines the Terraform provider required variables
    - [output.tf](../output.tf) defines what information is output upon completion of plan
    
9. Issue the following Terraform commands to execute the plan

    - To initialize Terraform and the IBM Cloud provider in the current directory.  You must also export environment variables for
    the desired region and generation you wish to provision the VPC in, and provide your API key.
    
    ```shell
    export IC_REGION="us-south"
    export IC_GENERATION="1"
    export IC_API_KEY="api_key"
    terraform init
    ```
    
    - To review the plan for the configuration defined (no resources actually provisioned) 
    
    ```shell
    terraform plan
    ```
    
    - To execute and start building the configuration defined in the plan (provisions resources)
    
    ```shell
    terraform apply
    ```
    
    - To destroy the VPC and all related resources
    
    ````shell
    terraform destroy
    ````
    
10. Once the Terraform plan has completed building the Infrastructure proceed to [Establish site-to-site VPN](vpn.md)