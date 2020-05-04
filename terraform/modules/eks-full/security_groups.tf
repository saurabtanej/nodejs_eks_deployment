module "security-group-alb-public" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.8.0"

  name            = "${var.project_name}-sg-alb-public"
  description     = "ALB Public SG"
  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  egress_rules = ["all-all"]

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = var.my_home_IP
      description = "Office TCP 80"
    }
  ]

  tags = merge(local.common_tags, { "Role" = "security-group" })
}

module "security-group-eks-worker-access" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"

  name            = "${var.project_name}-sg-eks-worker-access"
  description     = "EKS worker access SG"
  vpc_id          = module.vpc.vpc_id
  use_name_prefix = false

  egress_rules = ["all-all"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-tcp"
      source_security_group_id = module.security-group-alb-public.this_security_group_id
      description              = "ALB Public TCP ALL"
    }
  ]

  tags = merge(local.common_tags, { "Role" = "security-group" })
}
