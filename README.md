
# VPC peering setup between VPC1 and VPC2

# What is VPC peering?
AWS VPC peering is a networking feature that allows you to connect two Virtual Private Clouds (VPCs) within the same or different AWS regions, enabling instances in each VPC to communicate with each other as if they were on the same network, using private IP addresses to route traffic between them; essentially creating a direct, private network link between the VPCs without going through the public internet or a VPN connection. 

    Key points about VPC peering:

    Functionality:
    It lets you establish a connection between two VPCs, enabling resources in one VPC to access resources in the other as if they were on the same network. 
    Private communication:
    Traffic between peered VPCs uses private IP addresses and does not traverse the public internet. 

    Cross-account and region capability:
    You can peer VPCs within the same AWS account or across different accounts, and even in different AWS regions. 

    Route table configuration:
    To enable communication between peered VPCs, you need to update the route tables on both sides of the peering connection. 

    Benefits:
    Simplified network architecture: Allows for building complex multi-VPC designs by connecting different parts of your network seamlessly. 
    Cost-effective communication: Traffic between peered VPCs is routed within the AWS network, minimizing network costs. 
    Improved latency: Direct connection between VPCs provides low-latency communication. 

    How to create a VPC peering connection:
    Access the VPC console in AWS.
    Select "Peering connections".
    Choose "Create peering connection".
    Specify the VPCs you want to peer (from your account or another account).
    (Optional) Add tags for identification
    Initiate the peering connection request.
    The owner of the "accepter" VPC must accept the connection. 

# Pricing for a VPC peering connection

There is no charge to create a VPC peering connection. All data transfer over a VPC peering connection that stays within an Availability Zone is free, even if it's between different accounts. Charges apply for data transfer over VPC peering connections that cross Availability Zones and Regions. For more information, see Amazon EC2 Pricing.