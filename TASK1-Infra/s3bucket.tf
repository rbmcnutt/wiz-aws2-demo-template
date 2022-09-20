resource "aws_s3_bucket" "wizdemo-bucket" {
    bucket = var.my_bucket_name 
    // acl = "public-read"
}
