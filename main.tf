
locals {
  cidr_block_vpc1 = "144.0.0.0/16"
  cidr_block_vpc2 = "44.0.0.0/16"
  cidr_block_subnet1 = "144.0.0.0/24"
  cidr_block_subnet2 = "44.0.0.0/24"
  cidr_block_0 = "0.0.0.0/0"

  az_us_1a = "us-east-1a"
  az_us_1b = "us-east-1b"
}

# Create VPC
resource "aws_vpc" "vpc1" {
  cidr_block = local.cidr_block_vpc1
  enable_dns_hostnames = true
  tags = {Name = "${var.prefix}-VPC-1"}
}
resource "aws_vpc" "vpc2" {
  cidr_block = local.cidr_block_vpc2
  enable_dns_hostnames = true
  tags = {Name = "${var.prefix}-VPC-2"}
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw_vpc1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {Name = "${var.prefix}-IGW-VPC1"}
}
resource "aws_internet_gateway" "igw_vpc2" {
  vpc_id = aws_vpc.vpc2.id
  tags = {Name = "${var.prefix}-IGW-VPC2"}
}

# Create routing table and routes
resource "aws_route_table" "rt_vpc1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = local.cidr_block_0
    gateway_id = aws_internet_gateway.igw_vpc1.id
  }
  route {
    cidr_block = local.cidr_block_vpc2
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id  # add vpc peer into route, or added in "vpc1_to_vpc2" block
  }
  tags = {Name = "${var.prefix}-RouteTable-VPC1"}
}

resource "aws_route_table_association" "rta_vpc1" {
  subnet_id      = aws_subnet.subnet_vpc1.id
  route_table_id = aws_route_table.rt_vpc1.id
}

# Create routing table and routes
resource "aws_route_table" "rt_vpc2" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block = local.cidr_block_0
    gateway_id = aws_internet_gateway.igw_vpc2.id
  }
  route {
    cidr_block = local.cidr_block_vpc1
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id  # add vpc peer into route, or added in "vpc1_to_vpc2" block
  }
  tags = {Name = "${var.prefix}-RouteTable-VPC2"}
}
output "output-rt-vpc2" {value=aws_route_table.rt_vpc2.*}

resource "aws_route_table_association" "rta_vpc2" {
  subnet_id      = aws_subnet.subnet_vpc2.id
  route_table_id = aws_route_table.rt_vpc2.id
}
output "output-rt-assoc-vpc2" {value=aws_route_table_association.rta_vpc2.*}


# Create Subnet
resource "aws_subnet" "subnet_vpc1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = local.cidr_block_subnet1
  availability_zone = local.az_us_1a
  map_public_ip_on_launch = true    # public access

  tags = {
    Name = "${var.prefix}-Subnet-VPC1"
  }
}

# Create Subnet
resource "aws_subnet" "subnet_vpc2" {
  vpc_id            = aws_vpc.vpc2.id
  cidr_block        = local.cidr_block_subnet2
  availability_zone = local.az_us_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-Subnet-VPC2"
  }
}

# Create VPC peering
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.vpc1.id
  peer_vpc_id = aws_vpc.vpc2.id
  auto_accept = true

  tags = {
    Name = "${var.prefix}-VPC-Peering"
  }
}

# add peer route to rt-vpc1
/* resource "aws_route" "vpc1_to_vpc2" {
  route_table_id         = aws_route_table.rt_vpc1.id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
output "output-v12v2-route" {value=aws_route.vpc1_to_vpc2.*} */

# add peer route to vpc2 default route
/* resource "aws_route" "vpc2_to_vpc1" {
  route_table_id         = aws_vpc.vpc2.default_route_table_id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
} */


