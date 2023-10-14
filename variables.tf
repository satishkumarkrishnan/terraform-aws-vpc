variable "ami" {
  type    = string
  default = "ami-0a2e10c1b874595a1"
}

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

variable "vpc" {
  type    = string
  default = "Tokyo Virtual Private Cloud"
}
variable "vpc_CIDR" {
  default = "10.0.0.0/16"
}

###################################################################################
################### Start - AWS Network configuration variables ###################
###################################################################################

variable "private_subnet" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "acl" {
  type = map(string)
  default = {
    "vpc"     = "Tokyo VPC ACL"
    "public"  = "Tokyo Private ACL"
    "private" = "Tokyo Private ACL"
  }
}
#Create security groups dynamically
/*variable "security-group" {
  type = map(string)
  default = {
    "frontend" = "Tokyo Frontend Security Group"
    "backend"  = "Tokyo Backend Security Group"
  }
}
*/
variable "ingress_rule" {
  description = "Ingress Rule for VPC"
  default     = {
    "my ingress rule" = {
      description = "For HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    "2nd ingress rule" = {
      description = "All ports Allowed"
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }

  }
}

variable "egress_rule" {
  description = "Egress Rule for VPC"
  default     = {
    "my egress rule" = {
      description = "For HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    "2nd egress rule" = {
      description = "All ports Allowed"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}

variable "internet-gateway" {
  type    = string
  default = "Tokyo Internet Gateway"
}

variable "route-table" {
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
