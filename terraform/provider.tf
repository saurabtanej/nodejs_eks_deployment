provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

provider "helm" {
  version = "= 1.0.0"
}
