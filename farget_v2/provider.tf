provider "aws" {
  # region = "us-east-1" # Specify your desired AWS region
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
