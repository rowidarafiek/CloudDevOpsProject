terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

#  backend "s3" {
#    bucket         = "clouddevops-tfstate-1763206314"
#    key            = "terraform.tfstate"
#    region         = "us-east-1"
#    dynamodb_table = "terraform-state-lock"
#    encrypt        = true
#   }
}
