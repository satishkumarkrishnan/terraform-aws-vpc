terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
resource "aws_instance" "example" {
  ami           = "ami-0a2e10c1b874595a1"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}
