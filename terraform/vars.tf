variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_region_azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "iam_username" {
  default = "saurabh.taneja"
}

variable "route53_public_hosted_zone" {
  default = "test.net"
}

variable "app_name" {
  default = "tinyurl"
}

variable "app_namespace" {
  default = "app"
}
