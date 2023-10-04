#######################################################
################### Start - AWS VPC ###################
#######################################################

resource "aws_vpc" "tokyo-vpc" {
  cidr_block           = var.cidr["vpc"]
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
    Name = var.routetable["public"]
  }
}

# Create Internet route access
resource "aws_route" "tokyo-internet-route" {
  route_table_id         = aws_route_table.tokyo-public-route.id
  destination_cidr_block = var.allIPsCIDRblock
  gateway_id             = aws_internet_gateway.tokyo-igw.id
}

# Create Subnets
resource "aws_subnet" "tokyo-frontend-subnet" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.tokyo-vpc.id
  cidr_block              = var.cidr["frontend"]
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.azs["az1"]
  tags = {
    Name = "Tokyo-Frontend-Subnet"
  }
}

resource "aws_subnet" "tokyo-backend-subnet" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.tokyo-vpc.id
  cidr_block              = var.cidr["backend"]
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.azs["az2"]
  tags = {
    Name = "Tokyo-Backend-Subnet"
  }
}


# Create Network Access Control Lists
resource "aws_network_acl" "tokyo-frontend-acl" {
  vpc_id     = aws_vpc.tokyo-vpc.id
  subnet_ids = [aws_subnet.tokyo-frontend-subnet[0].id]

  # allow ingress ephemeral ports from all IPs
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
    Name = var.acl["public"]
  }
}

resource "aws_network_acl" "tokyo-backend-acl" {
  vpc_id     = aws_vpc.tokyo-vpc.id
  subnet_ids = [aws_subnet.tokyo-backend-subnet[0].id]

  # allow ingress ephemeral ports from all IPs
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
    Name = var.acl["private"]
  }
}

# Create Security Groups
resource "aws_security_group" "tokyo-frontend-securitygroup" {
  vpc_id = aws_vpc.tokyo-vpc.id

  # allow ingress HTTP from port  80 all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 0
    to_port     = 65535
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

  # allow egress ephemeral ports to all IPs
  egress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }
  tags = {
    Name = var.security-group["frontend"]
  }
}

resource "aws_security_group" "tokyo-backend-securitygroup" {
  vpc_id = aws_vpc.tokyo-vpc.id

  # allow ingress HTTP port 8080 from all IPs
  ingress {
    cidr_blocks = [var.allIPsCIDRblock]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }
  tags = {
    Name = var.security-group["backend"]
  }
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "tokyo-frontend-association" {
  subnet_id      = aws_subnet.tokyo-frontend-subnet[0].id
  route_table_id = aws_route_table.tokyo-public-route.id
}

resource "aws_route_table_association" "tokyo-backend-association" {
  subnet_id      = aws_subnet.tokyo-backend-subnet[0].id
  route_table_id = aws_route_table.tokyo-public-route.id
}

#####################################################
################### End - AWS VPC ###################
#####################################################