provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

module "pipeline" {
  source                  = "../"
  namespace               = "agn-ci"
  stage                   = "dev"
  name                    = "packer-pipeline"
  vpc_cidr                = "10.88.129.0/24"
  subnets_cidr            = "10.88.129.0/26"
  oidc_gitlab_match_value = ["..."]
  tags = {
    Test = "testing"
  }
}

output "pipeline" {
  value     = module.pipeline
  sensitive = true
}
