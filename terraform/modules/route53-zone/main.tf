/**
 * ## Route53 zone module
 *
 * Module example as public zone:
 *
 *     module "foo" {
 *       source = "./modules/route53-zone"
 *       name   = "example.com"
 *     }
 *
 * Module example as private zone:
 *
 *     module "foo" {
 *       source  = "./modules/route53-zone"
 *       name    = "example.com"
 *       vpc_ids = ["vpc-12345"]
 *     }
 *
 */

resource "aws_route53_zone" "default" {
  name = var.name
  dynamic "vpc" {
    for_each = var.vpc_ids
    content {
      vpc_id = vpc.value
    }
  }
  tags = merge(var.tags,
    {
      Name        = var.name,
      Environment = terraform.workspace,
      Role        = "route53-zone",
      Project     = var.tag_project,
      Owner       = var.tag_owner,
      Terraform   = "true"
    }
  )
}
