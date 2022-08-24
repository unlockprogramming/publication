terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {}
}
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {}
variable "release_name" {}
variable "acm_cert_arn" {}

module "site" {
  source       = "git::https://github.com/bhuwanupadhyay/terraform-modules.git//aws/s3-static-website?ref=develop"
  domain_name  = "unlockprogramming.com"
  bucket_name  = "unlockprogramming.com"
  release_name = var.release_name
  common_tags  = {
    env = "production"
  }
  acm_cert_arn = var.acm_cert_arn
}