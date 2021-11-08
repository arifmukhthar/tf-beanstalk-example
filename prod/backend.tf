terraform {
  backend "s3" {
    bucket  = "BUCKET_NAME"
    profile = "s3_bucket_acc_profile"
    region  = "us-east-1"
    key     = "BUCKETNAME/prod/test-service"
  }
}
