# Deploying a n-Tier Web App in a Virtual Private Cloud using Terraform & Ansible

## Purpose

The purpose of this project is to demonstrate, through the use of a reuseable asset, the concept of [Infrastructure as code](https://en.wikipedia.org/wiki/Infrastructure_as_code)
and how it can enable the ability to automate deployment facilitating a more consistent and faster development, testing, and deployment of workloads into a cloud, using the
[IBM Cloud VPC Infrastructure](https://www.ibm.com/cloud/vpc), [HashiCorp's Terraform](https://www.terraform.io/), and [Red Hat's Ansible](https://www.redhat.com/en/technologies/management/ansible).
  
A [n-tier](https://en.wikipedia.org/wiki/Multitier_architecture) architecture was chosen as a typical cloud workload for this example.   A n-tier architecture separates the web / application and data tiers
by placing them into separate sub-networks which are logically isolated using virtual network security constructs which can be defined and configured via an API.   [WordPress](https://wordpress.com),
a popular web, blog and e-commerce platform and [MySQL](https://www.mysql.com/), a typical open source database, installed on top of a [LAMP stack](https://en.wikipedia.org/wiki/LAMP) were chosen
as the core software stack because to their simplicity and broad acceptance.  [Nginx](https://www.nginx.com/) and [Nginx Unit](https://www.nginx.com/products/nginx-unit/) were chosen as the Web Server
and Application Servers respectively.

The main objectives of this project is to educate enterprise DevOps users and system administrators on how to leverage both the features of [IBM Cloud VPC Infrastructure](https://cloud.ibm.com/docs/vpc?topic=vpc-about-vpc) 
as well as how to use the [IBM Cloud Terraform Provider](https://github.com/IBM-Cloud/terraform-provider-ibm) and Ansible to deploy and fully configure a working n-tier application.

This automated approach leveraged previous [Solution Tutorials - Highly Available & Scalable Web App](https://cloud.ibm.com/docs/tutorials?topic=solution-tutorials-highly-available-and-scalable-web-application#use-virtual-servers-to-build-highly-available-and-scalable-web-app) documentation.

High Level Architecture

1. Infrastructure
  - Public Cloud isolation using a VPC
  - RFC1918 private bring-your-own-IP addresses
  - Application and data layers deployed on isolated subnets accross different availability zones
  - Network isolation defined logically using Security Groups and ACLs
  - Global DDOS and Global Load Balancing 
  - VPN-as-a-Service to establish remote secure connectivity between on-pream and the VPC
  - SysDig & LogDNA for infrastructure and application monitoring

2. Application
  - A horizontally scaleable web application deployed into a two different availability zones
  - Multiple database servers across two availability zones
  - A master/slave data replication strategy across availability zones

## VPC Architecture
Below is the IBM Virtual Private Cloud (VPC) architecture of the solution showing public isolation for both Application (through a Load Balancer) and data.

### Infrastructure Architecture
![3tier Web App - Infrastructure](/docs/images/infrastructure-architecture.png)

### Application Architecture
![3tuer Web App - Application](docs/images/application-data-flow.png)

#### *Not depicted in drawings*
- VPNaaS or any VPN Connections
- Cloud Internet Services (GLB function or DNS)
- Management Flows

## Assumptions and Limitations

- This documentation is meant to be used for illustrative and learning purposes primarily. 
- This document expects the reader to have a basic level of understanding of network infrastructure, Terraform, Ansible and application deployment on a Linux environment.
- The solution will implement HTTP only for simplicity.
- A MySQL database server was implemented on Infrastructure versus as-a-service to illustrate both the ability to define logical tiers between subnets as well
as to show the ability to automate deployment and configuration tasks.
- Ansible is used for all post configuration tasks.


## VPC Functional Coverage
| Function | Demonstrated | Notes |
| -------- | ------ | ----- |
| VPC | :white_check_mark: | |
| Terraform | :white_check_mark: | |
| Ansible | :white_check_mark: | |
| Resource Groups | :white_check_mark: | Assigned, but assumed to be created already. |
| Access Groups | :white_check_mark: | Inherited, but assumed to already be created |
| Subnets | :white_check_mark: | |
| Private (RFC1918) IP (BYOIP) | :white_check_mark: | |
| ACLs | :white_check_mark: | |
| Security Groups | :white_check_mark: | |
| Virtual Server Instance (VSI) | :white_check_mark: | |
| Cloud-init | :white_check_mark: | Package installation and configuration beyond base OS image. |
| Secondary Storage |  | Not used in this scenario |
| Multiple Network Interfaces in VSI | :white_check_mark: | |
| Load Balancer as a Service | :white_check_mark: | Public Only |
| Floating IPv4 |  | Not required for workload. |
| Public Gateway | :white_check_mark: |  |
| VPNaaS | :white_check_mark: | |
| Cloud Internet Services (CIS) | :white_check_mark: | GLB configured for illustrative purposes with DDOS proxy |
| IBM Cloud Monitoring with Sysdig | :white_check_mark: | Public endpoint used |
| IBM Cloud Log Analysis with LogDNA | :white_check_mark: | Public endpoint Used

### System Requirements

#### Operating system

| Tier  | Operating system |
| ------------- | ------------- |
| Web Server & Application | Ubuntu 16.04  |
| Data  | Ubuntu 16.04  |

#### Hardware

| Tier | Type | Profile |
| ------------- | ------------- | ------- |
| Web Server and Application  |  VSI | cc1-2x4 |
| Data| VSI  | bc1-4x16 |

#### Runtime Services

| Service Name | Demonstrated | Notes
| ------------ | ------------ | -----
| Cloud Internet Services (CIS) GLB | :white_check_mark: | GLB configured for illustrative purposes with DDOS proxy.  Alternatively a CNAME could have been used to publish the application URL. |
| IBM Cloud Monitoring with Sysdig | :white_check_mark: | Public endpoint used |
| IBM Cloud Log Analysis with LogDNA | :white_check_mark: | Public endpoint Used |
| IBM Cloud Databases | | A VSI based instance of MySQL was chosen instead of a Database-as-a-Service capability to illustrate both the ability to create logial network constructs and security and the ability to use Terraform and Ansible to configure the environment.|

## Documented Steps

### Prerequisites

The following software needs to be installed:
1. Terraform 0.11 or greater
2. [IBM Cloud Terraform Provider version 0.17.1](https://github.com/IBM-Cloud/terraform-provider-ibm) 
2. Ansible 2.8

The following must be configured prior to running Terraform / Ansible
1. A Public SSH key as described in [SSH Keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys).
2. A resource group exists and is referenced in configuration as described in [Managing resource groups](https://cloud.ibm.com/docs/resources?topic=resources-rgs#rgs)
3. User permissions and the required access as described in [Managing user permissions for VPC resources](https://cloud.ibm.com/docs/vpc?topic=vpc-managing-user-permissions-for-vpc-resources)

### Deploy VPC Infrastructure using Terraform & Ansible

1. [Deploy Infrastructure using Terraform](docs/terraform.md)
2. [Establish site-to-site VPN](docs/vpn.md)
3. [Configure Application Layer using Ansible](docs/ansible.md)


## Additional Documentation Provided

Useful links for Terraform and Ansible

[Terraform Documentation](https://www.terraform.io/docs/index.html)

[The IBM Cloud Provider for Terraform Documentation](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.1/)

[Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)


Useful links for IBM Cloud VPC documentation.

[Getting started with IBM Cloud Virtual Private Cloud](https://cloud.ibm.com/docs/vpc?topic=vpc-getting-started)

[Assigning role-based access to VPC resources](https://cloud.ibm.com/docs/vpc?topic=vpc-resource-authorizations-required-for-api-and-cli-calls)

[IBM Cloud CLI for VPC Reference](https://cloud.ibm.com/docs/vpc?topic=vpc-infrastructure-cli-plugin-vpc-reference)

[VPC API](https://cloud.ibm.com/apidocs/vpc)


