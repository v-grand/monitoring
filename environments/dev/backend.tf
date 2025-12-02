# backend.tf in environments/dev

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket" # REPLACE WITH YOUR S3 BUCKET NAME
    key            = "infra-monitoring/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "your-terraform-state-lock" # REPLACE WITH YOUR DYNAMODB TABLE NAME
  }
}
