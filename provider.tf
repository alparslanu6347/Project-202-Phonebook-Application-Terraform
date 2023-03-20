terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


provider "github" {
  token = "***********************" // you must write your token
}