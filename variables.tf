variable "region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Provisioned by Terraform"
}


###################################################################################
################### Start - AWS Network configuration variables ###################
###################################################################################
variable "vpc" {
  type    = string
  default = "Tokyo Virtual Private Cloud"
}

variable "subnet" {
  type = map(string)
  default = {
    "frontend" = "Tokyo Frontend subnet"
    "backend"  = "Tokyo Backend subnet"
  }
}

variable "acl" {
  type = map(string)
  default = {
    "vpc"     = "Tokyo VPC ACL"
    "public"  = "Tokyo Public ACL"
    "private" = "Tokyo Private ACL"
  }
}

variable "security-group" {
  type = map(string)
  default = {
    "frontend" = "Tokyo Frontend Security Group"
    "backend"  = "Tokyo Backend Security Group"
  }
}

variable "internet-gateway" {
  type    = string
  default = "Tokyo Internet Gateway"
}

variable "routetable" {
  type = map(string)
  default = {
    "public" = "Tokyo Public Route Table"
  }
}

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}

variable "dnsHostNames" {
  default = true
}

variable "cidr" {
  type = map(string)
  default = {
    "vpc"      = "10.0.0.0/16"
    "frontend" = "10.0.1.0/24"
    "backend"  = "10.0.3.0/24"
  }
}

variable "azs" {
  type = map(string)
  default = {
    "az1" = "ap-northeast-1a"
    "az2" = "ap-northeast-1c"
  }
}

variable "allIPsCIDRblock" {
  default = "0.0.0.0/0"
}

variable "mapPublicIP" {
  default = true
}
#################################################################################
################### End - AWS Network configuration variables ###################
#################################################################################


variable "ssh_user" {
  type    = string
  default = "ec2-user"
}

variable "keypair" {
  type = map(string)
  default = {
    "key_name"   = "tokyo-aws-key"
    "public_key" = "tokyo-aws-key.pub"
  }
}
#===========================================================================
#================== End - AWS EC2 configuration variables ==================
#===========================================================================