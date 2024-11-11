provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "pipeline" {
  source       = "../"
  namespace    = "agn-ci"
  stage        = "dev"
  name         = "packer-pipeline"
  vpc_cidr     = "10.88.129.0/24"
  subnets_cidr = "10.88.129.0/26"
  tags = {
    Test = "testing"
  }
}

output "pipeline" {
  value     = module.pipeline
  sensitive = true
}
