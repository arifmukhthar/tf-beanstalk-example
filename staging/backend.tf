terraform {
  backend "s3" {
    bucket  = "terraform-example-mulder"
    profile = "terraform_testing"
    region  = "us-east-1"
    key     = "tf-states/staging/test-service"
  }
}
