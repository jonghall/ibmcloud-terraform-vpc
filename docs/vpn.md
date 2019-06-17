# Connecting to the VPC Infrastructure
This project assumes only public Internet traffic will be allowed to access the Web/Application servers via the Load Balancer Service
which is listening on TCP port 80.  The security groups and network acls prevent direct connectivity via SSH except through the VPN tunnel.
A less secure approach would have been to attach floating public IP's to the VSIs and allow specific IP addresses to communicate over the public
Internet.   However, to demonstrate how the VPC can be secured the choice to use a VPN was made.  The security group and network ACLs configured in
this project allow all network traffic from the on-prem network, but additional security could be implemented by restricting the specific protocols
and ports.

### Prerequisites

1. Infrastructure has been successfully provisioned using the Terraform plan in the previous step

2. a pre-shared-key was identified and was correctly specified in the terraform variables section

3. The on-prem CIDR block was identified and correctly specified in the terraform variables section

4. An on-prem VPN concentrator is available and you have the ability to configure remote connections to the VPC VPN on it

## Steps to establish a site-to-site VPN from your on-prem VPN to the VPC

We will establish two IPSEC connections between a local on-prem VPN and the VPNaaS instances in the VPC zone 1 and zone 2
which were created as part of the Terraform Plan exeuction.   You only need to configure the on-prem instance

1. Configure the phase 1 parameters required to authenticate the remote peers `zone1-vpn-peer` and `zone2-vpn-peer` noted on the output of the Terraform execution
    - Use `IKEv2` for authentication
    - Use `DH-group 2` in the phase 1 proposal
    - Use `lifetime = 36000` in the phase 1 proposal
2. Configure the phase 2 parameters for required to create the VPN tunnel with `zone1-vpn-peer` and `zone2-vpn-peer` noted on the output of the Terraform execution
    - Disable `PFS` in the Phase 2 proposal
    - Set `lifetime = 10800`
    - Specify the local and remote subnets that match what was specified in the `variables.tf` file for zone 1 and zone2
    - Use the preshared key specificed in the `variables.tf` file. 
3. Specify the pre-shared-secret which was specified in the `variables.tf` file.
4. Save configuration
5. Start VPN connections
6. Test connectivity to the VPC
6. Once connectivity is established proceed to [Configuring the Application Layer using Ansible](ansible.md)


## Documentation for different VPN concentrators
[Creating a secure connection with a remote Juniper vSRX peer](https://cloud.ibm.com/docs/vpc-on-classic-network?topic=vpc-on-classic-network-creating-a-secure-connection-with-a-remote-juniper-vsrx-peer)
[Creating a secure connection with a remote Cisco ASAv peer](https://cloud.ibm.com/docs/vpc-on-classic-network?topic=vpc-on-classic-network-creating-a-secure-connection-with-a-remote-cisco-asav-peer)
[Creating a secure connection with a remote FortiGate peer](https://cloud.ibm.com/docs/vpc-on-classic-network?topic=vpc-on-classic-network-creating-a-secure-connection-with-a-remote-fortigate-peer)
[Creating a secure connection witha remote StrongSwan peer](https://cloud.ibm.com/docs/vpc-on-classic-network?topic=vpc-on-classic-network-creating-a-secure-connection-with-a-remote-strongswan-peer)
[Creating a secure connection with a remote Vyatta peer](https://cloud.ibm.com/docs/vpc-on-classic-network?topic=vpc-on-classic-network-creating-a-secure-connection-with-a-remote-vyatta-peer
)