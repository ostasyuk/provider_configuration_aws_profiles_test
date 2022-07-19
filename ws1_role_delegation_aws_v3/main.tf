terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.1.0"
    }
  }
}
resource aws_s3_bucket_object "obj1" {
  bucket = var.bucket_name
  key    = "obj1"
  content = "obj1 content"
}
