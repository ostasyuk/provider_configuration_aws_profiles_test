terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.1"
    }
  }
}
resource aws_s3_bucket_object "obj1" {
  bucket = var.bucket_name
  key    = "obj4"
  content = "obj4 content"
}
