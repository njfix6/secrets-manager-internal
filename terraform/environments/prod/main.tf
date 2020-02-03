terraform {
  backend "s3" {
    bucket         = "limebike-terraform"
    key            = "tf-secret-manager-prod"
    region         = "us-west-2"
    dynamodb_table = "terraform-states"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"
}

module "secrets_manager_ci_pipeline" {
  source = "../../modules/ci"
}