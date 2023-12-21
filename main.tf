terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}
#######################################################
################### Start - AWS VPC ###################
#######################################################

# Create Default VPC

resource "aws_default_vpc" "default-tokyo-vpc" {
 force_destroy = "true"
  tags = {
    Name = var.vpc
  }
}

# Create Default Subnet

resource "aws_default_subnet" "tokyo_default_az1" {
  availability_zone = "ap-northeast-1a"
  force_destroy = "true"
   tags = {
    Name        = "tokyo-subnets-default"
  }  
}
resource "aws_vpc" "tokyo-vpc" {
  cidr_block           = var.vpc_CIDR
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = var.vpc
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "tokyo-igw" {
  vpc_id = aws_vpc.tokyo-vpc.id
  tags = {
    Name = var.internet-gateway
  }
  
}

# Create Route Tables
resource "aws_route_table" "tokyo-public-route" {
  vpc_id = aws_vpc.tokyo-vpc.id
  tags = {
    Name = var.route-table["public"]
  }
}

# Create Internet route access
resource "aws_route" "tokyo-internet-route" {
  route_table_id         = aws_route_table.tokyo-public-route.id
  destination_cidr_block = var.allIPsCIDRblock
  gateway_id             = aws_internet_gateway.tokyo-igw.id
}



# Create Subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet)
  vpc_id                  = aws_vpc.tokyo-vpc.id
  cidr_block              = var.private_subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.mapPublicIP
  
  tags = {
    Name        = "tokyo-subnets-${count.index}"
  }
}

# Create Network Access Control Lists
resource "aws_network_acl" "tokyo-nacl" {
  count  = length(var.private_subnet)
  vpc_id = aws_vpc.tokyo-vpc.id
  subnet_ids = [aws_subnet.private[count.index].id]
    # allow ingress HTTP from port  80 all IPs
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allIPsCIDRblock
    from_port  = 0
    to_port    = 65535
  }

  # allow egress ephemeral ports to all IPs
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allIPsCIDRblock
    from_port  = 0
    to_port    = 65535
  }
    tags = {
      Name = "tokyo-sg-${count.index}"
    }
  }

# Create Security Groups
resource "aws_security_group" "tokyo-securitygroup" {
  count  = 2
  vpc_id = aws_vpc.tokyo-vpc.id

  # allow ingress HTTP from port  80 all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # allow ingress HTTPS port 443 from all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  # allow ingress HTTPS port 22 from all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

# Allow ingress and egress for EFS mount target
  ingress {
  description = "EFS mount target"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
  description = "EFS mount target"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  # allow egress ephemeral ports to all IPs
  egress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }
  tags = {
    Name = "tokyo-sg-${count.index}"
  }
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "tokyo-rt-association" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.tokyo-public-route.id
}

#####################################################
################### End - AWS VPC ###################
#####################################################