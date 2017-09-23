# Create a S3 bucket for storing terraform State

resource "aws_s3_bucket" "my-terraform-state" {
  bucket = "${var.s3_bucket}"
  versioning {
    enabled = true
  }
  # Keep bucket when destroying
  lifecycle {
    prevent_destroy = true
  }
}

output "s3_bukcet_arn" {
  value = "${aws_s3_bucket.my-terraform-state.arn}"
}