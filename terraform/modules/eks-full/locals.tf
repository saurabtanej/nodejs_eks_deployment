locals {
  common_tags = {
    Owner       = "DevOps Team"
    Project     = "${var.project_name}"
    Environment = terraform.workspace
    Region      = var.aws_region
  }
}
