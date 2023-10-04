terraform {

  cloud {
    organization = "CG_Tokyo"

    workspaces {
      name = "tokyo-terraform-cloud"
    }
 }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }

  required_version = ">= 1.1.2"
}
