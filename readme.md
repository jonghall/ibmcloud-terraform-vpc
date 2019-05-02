## IBMCLOUD-TERRAFORM-VPC
A typical requirement for a Virtual Private Cloud (VPC) is the ability to logically isolate a public cloud into different private networks made up tiers and/or different applications environments.
Within each VPC your application will need to leverage different availability zones to increase the resilience of the application.   Building the contstruct for the network and security accross VPC's,
Availability Zones, and the individule network subnets can be tedious to implement manually.

The IBM Cloud Terraform provider can simplify the setup, and make managing the infratsructure easier.    The included Terraform plan will create the specified VPC, security-groups, network acls,
subnets, compute resources and the required public and private load balancers accross the desired availability zones within the region specified.

## Typical Application Topology
A typical Ecommerce web app deployed accross 3 or 3 zones consisting of 3 segmented network tiers using IBM Cloud Object Storage for images/media, and a VPN for on-premise API services.  Separate VPCs are created to completely isolate PROD from DEV environments.  

![](topology.png?raw=true)
