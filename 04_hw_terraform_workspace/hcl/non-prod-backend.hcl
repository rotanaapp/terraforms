# bucket = "nonprod-demo-terraform-state
# key    = "terraform-env.tfstate"
# region = "us-east-1"
# dynamodb_table = "terraform-state"
# workspace_key_prefix = "environment"

terraform {
  backend "s3" {
    bucket         = "nonprod-demo-terraform-state"
    key            = "terraform-env.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
    workspace_key_prefix = "environment"
  }
}
