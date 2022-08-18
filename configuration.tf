terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "jmguimaraes"

    workspaces {
      name = "portifolio-ws"
    }
  }
}