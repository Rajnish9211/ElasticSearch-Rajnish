terraform {
  backend "s3" {
    bucket         = "rajnish-bucket-31-ninja"   # Must be globally unique
    key            = "terraform.tfstate"   # Path in bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"        # For state locking
    encrypt        = true
  }
}