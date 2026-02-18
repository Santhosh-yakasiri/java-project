terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --- keep your resources below ---

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "santhosh-test-bucket-${random_integer.suffix.result}"
}