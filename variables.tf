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

variable "subnet" {
  type = map(string)
  default = {
    "frontend" = "Tokyo Frontend subnet"
    "backend"  = "Tokyo Backend subnet"
  }
}

variable "security-group" {
  type = map(string)
  default = {
    "frontend" = "Tokyo Frontend Security Group"
    "backend"  = "Tokyo Backend Security Group"
  }
}
#=============================================================================
#================== Start - AWS EC2 configuration variables ==================
#=============================================================================
variable "ami" {
  type    = string
  default = "ami-0a2e10c1b874595a1"
}

variable "key_name" {
  type    = string
  default = "ec2-key"
}
