terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "xxxxxxxxxxxxxx"

    workspaces {
      name = "xxxxxxxxxxx"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = var.default_region
}
