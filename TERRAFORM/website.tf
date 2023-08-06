terraform {                                  #terraform aws provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
    access_key = "AKIATVX5SBZQ4UU64Y6Y"
    secret_key = "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"

  
}

 #### create s3 bucket --------------------------------------------

resource "aws_s3_bucket" "mybucket" {
  bucket = var.s3_bucket_name
}

# s3 bucket ownership ---------------------------------------------

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id          

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "accessblock" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#s3 bucket acl (access control list) "enable you to manage to access to s3 bucket and object"-------------------

resource "aws_s3_bucket_acl" "s3bucketacl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

#create aws object (key,source,acl)------------------------------------

#for index.html-------------------

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}


#for index.html--------------------

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}

#for profile.png---------------
resource "aws_s3_object" "profile" {
    bucket = aws_s3_bucket.mybucket.id
    key = "profile.png"
    source = "profile.png"
    acl = "public-read"

}

#aws s3 bucket website configuration --------------------------------------

resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.mybucket.id

    index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket.mybucket ]
  
}